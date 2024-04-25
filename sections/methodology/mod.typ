#import "../../lib.typ": *
= Methodology <methodology>

#include "language.typ"
#include "architecture.typ"
#include "global-planning.typ"


#kristoffer[talk about design of different config format design, especially `formation` and `environment`

show examples of them, and how they allow for flexibly and declaratively define new simulation scenarios

  ```yaml
  formations:
  - repeat-every:
      secs: 8
      nanos: 0
    delay:
      secs: 2
      nanos: 0
    robots: 1
    initial-position:
      shape: !line-segment
      - x: 0.45
        y: 0.0
      - x: 0.55
        y: 0.0
      placement-strategy: !random
        attempts: 1000
    waypoints:
    - shape: !line-segment
      - x: 0.45
        y: 1.25
      - x: 0.55
        y: 1.25
      projection-strategy: identity
  ```
]

#jens[
  === Asynchronous Message Passing <s.b.asynchronous-message-passing>
]




// #import "@preview/codelst:2.0.1": sourcecode
//
// #sourcecode[```typ
// #show "ArtosFlow": name => box[
//   #box(image(
//     "logo.svg",
//     height: 0.7em,
//   ))
//   #name
// ]
//
// This report is embedded in the
// ArtosFlow project. ArtosFlow is a
// project of the Artos Institute.
// ```]


#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  talk about how our graph representation is different from theirs.
  Ours is more faithful to how robots would represent the other robots in the environment
  compared to theirs, since they use bidirectional `std::shared_ptr`, which is not useable
  in a scenario where the algorithm run on different computer hosts, or just computer processes on the same host.
]


=== Graph Representation <s.graph-representation>

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
], caption: [`FactorGraph` class declaration in `inc/gbp/FactorGraph.h`]) <code.gbpplanner-factorgraph>

Edges between variable and factors are not stored as separate index values, but are instead implicitly stored by having each factor storing a `std::shared_ptr<Variable>` to every variable it is connected to. Complementary every variable stores a `std::shared_ptr<Factor>` to every factor it is connected to. This kind of structure is advantagous in that it easy access the neighbours of node, given only a handle to the node. For example to send a message to a nodes neighbours.


#acr("CSR")

Adjacency matrix
Adjacency list

consider insertion/deletion of nodes and edges as influencers of the graph data structure.

The "naive"

interior mutability

This pattern is diffecult to implement and discouraged in Rust due to its ownership model.

#kristoffer[
  explain ownership model
]

// Many different representations are possible for the graph, in computer memory

The underlying graph rep




/ CSR: asd
/ Adjacency list: asd
/ Adjacency matrix: asd



using dedicated indices arrays for factors and variables to speed up iteration for queries only requiering access to the nodes or variables.

#sourcecode[
```rust
pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, u32>;
```
]

The number of variables in a the graph is

Since the number of fac

#kristoffer[Why `StableGraph`?]


#kristoffer[Not experiment with different graph representations, e.g. matrix, csr, map based etc.]


we use @petgraph


#context {

}
