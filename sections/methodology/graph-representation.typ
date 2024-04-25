#import "../../lib.typ": *

=== Graph Representation <s.graph-representation>

#kristoffer[
  talk about how our graph representation is different from theirs.
  Ours is more faithful to how robots would represent the other robots in the environment
  compared to theirs, since they use bidirectional `std::shared_ptr`, which is not useable
  in a scenario where the algorithm run on different computer hosts, or just computer processes on the same host.
]


There are several different ways of representing graph structures in computer memory. Each with its own advantages and disadvantages. As explained in @s.b.factor-graphs, the factorgraph structure is a bipartite graph with undirected edges.
Such a graph structure enforces little to no constraints on what kind of memory representation are possible to use #note.kristoffer[find citation for this statement]. In the original work by Patwardhan _et al._@gbpplanner an atypical structure is used #note.k[find citation to defend this claim]. They represent the graph with a C++ class called `FactorGraph`, which each robot instance inherit from. Variable and factor nodes are stored in two separate vectors; `factors_` and `variables_`, as shown in the top of @code.gbpplanner-factorgraph.

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
+ When the owner goes out of scope, the value is deallocated.

One limitation of this system is that data structures with interior bidirectional references like the gbpplanners factor graph representation are difficult to express, since there is no conceptual single owner of the graph. If a factor and a variable that are connected, both share a reference to the memory region of each other, then there is not a well defined concept of who owns who. Difficult does not mean impossible, and there are ways to express these kinds of data structures using a Rust specific design pattern called the  _Interior Mutability_ pattern@the-rust-book. We decided not to use this pattern and instead work within the intended modelling constructs of the Rust language. In the reimplementation the graph data structure uniqly owns all the variable and factor nodes. And nodes in the in the graph store no interior references to nodes they are connected to. The _petgraph_ library is used for the actual graph datastructure. petgraph is a versatile and performant graph data structure library providing various generic graph data structures with different performance characteristics@petgraph.

Requirements:

+ Dynamic insertion and deletion of nodes.
+ Fast neighbour search.
+

#kristoffer[do some napkin math for the size of the graph to justify why the memory of the chosen structure is not very important]


Not too many nodes in the graph, so we did not spend time benchmarking the various backing memory models.


closer to real distribution

// In Rust every piece of data i.e. every variable and allocated block of memory has a single owner

In addition to storing the graph itself each factorgraph use additional memory to store arrays of node indices of each node kind, to speed iteration

// A disadvantage of this structure
// promote hiearchial data structures

/ #acr("CSR"): asd
/ Adjacency list: asd
/ Adjacency matrix: $O(|V^2|)$ memory
/ GraphMap: asd

#line(length: 100%, stroke: red)

Adjacency matrix
Adjacency list

one requirement the chosen graph model would need to satisfy, is the ability to update the graph structure over time,

supported fast repeated iteration

trade some speed for edge lookup time, for having indices not being invalidated

consider insertion/deletion of nodes and edges as influencers of the graph data structure.
j
#sourcecode[
  ```rust
pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, u32>;
```
]

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
