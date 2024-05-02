#import "../../lib.typ": *

=== Graph Representation <s.graph-representation>

#kristoffer[
  talk about how our graph representation is different from theirs.
  Ours is more faithful to how robots would represent the other robots in the environment
  compared to theirs, since they use bidirectional `std::shared_ptr`, which is not useable
  in a scenario where the algorithm run on different computer hosts, or just computer processes on the same host.
]


There are several different ways of representing graph structures in computer memory. Each with its own advantages and disadvantages. As explained in @s.b.factor-graphs, the factorgraph structure is a bipartite graph with undirected edges.
Such a graph structure enforces little to no constraints on what kind of memory representation are possible to use #note.kristoffer[find citation for this statement]. In the original work by Patwardhan _et al._@gbpplanner a cyclic reference/pointer structure is used. They represent the graph with a C++ class called `FactorGraph`, which each robot instance inherit from. Variable and factor nodes are stored in two separate vectors; `factors_` and `variables_`, as shown in the top of @code.gbpplanner-factorgraph.

#show figure.where(kind: "code"): fig => {
  fig
  // fig.caption
}

// #figure(
//   kind: "code",
//   supplement: [Code Snippet],
//   caption: "FactorGraph",
// )

#kristoffer[Add static link to github, and a line range]

#sourcecode-reference([
  ```cpp
  // defined in `inc/gbp/FactorGraph.h`
  class FactorGraph {
  public:
    std::vector<std::shared_ptr<Factor>> factors_;
    std::vector<std::shared_ptr<Variable>> variables_;
    // ...
  };

  // defined in `inc/gbp/Factor.h`
  class Factor {
  public:
    // Vector of pointers to the connected variables. Order of variables matters
    std::vector<std::shared_ptr<Variable>> variables_{};
    // ...
  };

  // defined in `inc/gbp/GBPCore.h`
  class Key {
    public:
    int robot_id_;
    int node_id_;
  };

  // defined in `inc/gbp/Variable.h`
  class Variable {
  public:
    // Map of factors connected to the variable, accessed by their key
    std::map<Key, std::shared_ptr<Factor>> factors_{};
    // ...
  }
  ```
], caption: [`FactorGraph` class declaration in `inc/gbp/FactorGraph.h` #kristoffer[write proper caption]]) <code.gbpplanner-factorgraph>

Edges between variable and factors are not stored as separate index values, but are instead implicitly stored by having each factor storing a `std::shared_ptr<Variable>` to every variable it is connected to. Complementary every variable stores a `std::shared_ptr<Factor>` to every factor it is connected to. This kind of structure is advantageous in that it easy access the neighbours of node, given only a handle to the node. For example to send messages to the neighbours of a node by directly invoking methods on the receiving node directly. #note.k[mention that their representation does not map well/reflect how each robot would represent connections to external robots when running on different hosts]
This structural pattern however is difficult to implement and discouraged in Rust due to its unique language feature for managing memory; the ownership model. This model is comprised of three rules, that together ensures memory safety and prevents memory issues like use after free and memory leaks@the-rust-book.

+ Each value has exactly one _owner_
+ There can only be one owner at a time.
+ When the owner goes out of scope, the value is dropped #footnote([In Rust the term "dropped" is the preferred term to communicate that a value is destructed and its memory deallocated.]).

One limitation of this system is that data structures with interior bidirectional references like the gbpplanners factor graph representation are difficult to express, since there is no conceptual single owner of the graph. If a factor and a variable that are connected, both share a reference to the memory region of each other, then there is not a well defined concept of who owns who. Difficult does not mean impossible, and there are ways to express these kinds of data structures using a Rust specific design pattern called the  _Interior Mutability_ pattern@the-rust-book. We decided not to use this pattern and instead work within the intended modelling constructs of the Rust language. In the reimplementation the graph data structure uniqly owns all the variable and factor nodes. And nodes in the in the graph store no interior references to nodes they are connected to. The _petgraph_ library is used for the actual graph datastructure. petgraph is a versatile and performant graph data structure library providing various generic graph data structures with different performance characteristics@petgraph. To choose which graph representation to use the following requirements were considered. The requirements are ordered by priority in descending order:

+ Dynamic insertion and deletion of nodes. Robots connect to each others factorgraph when they both are within the communication radius of each other and both their communication mediums are active/reachable. Likewise they disconnect when they move out of each others communication or the other one is unreachable. This connection is upheld by the InterRobot factor, which gets added and removed frequently. <req.graph-representation-dynamic> // Indices into the graph needs to be stable across removal, in order to ensure the invariant too prevent issues with maintaining

+ Fast node iteration and neighbour search: In order to ensure collision free paths at tolerable speeds, the #acr("GBP") algorithm will have to run many times a second. The faster each factorgraph can be traversed the better. <req.graph-representation-fast-iteration>

+ The index of a node is valid for the lifetime of the node. Without this a lot of checks have to be added every time the factorgraph is indexed to get a reference to a node. <req.graph-representation-stable-indices>

_petgraph_ supports the following five types of graph representation:

#{
  // show table.cell.where(x: 0): strong
  // show table.header: strong
  show table.cell.where(y: 0): strong
  let cm = text(theme.green, emoji.checkmark)
  set align(center)
figure(
  table(
    columns: 5,
    align: (left, left, center, center, center),
    table.header([Name], [Description], [Space Complexity], [Backing Vertex Structure], [Dynamic]),
    table.hline(),
    [`Graph`], [Uses an _Adjacency List_ to store vertices.], [$O(|E| + |V|)$], [`Vec<N>`], [#cm],
    [`StableGraph`], [Similar to `Graph`, but it keeps indices stable across removals.], [$O(|E| + |V|)$], [`Vec<N>`],[#cm],
    [`GraphMap`], [Uses an adjacency list, but instead of storing vertices sequentially it uses generated vertex identifiers as keys into a hash table, where the value is a list of the vertices' connected edges.], [$O(|E| + |V|)*$], [`IndexMap<N>`], [#cm],
    [`MatrixGraph`], [Uses an _Adjacency Matrix_ to store vertices.], [$O(|V^2|)$], [`Vec<N>`], [#cm],
    [`CSR`], [Uses a sparse adjacency matrix to store vertices, in the #acr("CSR") format.], [$O(|E| + |V|)$], [`Vec<N>`], [#cm],
    table.hline(),
  ),
  caption: [Available Graph Representations in the `petgraph` library. $|E|$ is the number of edges and $|V|$ is the number of nodes. The "Backing Node Structure" lists which underlying data structure is used to store the associated of each vertex. `Vec<N>` #footnote([Part of Rust's standard library]) is a growable array where items are placed continuous in memory@rust-std. `IndexMap<N>` is a special hash map structure that uses a hash table for key-value indices, and a growable array of key-value pair. Allows for very fast iteration over nodes since their memory are densely stored in memory@indexmap. The "Dynamic" column labels if the data structure supports vertices/edges being removed after initialization.],
    // Graph - An adjacency list graph with arbitrary associated data.
    // StableGraph - Similar to Graph, but it keeps indices stable across removals.gn
    // GraphMap - An adjacency list graph backed by a hash table. The node identifiers are the keys into the table.
    // MatrixGraph - An adjacency matrix graph.
    // CSR - A sparse adjacency matrix graph with arbitrary associated data.
  )
}

All five graph representations support dynamic insertion and removal of vertices and edges after initialization of the graph. So all of them satisfy the first requirement. Four out of the five graph representations uses a `Vec<N>` as its underlying container for vertex instances. `Vec<N>` are guaranteed to be continuous in memory


#line(length: 100%, stroke: red + 1em)

#kristoffer[explain \* in memory section]

// Iteration is very fast since it is on the dense key-values
// A raw hash table of key-value indices, and a vector of key-value pairs


@packed-compressed-sparse-row


// / #acr("CSR"): asd
// / Adjacency list: asd
// / Adjacency matrix: $O(|V^2|)$ memory
// / GraphMap: asd

#kristoffer[do some napkin math for the size of the graph to justify why the memory of the chosen structure is not very important]

$ B("Variable") =  $
$ B("Factor") =  $

$ B(v_i) = max(B("Variable"), B("Factor")) $ <eq.factorgraph-memory-estimate>

$ B(e_i) = 0 $




Not too many nodes in the graph, so we did not spend time benchmarking the various backing memory models.


closer to real distribution

// In Rust every piece of data i.e. every variable and allocated block of memory has a single owner

In addition to storing the graph itself each factorgraph use additional memory to store arrays of node indices of each node kind, to speed iteration

// A disadvantage of this structure
// promote hiearchial data structures



Adjacency matrix
Adjacency list

one requirement the chosen graph model would need to satisfy, is the ability to update the graph structure over time,

supported fast repeated iteration

trade some speed for edge lookup time, for having indices not being invalidated

consider insertion/deletion of nodes and edges as influencers of the graph data structure.
j
#sourcecode-reference[
  ```rust
pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, u32>;
```
]

u32 denotes the space of possible indices i.e. $2^32 - 1$

// The "naive"

// interior mutability

// This pattern is diffecult to implement and discouraged in Rust due to its ownership model.

// #kristoffer[
//   explain ownership model
// ]

// Many different representations are possible for the graph, in computer memory

// The underlying graph rep



using dedicated indices arrays for factors and variables to speed up iteration for queries only requiring access to the nodes or variables.

#kristoffer[Why `StableGraph`?]


#kristoffer[Not experiment with different graph representations, e.g. matrix, csr, map based etc.]
