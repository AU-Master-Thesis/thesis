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
  let yes = text(theme.green, emoji.checkmark)
  // let no = text(theme.red, emoji.crossmark)
  let no = text(theme.red, [x])
  // let no = emoji.crossmark
  set align(center)
figure(
  table(
    // columns: (1fr, 3fr, 1fr, 1fr, 1fr, 1fr),
    columns: 7,
    align: (left, left, center, center, center, center, center),
    table.header([Name], [Description], [Space Complexity], [Backing Vertex Structure], [Dynamic], [Stable Indices], [Hashable vertices]),
    table.hline(),
    [`Graph`], [Uses an _Adjacency List_ to store vertices.], [$O(|E| + |V|)$], [`Vec<N>`], [#yes], [#no], [#no],
    [`StableGraph`], [Similar to `Graph`, but it keeps indices stable across removals.], [$O(|E| + |V|)$], [`Vec<N>`],[#yes], [#yes], [#no],
    [`GraphMap`], [Uses an associative array, but instead of storing vertices sequentially it uses generated vertex identifiers as keys into a hash table, where the value is a list of the vertices' connected edges.], [$O(|E| + |V|)*$],
    // [`IndexMap<N>`],
    [`IndexMap<N, Vec<(N, CompactDirection)>>`],
    [#yes], [#no], [#yes],
    [`MatrixGraph`], [Uses an _Adjacency Matrix_ to store vertices.], [$O(|V^2|)$], [`Vec<N>`], [#yes], [#no], [#no],
    [`CSR`], [Uses a sparse adjacency matrix to store vertices, in the #acr("CSR") format.], [$O(|E| + |V|)$], [`Vec<N>`], [#yes], [#no], [#no],
    table.hline(),
  ),
  caption: [Available Graph Representations in the `petgraph` library. $|E|$ is the number of edges and $|V|$ is the number of nodes. The "Backing Node Structure" lists which underlying data structure is used to store the associated of each vertex. `Vec<N>` #footnote([Part of Rust's standard library]) is a growable array where items are placed continuous in memory@rust-std. `IndexMap<N>` is a special hash map structure that uses a hash table for key-value indices, and a growable array of key-value pairs. Allows for very fast iteration over nodes since their memory are densely stored in memory@indexmap. The "Dynamic" column labels if the data structure supports vertices/edges being removed after initialization. The "Hashable vertices" columns list if the data structure requires that the vertex type must be hashable.],
    // Graph - An adjacency list graph with arbitrary associated data.
    // StableGraph - Similar to Graph, but it keeps indices stable across removals.gn
    // GraphMap - An adjacency list graph backed by a hash table. The node identifiers are the keys into the table.
    // MatrixGraph - An adjacency matrix graph.
    // CSR - A sparse adjacency matrix graph with arbitrary associated data.
  )
}

All five graph representations support dynamic insertion and removal of vertices and edges after initialization of the graph. So all of them satisfy the first requirement. Four out of the five graph representations uses a `Vec<N>` as its underlying container for vertex instances. `Vec<N>` are guaranteed to be continuous in memory ensuring fast iteration due to cache locality. At the same time the relative difference in iteration speed of using a the `GraphMap` structure should not really be noticeable, given that it uses an `IndexMap<N>`, which in turn uses a `Vec<(N, E)>` for its underlying storage of vertices. But it adds the additional constraint that vertices needs to be hashable, which is impractical given the lack of non-unique immutable fields of the `Node` struct#note.k[ehh... maybe `node_index` field, but Option???]. So all data structures support the second requirement. Only the `StableGraph` data structure guarantees stable indices across repeated removal and insertion. Leaving it as the sole viable choice left that meets all three requirements. Expressed using the _petgraph_ library the chosen `Graph` type is defined as:

#sourcecode-reference[
  ```rust

type IndexSize = u16; // 2^16 - 1 = 65535
pub type NodeIndex = petgraph::stable_graph::NodeIndex<IndexSize>;
pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, IndexSize>;
```
]

#kristoffer[explain `()` type parameter for edge data]

`IndexSize` is a type parameter for the upperbound of the number of nodes the graph can hold. In our experiments@s.results no individual factorgraph ever held more more than $~$#note.k[find this number], so a bound of $2^16 - 1$ was sufficient, and takes up less space than $2^32 - 1$.

// u32 denotes the space of possible indices i.e. $2^32 - 1$



In terms of space complexity all five candidates are close to equivalent, with four of them using $O(|V| + |E|)$ space, and the `MatrixGraph` using $O(|V|^2)$. Lack of sufficient/enough memory were not deemed and issue for the simulation. To support this claim let:

$ B(T) = "stack allocation of T in bytes" $

The standard library function #raw(block: false, lang: "rust", "std::mem::size_of::<T>()") is used to calculate $B(T)$@rust-std. Then the size of a `VariableNode` and a `FactorNode` is:


$ B("Variable") = 392 "bytes" $
$ B("Factor") =  408 "bytes" $

#let size_of_variable = 392
#let size_of_factor = 408

A `Node` is modelled as a tagged union of a `VariableNode` and `FactorNode` so the size of a node is, the size of the largest of the two variants, plus 8 bytes to store the tag@the-rust-book:

$ B(v_i) = max(B("Variable"), B("Factor")) + 8 "bytes" $ <eq.factorgraph-memory-estimate>

#let size_of_node = calc.max(size_of_variable, size_of_factor) + 8

No data is associated with an edge so the size of an edge is:

$ B(e_i) = 0 "bytes" $

An empty `FactorGraph` takes up:

$ B("FactorGraph") = 200 "bytes" $

#kristoffer[explain functions and meaning of variable names]

#let size_of_graph = 200

$ N_("obstacle")(\#V) = \#V - 2 $

#let n_obstacle(v) = v - 2

$ N_("dynamic")(\#V) = \#V - 1 $

#let n_dynamic(v) = v - 1

$ N_("interrobot")(\#V, \#C) = \#V times \#C $

#let n_interrobot(v, c) = v * c

$ N_("factors")(\#V, \#C) = N_("obstacle")(\#V) + N_("dynamic")(\#V) + N_("interrobot")(\#V, \#C) $

#let n_factors(v, c) = n_obstacle(v) + n_dynamic(v) + n_interrobot(v, c)

#let robots = 20
#let variables = 10

With a simulation of $\#R$ robots and $\#V$ variables, with each robot having $\#C$ connections, then the size is:

$ B("Simulation"(R, V, C))

&= R times (B("FactorGraph") + (V + N_("factors")(V, C)) times B("Node"))
$

#let size_of_simulation(r, v, c) = r * (size_of_graph + (v + n_factors(v, c)) * size_of_node)

With $R = 20, V = 10, C = 10$ the size is:

#let size_of_example = size_of_simulation(20, 10, 10)

$ B("Simulation"(20, 10, 10)) = #size_of_example "bytes" = #MiB(size_of_example) $

#MiB(size_of_example) is not a lot of memory for a modern computer. This of course, only accounts for the stack allocated memory of each structure. For heap allocated structures like dynamically sized matrices this only accounts for the heap pointer to the data and the length of the allocated buffer, and not the size of the buffer. With 4 #acr("DOF") a conservative estimate can be made by generalizing the heap allocation size of each node to be the largest heap allocation of the possible node variants. Let

$ H(T) = "heap allocation of T in bytes" $ <equ.heap-allocation-in-bytes>
$ H_("inbox")(T, C) = "heap allocation of T's inbox with C connections in bytes" $

#{
  let f64 = 8
  let DOFS = 4
  let heap_size_of_factor_state = (4 + 2 * 2 + DOFS * 2 + 4 * 8 + 4) * f64
  let heap_size_of_dynamic = 4 * 8 * f64 + heap_size_of_factor_state
  let heap_size_of_obstacle = 0 * f64 + heap_size_of_factor_state
  let heap_size_of_interrobot = 0 * f64 + heap_size_of_factor_state
  let heap_size_of_variable_prior = (DOFS + DOFS * DOFS) * f64
  let heap_size_of_variable_belief = (DOFS + DOFS * DOFS + DOFS + DOFS * DOFS) * f64
  let heap_size_of_variable = heap_size_of_variable_prior + heap_size_of_variable_belief

  let heap_size_of_message = (DOFS + DOFS + DOFS * DOFS) * f64

let heap_size_of_variable_inboxes(variables, connections) = {
  assert(variables >= 2);
  assert(connections >= 0);

  let first_last = 2 * (1 + connections)
  let inbetween = (variables - 2) * (2 + 1 + connections)
  (first_last + inbetween) * heap_size_of_message
}


  // TODO: missing size of inbox, for a variable this is dependant on the number of robots it is connected to

  // show table.cell.where(y: 0): strong
  set align(center)

  table(
    columns: 4,
    [], [$H$], [$H_("inbox")(C)$], [$H_("total")(C)$],
    [$V_("current")$], [#heap_size_of_variable], [$#heap_size_of_message times (1 + C)$], [$#{heap_size_of_variable + 1 * heap_size_of_message} + #heap_size_of_message C$],
    [$V_("horizon")$], [#heap_size_of_variable], [$#heap_size_of_message times (1 + C)$], [$#{heap_size_of_variable + 1 * heap_size_of_message} + #heap_size_of_message C$],
    [$V_("in-between")$], [#heap_size_of_variable], [$#heap_size_of_message times (3 + C)$], [$#{heap_size_of_variable + 3 * heap_size_of_message} + #heap_size_of_message C$],

    [$F_("dynamic")$], [#heap_size_of_dynamic], [#{1 * heap_size_of_message}], [#{heap_size_of_dynamic + 1 * heap_size_of_message}],
    [$F_("interrobot")$], [#heap_size_of_interrobot], [#{2 * heap_size_of_message}], [#{heap_size_of_interrobot + 2 * heap_size_of_message}],


  )

  // table(
  //   columns: 5,
  //   table.header([], [Variable], [$F_("obstacle")$], [$F_("dynamic")$], [$F_("interrobot")$]),
  //   [$H$], [#heap_size_of_variable], [#heap_size_of_obstacle], [*#heap_size_of_dynamic*], [#heap_size_of_interrobot],
  // )

}

// Lower estimate as some of the fields are heap allocated, and only the auxiliary data like the pointer to the data and the size of it is counted by the $B$ function.


// #kristoffer[do some napkin math for the size of the graph to justify why the memory of the chosen structure is not very important]

// https://github.com/indexmap-rs/indexmap/blob/3f0fffb85b99a2a37bbee363703f8509dd03e2d7/src/map/core.rs#L32

// #[derive(Clone)]
// pub struct GraphMap<N, E, Ty> {
//     nodes: IndexMap<N, Vec<(N, CompactDirection)>>,
//     edges: IndexMap<(N, N), E>,
//     ty: PhantomData<Ty>,
// }

#line(length: 100%, stroke: red + 1em)

// Iteration is very fast since it is on the dense key-values
// A raw hash table of key-value indices, and a vector of key-value pairs


@packed-compressed-sparse-row


// / #acr("CSR"): asd
// / Adjacency list: asd
// / Adjacency matrix: $O(|V^2|)$ memory
// / GraphMap: asd


Too summarize memory consumption should not be a limiting factor of simulating the system.

Not too many nodes in the graph, so we did not spend time benchmarking the various backing memory models.


// closer to real distribution

Since the memory required for each graph is not very high, we can afford to use more space for additional indices arrays

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
// The "naive"

// interior mutability

// This pattern is diffecult to implement and discouraged in Rust due to its ownership model.

// #kristoffer[
//   explain ownership model
// ]

// Many different representations are possible for the graph, in computer memory

// The underlying graph rep



using dedicated indices arrays for factors and variables to speed up iteration for queries only requiring access to the nodes or variables.