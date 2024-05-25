#import "../../../lib/mod.typ": *

=== Graph Representation <s.graph-representation>


There are several different methods for representing graph structures in computer memory. Each offering different advantages and disadvantages in regards to memory layout and query efficiency. As explained in @s.b.factor-graphs, the factorgraph structure is a bipartite graph with undirected edges.
Such a graph structure enforces little to no constraints on what kind of memory representation are possible to use. Allowing for many different choices@algorithms-fourth-edition. In the original work by Patwardhan _et al._@gbpplanner a cyclic reference/pointer structure is used. They represent the graph with a C++ class called `FactorGraph`, which each robot instance inherit from. Variable and factor nodes are stored in two separate vectors; `factors_` and `variables_`, as shown in the top of @code.gbpplanner-factorgraph.

// #show figure.where(kind: "code"): fig => {
//   fig
// }

// #figure(
//   kind: "code",
//   supplement: [Code Snippet],
//   caption: "FactorGraph",
// )



//
//
// https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/Factor.h#L27-L73
//
// https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/Variable.h#L22-L56
//
// https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/GBPCore.h#L57-L77

// #kristoffer[Add static link to github, and a line range]

#let gbpplanner = {
  let last-commit = (hash: "fd719ce", date: datetime(day: 30, month: 10, year: 2023))
  last-commit.insert("days-since", datetime.today() - last-commit.date)

  (
    // last-commit-hash: ,
    last-commit: last-commit,
    github: (
      name: "aalpatya/gbpplanner",
      permalink: (
        factorgraph: "https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/Factorgraph.h#L21-L51",
        factor: "https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/Factor.h#L27-L73",
        variable: "https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/Variable.h#L22-L56",
        gbpcore: "https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/gbp/GBPCore.h#L57-L77"
      )
    )
  )
}

// #let

// #sourcecode-reference([
#listing([
  ```cpp
  // defined in `inc/gbp/FactorGraph.h:21-51`
  class FactorGraph {
  public:
    std::vector<std::shared_ptr<Factor>> factors_;
    std::vector<std::shared_ptr<Variable>> variables_;
    // ...
  };

  // defined in `inc/gbp/Factor.h:27-73`
  class Factor {
  public:
    // Vector of pointers to the connected variables. Order of variables matters.
    std::vector<std::shared_ptr<Variable>> variables_{};
    // ...
  };

  // defined in `inc/gbp/GBPCore.h:57-77`
  class Key {
    public:
      int robot_id_, node_id_;
  };

  // defined in `inc/gbp/Variable.h:22-56`
  class Variable {
  public:
    // Map of factors connected to the variable, accessed by their key
    std::map<Key, std::shared_ptr<Factor>> factors_{};
    // ...
  }
  ```
],
  caption: [Header declarations for the classes that make up the factorgraph data structure in GBPplanner. The code snippets are taken from the latest commit #raw(gbpplanner.last-commit.hash) #footnote([#durationfmt(gbpplanner.last-commit.days-since) ago at the time of writing of this thesis.]) `// ...` indicates that there are more fields in the class, but not shown due to not being relevant for graph representation. Symbols prefixed with `std::` are provided by the C++ standard library.]
) <code.gbpplanner-factorgraph>

Edges between variable and factors are not stored as separate index values, but are instead implicitly stored by having each factor store a `std::shared_ptr<Variable>` to every variable it is connected to. Complementary every variable stores a `std::shared_ptr<Factor>` to every factor it is connected to. For both _internal_ edges and _external_ edges between separate factorgraphs this relationship is used. Advantages of this structural design is that it is easy to access the neighbours of a node, given only a handle to the node. For example to send messages to the neighbours of a node by directly invoking methods on the receiving node directly. Another advantage is that it abstracts away whether the pointer is to an external or an internal node. The access and reference patterns are equivalent. However this structural pattern is difficult to implement and discouraged in Rust due to its unique language feature for managing memory; the ownership model. This model is comprised of three rules, that together ensures memory safety and prevents memory issues like invalidated references, use after free and memory leaks@the-rust-book.

#[
  #set enum(numbering: box-enum.with(prefix: "Property "))
  + Each value has exactly one _owner_
  + There can only be one owner of a value at a time.
  + When the owner goes out of scope, the value is dropped #footnote([In Rust the term "dropped" is the preferred term to communicate that a value is destructed and its memory deallocated.]).
]

One limitation of this language model is that data structures with interior bidirectional references like the gbpplanners factor graph representation are difficult to express, since there is no conceptual single owner of the graph. If a connected factor and variable, both share a reference to the memory region of each other, then there is not a well defined concept of who owns who. Difficult does not mean impossible, and there are ways to express these kinds of data structures using a Rust specific design pattern called the  _Interior Mutability_ pattern@the-rust-book. With this pattern all borrow checks of the resource is moved from compile time to run time, forcing the programmer to be diligent about ensuring the invariants manually. Due to the added checks that would inevitably be introduced by this pattern it was not utilized. Instead the reimplementation of the factorgraph structure were laid out to work within the intended modelling constructs of the Rust language. In the reimplementation the graph data structure uniqly owns all the variable and factor nodes. And nodes in the graph store no interior references to nodes they are connected to. The _petgraph_ library is used for the actual graph datastructure. _petgraph_ is a versatile and performant graph data structure library providing various generic graph data structures with different performance characteristics@petgraph. To choose which graph representation to use the following requirements were considered. The requirements are ordered by priority in descending order:

#[
  #set enum(numbering: box-enum.with(prefix: "R-"))
  + Dynamic insertion and deletion of nodes. Robots connect to each others factorgraph when they both are within the communication radius of each other and both their communication mediums are active/reachable. Likewise they disconnect when they move out of each others communication or the other one is unreachable. This connection is upheld by the InterRobot factor, which gets added and removed frequently. <req.graph-representation-dynamic> // Indices into the graph needs to be stable across removal, in order to ensure the invariant too prevent issues with maintaining

  + Fast node iteration and neighbour search: In order to ensure collision free paths at tolerable speeds, the #acr("GBP") algorithm will have to run many times a second. The faster each factorgraph can be traversed the better. <req.graph-representation-fast-iteration>

  + The index of a node is valid for the lifetime of the node. Without this a lot of checks have to be added every time the factorgraph is indexed to get a reference to a node. <req.graph-representation-stable-indices>
]

_petgraph_ supports the following five types of graph representation; `Graph`, `StableGraph`, `GraphMap`, `MatrixGraph`, and `CSR`. The properties of these are compared in @table.graph-representations.

// #tablec(
//     columns: 2,
//     header: table.header(
//       [One], [Two],
//       [Three], [Four],
//     ),
//     [cell1], [cell2],
//     [cell3], [cell4],
// )

#{
  // show table.cell.where(x: 0): strong
  // show table.header: strong
  // show table.cell.where(y: 0): strong
  let yes = text(theme.green, emoji.checkmark)
  // let no = text(theme.red, emoji.crossmark)
  let no = text(theme.red, [x])
  // let no = emoji.crossmark
  set align(center)
  [
    #figure(
      tablec(
        // columns: (1fr, 3fr, 1fr, 1fr, 1fr, 1fr),
        columns: 7,
        align: (left, left, center, center, center, center, center),
        header: table.header([Name], [Description], [Space Complexity], [Backing Vertex Structure], [D], [SI], [HV]),
        [`Graph`], [Uses an _Adjacency List_ to store vertices.], [$O(|E| + |V|)$], [`Vec<N>`], [#yes], [#no], [#no],
        [`StableGraph`], [Similar to `Graph`, but it keeps indices stable across removals.], [$O(|E| + |V|)$], [`Vec<N>`],[#yes], [#yes], [#no],
        [`GraphMap`], [Uses an associative array, but instead of storing vertices sequentially it uses generated vertex identifiers as keys into a hash table, where the value is a list of the vertices' connected edges.], [$O(|E| + |V|)$],
        // [`IndexMap<N>`],
        // [`IndexMap<N, Vec<(N, CompactDirection)>>`],
        [`IndexMap<N, Vec<N>>`],
        [#yes], [#no], [#yes],
        [`MatrixGraph`], [Uses an _Adjacency Matrix_ to store vertices.], [$O(|V^2|)$], [`Vec<N>`], [#yes], [#no], [#no],
        [`CSR`], [Uses a sparse adjacency matrix to store vertices, in the #acr("CSR") format.], [$O(|E| + |V|)$], [`Vec<N>`], [#yes], [#no], [#no],
      ),
      caption: [Available Graph Representations in the `petgraph` library. $|E|$ is the number of edges and $|V|$ is the number of nodes. The "Backing Vertex Structure" lists which underlying data structure is used to store the associated data of each vertex. `Vec<N>` #footnote([Part of Rust's standard library]) is a growable array where items are placed continuous in memory@rust-std. `IndexMap<N>` is a special hash map structure that uses a hash table for key-value indices, and a growable array of key-value pairs. Allows for very fast iteration over nodes since their memory are densely stored in memory@indexmap. The "D" column labels if the data structure supports vertices/edges being removed after initialization. The "HI" columns list if the data structure requires that the vertex type must be hashable. In the context of this table; D = Dynamic, SI = Stable Indices, HV = Hashable Vertices.],
      // Graph - An adjacency list graph with arbitrary associated data.
      // StableGraph - Similar to Graph, but it keeps indices stable across removals.gn
      // GraphMap - An adjacency list graph backed by a hash table. The node identifiers are the keys into the table.
      // MatrixGraph - An adjacency matrix graph.
      // CSR - A sparse adjacency matrix graph with arbitrary associated data.
    )<table.graph-representations>
  ]
}

All five graph representations support dynamic insertion and removal of vertices and edges after initialization of the graph. So all of them satisfy the first requirement. Four out of the five graph representations uses a `Vec<N>` as its underlying container for vertex instances. `Vec<N>` are guaranteed to be continuous in memory ensuring fast iteration due to cache locality. At the same time the relative difference in iteration speed of using a the `GraphMap` structure should not really be noticeable, given that it uses an `IndexMap<N>`, which in turn uses a `Vec<(N, E)>` for its underlying storage of vertices. But it adds the additional constraint that vertices needs to be hashable, which is an impractical constraint given the lack of non-unique immutable fields of the underlying `Node` struct used to encapsulate both variable and factor nodes. So all data structures support the second requirement. In terms of space complexity all five candidates are close to equivalent, with four of them using $O(|V| + |E|)$ space, and the `MatrixGraph` using $O(|V|^2)$. Since each graph is not going to store hundreds of thousands of nodes, this quality was not weighted as an important factor to include in the consideration. Only the `StableGraph` data structure guarantees stable indices across repeated removal and insertion. Leaving it as the sole viable choice left that meets all three requirements. Expressed using the _petgraph_ library the chosen `Graph` type is defined as in @lst.graph-representation.


// ```rust
// type IndexSize = u16; // 2^16 - 1 = 65535
// pub type NodeIndex = petgraph::stable_graph::NodeIndex<IndexSize>;
// pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, IndexSize>;
// ```

#listing(
  [
    ```rust
    type IndexSize = u16; // 2^16 - 1 = 65535
    pub type NodeIndex = petgraph::stable_graph::NodeIndex<IndexSize>;
    pub type Graph = petgraph::stable_graph::StableGraph<Node, (), Undirected, IndexSize>;
    ```
  ],
  caption: [How the `Graph` type is defined in the reimplementation. It is defined as type alias over a `StableGraph` data structure parameterized by a `Node` enum. No data is associated with the edges in the graph so the _unit_ type `()` is used for data associated with edges. `IndexSize` is a type parameter for the upperbound of the number of nodes the graph can hold. In the experiments, see @s.results, no individual factorgraph ever held more more than $794$ nodes#footnote[Happens in Circle Experiment with $N_R = 50$, when all robots form a fully connected graph near the center of the circle.], so a bound of $2^16 - 1 = 65535$ was plenty sufficient, and is more compact in memory than the next possible alternative  $ u 32 = 2^32 - 1$.]
)<lst.graph-representation>

// Another key motivation for using a graph data structure that fully owns all its nodes is that it maps more faithfully to the conditions an implementation would have to meet for deployment in a real-world multi-robot scenario. Here the work needed to exchange messages across internal and external edges are significantly different. And will be have to handled differently. In comparison the use of bidirectional `std::shared_ptr` is no longer feasiable. The reason for this is straightforward. Pointers are addresses into virtual memory that are only meaningful/valid within the context of the computer process that created the pointer.  When the algorithm is split across multiple hosts, it runs on multiple processes and hence there would be more than one virtual memory. Furthermore the use of pointers as identifiers would limit its capability to work across heterogenous computer units as you would be limited to one of 32 bit or 64 bit architectures. 32 bit are common for in embedded devices.
// For the algorithm to work with the bidirectional structure an RPC abstraction would be needed. Where the node is instead an abstract interface with two implementors; an owned variant for the nodes that belong to the robots factorgraph, such as obstacle factors. And a proxy variant that used the Proxy structural pattern that would forward read and write calls to communication stack used between the robots.
// Although no real world experiments have been performed as part of this thesis, it was still considered important that the reimplementation was designed with an architecture that would be feasible in a real distributed system. This was done to better assess the practical feasibility of the algorithm outside of simulation.

Another key motivation for using a graph data structure that fully owns all its nodes is that it more accurately reflects the requirements for deployment in a real-world multi-robot scenario. In such a scenario, the work needed to exchange messages across internal and external edges differs significantly and must be handled differently. In comparison, using bidirectional `std::shared_ptr` is not feasible. This is because pointers are addresses in virtual memory, which are only meaningful within the context of the process that created them. When the algorithm runs across multiple hosts, it operates on multiple processes, each with its own virtual memory. Furthermore, using pointers as identifiers limits the algorithm's ability to work across heterogeneous computing units, as you would be restricted to either 32-bit or 64-bit architectures. // A problem for embedded devices where both 32-bit and 64-bit are common#k[citation]
For the algorithm to function with a bidirectional structure, a #acr("RPC") abstraction would be necessary. This approach would involve an abstract interface for the nodes, with two implementors: an owned variant for nodes belonging to the robot's factor graph, such as obstacle factors, and a proxy variant using the Proxy structural pattern to forward read and write calls to the communication stack used between the robots@gang-of-four-design-patterns. Although no real-world experiments were conducted as part of this thesis, it was considered valuable to design the reimplementation with an architecture feasible for a real distributed system. This was done to better assess the practical feasibility of the algorithm outside of simulation.

// - Even though this design will not have as good performance as using direct pointer access.

One idea expanded upon from the original work is the use of separate arrays for variables and nodes. In the reimplementation, each factor graph stores additional vectors of indices for variable nodes, factor nodes, and each distinct factor variant. This optimization trades some memory space for faster iterations with better CPU branch prediction. Queries needing a specific subview of the graph do not have to branch based on the node type each time the graph is iterated over. All visualization modules of the simulator are implemented as #acr("ECS") systems. Many of them query all the factor graphs each frame but only need a specific subset of nodes. For example, the "Obstacle Factors" module explained in @s.m.s4.visualisation only needs access to the obstacle factors of each graph. By having the factor graphs' public #acr("API") provide dedicated iterators for these subviews, the visualization modules can run as efficiently as possible. Similarly, the internal and external message passing also use dedicated arrays. For example, only inter-robot factors are iterated over during the factor iteration step for the external pass #todo[ref]. Mutable access to the index vectors is never exposed through the public #acr("API") of the graph. Combined with the borrowing system, this ensures that the indices always point to existing nodes, making it easy and safe to run efficient queries on specific subsets of the factor graphs.

Finally each factorgraph is stored as a component in the ECS world associated with each robot entity. This makes them easy to access from other systems in the simulation, and to add and remove them as robots spawn and despawn in the different scenarios.

// - this to ensure that ECS queries that run frequently on the graph and only need a specific subset of it runs as fast as they can.



// use additional memory to store additional indices arrays. Each factorgraph store a vector of indices for variable nodes, one for factor nodes, and then one for each distinct factor variant. This is done as an cheap optimisation  ... given the memory footprint is low, see above to speed up to speed up iteration for queries only requiring access to the variables or factors. #kristoffer[Refer to the steps in the theory section ] #kristoffer[Another example to refer to is the section about visualization systems.]

// In terms of space complexity all five candidates are close to equivalent, with four of them using $O(|V| + |E|)$ space, and the `MatrixGraph` using $O(|V|^2)$. Lack of sufficient/enough memory were not deemed and issue for the simulation. To support this claim let:
//
// $ B(T) = "stack allocation of T in bytes" $
//
// The Rust standard library function #raw(block: false, lang: "rust", "std::mem::size_of::<T>()") is used to calculate $B(T)$@rust-std. Then the size of a `VariableNode` and a `FactorNode` is:
//
//
// $ B("Variable") = 392 "bytes" $
// $ B("Factor") =  408 "bytes" $
//
// #let size_of_variable = 392
// #let size_of_factor = 408
//
// A `Node` is modelled as a tagged union of a `VariableNode` and `FactorNode` so the size of a node is, the size of the largest of the two variants, plus 8 bytes to store the tag@the-rust-book:
//
// $ B(v_i) = max(B("Variable"), B("Factor")) + 8 "bytes" $ <eq.factorgraph-memory-estimate>
//
// #let size_of_node = calc.max(size_of_variable, size_of_factor) + 8
//
// No data is associated with an edge so the size of an edge is:
//
// $ B(e_i) = 0 "bytes" $
//
// An empty `FactorGraph` takes up:
//
// $ B("FactorGraph") = 200 "bytes" $
//
// #kristoffer[explain functions and meaning of variable names]
//
// #let size_of_graph = 200
//
// $ N_("obstacle")(\#V) = \#V - 2 $
//
// #let n_obstacle(v) = v - 2
//
// $ N_("dynamic")(\#V) = \#V - 1 $
//
// #let n_dynamic(v) = v - 1
//
// $ N_("interrobot")(\#V, \#C) = \#V times \#C $
//
// #let n_interrobot(v, c) = v * c
//
// $ N_("factors")(\#V, \#C) = N_("obstacle")(\#V) + N_("dynamic")(\#V) + N_("interrobot")(\#V, \#C) $
//
// #let n_factors(v, c) = n_obstacle(v) + n_dynamic(v) + n_interrobot(v, c)
//
// #let robots = 20
// #let variables = 10
//
// With a simulation of $\#R$ robots and $\#V$ variables, with each robot having $\#C$ connections, then the size is:
//
// $ B("Simulation"(R, V, C))
//
// &= R times (B("FactorGraph") + (V + N_("factors")(V, C)) times B("Node"))
// $
//
// #let size_of_simulation(r, v, c) = r * (size_of_graph + (v + n_factors(v, c)) * size_of_node)
//
// With $R = 20, V = 10, C = 10$ the size is:
//
// #let size_of_example = size_of_simulation(20, 10, 10)
//
// $ B("Simulation"(20, 10, 10)) = #size_of_example "bytes" = #MiB(size_of_example) $
//
// #MiB(size_of_example) is not a lot of memory for a modern computer. This of course, only accounts for the stack allocated memory of each structure. For heap allocated structures like dynamically sized matrices this only accounts for the heap pointer to the data and the length of the allocated buffer, and not the size of the buffer. With 4 #acr("DOF") a conservative estimate can be made by generalizing the heap allocation size of each node to be the largest heap allocation of the possible node variants. Let
//
// $ H(T) = "heap allocation of T in bytes" $ <equ.heap-allocation-in-bytes>
// $ H_("inbox")(T, C) = "heap allocation of T's inbox with C connections in bytes" $
//
// #{
//   let f64 = 8
//   let DOFS = 4
//   let heap_size_of_factor_state = (4 + 2 * 2 + DOFS * 2 + 4 * 8 + 4) * f64
//   let heap_size_of_dynamic = 4 * 8 * f64 + heap_size_of_factor_state
//   let heap_size_of_obstacle = 0 * f64 + heap_size_of_factor_state
//   let heap_size_of_interrobot = 0 * f64 + heap_size_of_factor_state
//   let heap_size_of_variable_prior = (DOFS + DOFS * DOFS) * f64
//   let heap_size_of_variable_belief = (DOFS + DOFS * DOFS + DOFS + DOFS * DOFS) * f64
//   let heap_size_of_variable = heap_size_of_variable_prior + heap_size_of_variable_belief
//
//   let heap_size_of_message = (DOFS + DOFS + DOFS * DOFS) * f64
//
// let heap_size_of_variable_inboxes(variables, connections) = {
//   assert(variables >= 2);
//   assert(connections >= 0);
//
//   let first_last = 2 * (1 + connections)
//   let inbetween = (variables - 2) * (2 + 1 + connections)
//   (first_last + inbetween) * heap_size_of_message
// }
//
//
//   // TODO: missing size of inbox, for a variable this is dependant on the number of robots it is connected to
//
//   // show table.cell.where(y: 0): strong
//   set align(center)
//
//   // tablec(
//   //   columns: (1fr, 3fr, 1fr),
//   //   align: (center, left, center),
//   //   header: table.header([*Parameter*], [*Description*], [*Unit* / *Domain*]),
// // #let tablec(title: none, columns: none, header: none, alignment: auto, stroke: none, ..content) = {
//   tablec(
//     columns: 4,
//     header: table.header([], [$H$], [$H_("inbox")(C)$], [$H_("total")(C)$]),
//     [$V_("current")$], [#heap_size_of_variable], [$#heap_size_of_message  (1 + C)$], [$#{heap_size_of_variable + 1 * heap_size_of_message} + #heap_size_of_message C$],
//     [$V_("horizon")$], [#heap_size_of_variable], [$#heap_size_of_message  (1 + C)$], [$#{heap_size_of_variable + 1 * heap_size_of_message} + #heap_size_of_message C$],
//     [$V_("in-between")$], [#heap_size_of_variable], [$#heap_size_of_message  (3 + C)$], [$#{heap_size_of_variable + 3 * heap_size_of_message} + #heap_size_of_message C$],
//
//     [$F_("dynamic")$], [#heap_size_of_dynamic], [#{1 * heap_size_of_message}], [#{heap_size_of_dynamic + 1 * heap_size_of_message}],
//     [$F_("interrobot")$], [#heap_size_of_interrobot], [#{2 * heap_size_of_message}], [#{heap_size_of_interrobot + 2 * heap_size_of_message}],
//
//
//   )
//
//   // table(
//   //   columns: 5,
//   //   table.header([], [Variable], [$F_("obstacle")$], [$F_("dynamic")$], [$F_("interrobot")$]),
//   //   [$H$], [#heap_size_of_variable], [#heap_size_of_obstacle], [*#heap_size_of_dynamic*], [#heap_size_of_interrobot],
//   // )
//
// }

// Lower estimate as some of the fields are heap allocated, and only the auxiliary data like the pointer to the data and the size of it is counted by the $B$ function.


// #kristoffer[do some napkin math for the size of the graph to justify why the memory of the chosen structure is not very important]

// https://github.com/indexmap-rs/indexmap/blob/3f0fffb85b99a2a37bbee363703f8509dd03e2d7/src/map/core.rs#L32

// #[derive(Clone)]
// pub struct GraphMap<N, E, Ty> {
//     nodes: IndexMap<N, Vec<(N, CompactDirection)>>,
//     edges: IndexMap<(N, N), E>,
//     ty: PhantomData<Ty>,
// }


// Iteration is very fast since it is on the dense key-values
// A raw hash table of key-value indices, and a vector of key-value pairs


// @packed-compressed-sparse-row


// / #acr("CSR"): asd
// / Adjacency list: asd
// / Adjacency matrix: $O(|V^2|)$ memory
// / GraphMap: asd


// #kristoffer[Another added benefit of using a singular owning factorgraph structure is that is both feasible and more straightforward to extend the implementation to work with separate hosts, running with their own factorgraph. See discussion for more in depth discussion about the what would have to change to realize a real life implementation.]

// - Too summarize memory consumption should not be a limiting factor of simulating the system.

// - Not too many nodes in the graph, so we did not spend time benchmarking the various backing memory models.

// - Since the memory required for each graph is not very high, we can afford to use more space for additional indices arrays

// - In addition to storing the graph itself each factorgraph use additional memory to store arrays of node indices of each node kind, to speed iteration

// - should still be feasible for embedded computers with less memory
