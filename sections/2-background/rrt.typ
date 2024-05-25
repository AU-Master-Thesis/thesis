#import "../../lib/mod.typ": *
== Rapidly Exploring Random Trees <s.b.rrt>

#acr("RRT") is a sampling-based path planning algorithm, introduced by Steven M. LaValle in 1998@original-rrt. The algorithm incrementally builds a tree of nodes, each node a specific step length, $s$, from the last. The tree is built by randomly sampling a point in the configuration space, and then extending the tree towards that point with $s$. See the entire algorithm in @alg-rrt.@original-rrt@sampling-based-survey @ex.rrt goes through an contextual example of the algorithm.

// What about `inline` code? Also shown in @lst.python-rrt.
// #listing(caption: [Pseudo-code for the regular RRT algorithm.])[
// ```python
// def rrt(start, goal, s, N, g_tolerance):
//     V = {start}
//     E = set()
//     for i in range(N):
//         x_random = SampleRandomPoint()
//         x_nearest = NearestNeighbor(G=(V, E), x_random)
//         x_new = Steer(s, x_nearest, x_random)
//         if CollisionFree(x_nearest, x_new):
//             V = V.union({x_new})
//             E = E.union({(x_nearest, x_new)})
//         else:
//             continue
//         if WithinGoalTolerance(g_tolerance, x_new, goal) and CollisionFree(x_new, goal):
//             V = V.union({goal})
//             E = E.union({(x_new, goal)})
//             break
//     return G = (V, E)
// ```
// ]<lst.python-rrt>

#let func(content) = text(theme.mauve, content)
#algorithm(
  [
    #show regex("(SampleRandomPoint|NearestNeighbor|Steer|CollisionFree|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
    #let ind() = h(2em)
    *Input:* $x_"start", x_"goal", s, N, g_"tolerance"$ \ \

    $V #la {x_"start"}$ \
    $E #la emptyset$ \ \

    *for* $i = 1, dots, N$ *do* \
    #ind()$x_"random" #la "SampleRandomPoint"()$ \
    #ind()$x_"nearest" #la "NearestNeighbor"(G = (V, E), x_"random")$ \
    #ind()$x_"new" #la "Steer"(s, x_"nearest", x_"random")$ \ \

    #ind()*if* $"CollisionFree"(x_"nearest", x_"new")$ *then* \
    #ind()#ind()$V #la V union x_"new"$ \
    #ind()#ind()$E #la E union {(x_"nearest", x_"new")}$ \
    #ind()*else* \
    #ind()#ind()*continue* \
    #ind()*end* \ \

    #ind()*if* $"WithinGoalTolerance"(g_"tolerance", x_"new", x_"goal")$ \
    #ind()#h(1em)$and "CollisionFree"(x_"new", x_"goal")$ *then* \
    #ind()#ind()$V #la V union x_"goal"$ \
    #ind()#ind()$E #la E union {(x_"new", x_"goal")}$ \
    #ind()#ind()*break* \
    #ind()*end* \
    *end* \ \

    *Output:* $G = (V, E)$
  ],
  caption: [The RRT Algorithm]
)<alg-rrt>

// In @alg-rrt the following functions are used:
#[
  // #show regex("(SampleRandomPoint|NearestNeighbor|Steer|CollisionFree|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
  #set list(marker: text(theme.mauve, sym.diamond.filled))
  #set par(first-line-indent: 0em)

  === RRT Functions
  This section provides a mathematical description of the functions used in the RRT algorithm; functions `SampleRandomPoint`, `NearestNeighbor`, `Steer`, `CollisionFree`, and `WithinGoalTolerance`. As in @alg-rrt, the #acr("RRT") tree consists of vertices, $V$, and edges, $E$; together composing a graph, $G = (V, E)$. These denotations are used in the following descriptions.@erc-rrt-star

  // \ #text(size: 1.25em, weight: "bold", [`SampleRandomPoint()`])  \
  // ==== `SampleRandomPoint() -> x`
  ==== #fsig[SampleRandomPoint() -> x]
  This functions takes no arguments, and returns a random point, $x$, in the configuration space. Most commonly this is done by drawing from a uniform distribution. Say that $omega$ is an element in the set of all possible states in the configuration space $Omega$, where $forall omega in Omega$ equation @eq.func-sample-random-point holds.@erc-rrt-star

  #algeq[
    $
      "SampleRandomPoint" : omega arrow.r.bar {"SampleRandomPoint"_i (omega)}_(i in NN_0) subset cal(X)
    $<eq.func-sample-random-point>
  ]


  That is; the set of all randomly sampled points, $cal(X)_"rand"$, which is the result of the above mapping, is a subset of the configuration space, $cal(X)$.

  // #jens[finish this one, it doesn't make too much sense]

  // \ #text(size: 1.25em, weight: "bold", [`NearestNeighbor(G, x)`])  \
  // ==== `NearestNeighbor(G, x) -> v`
  ==== #fsig[NearestNeighbor(G, x) -> v]
  Finds the nearest node $v in V subset cal(X)$ in the tree to a given point. Takes in the graph, $G = (V, E)$, and a point, $x in cal(X)$, see @eq.func-nearest-neighbor. This notion could be further specified with a distance metric, such as the Euclidean distance, as seen in @eq.func-nearest-neighbor-euclidean, which return the node $v in V$ that minimizes the distance, $norm(x - v)$, between the new point $x$ and an existing node $v$.@erc-rrt-star

  #algeq[
    $
      "NearestNeighbor" : (G, x) arrow.r.bar v in V
    $<eq.func-nearest-neighbor>

    $
      "NearestNeighbor"(G = (V, E), x) = "argmin"_(v in V) norm(x - v)
    $<eq.func-nearest-neighbor-euclidean>
  ]

  // \ #text(size: 1.25em, weight: "bold", [`Steer(x, y)`])  \
  // ==== `Steer(x, y, s) -> v`
  ==== #fsig[Steer(x, y, s) -> v]
  Creates a new node at a specific distance from the nearest node towards a given point. Takes in two points $x, y in cal(X)$, and a step length $s in RR^+$,. The new node $v$ is created by moving $s$ distance from $x$ towards $y$. This way equation @eq.func-steer returns a point $v in cal(X)$ such that $v$ is closer to $y$ than $x$, which will either be $s$ closer, or if the randomly sampled point $y$ is within $s$ distance from $x$ to begin with, $v$ will be at $y$. As such the inequality $norm(z - y) >= s$ holds.@erc-rrt-star

  #algeq[
    $
      "Steer" : (x, y, s) arrow.r.bar v in cal(X)
    $<eq.func-steer>
  ]

  // \ #text(size: 1.25em, weight: "bold", [`CollisionFree(x, y)`])  \
  // ==== `CollisionFree(x, y) -> p`
  ==== #fsig[CollisionFree(x, y) -> p]
  Checks if the path between two nodes is collision-free. Takes in two points $x, y in cal(X)$, and returns a boolean, $p in {top, bot}$. The returned values, $p$, says something about whether the addition of node $y in cal(X)$ into the #acr("RRT") tree is valid, given a proposed edge to the node $x in V$. Typically the validity notion depends on whether the path from $x$ to $y$ is collision-free, hence the function's name, but could include any other arbitrary constraints.@erc-rrt-star

  // \ #text(size: 1.25em, weight: "bold", [`WithinGoalTolerance(tolerance, x, goal)`])  \
  // ==== `WithinGoalTolerance(t, x, g) -> p`
  ==== #fsig[WithinGoalTolerance(t, x, g) -> p]
  Checks if a node is within the goal tolerance distance from the goal. As such the the functions takes in the distance tolerance $t$, a node $x in V$, and the goal state $g in cal(X)$. The function returns a boolean, $p in {top, bot}$, that tells us whether $x$ is within a euclidean distance $t$ from the goal state $g$. See @eq.func-goal-tolerance for the mathematical representation.@erc-rrt-star

  #algeq[
    $
      "WithinGoalTolerance" : (t, v, g) arrow.r.bar p in {top, bot}
    $<eq.func-goal-tolerance>
  ]

]
// #jens[
//   Consider making this a table?
// ]

#example(caption: [Contextual RRT Application])[
  #set par(first-line-indent: 0em)
  *Scenario:* Let's look at an example, where the possible state space is _two-dimensional euclidean space_. A Robot wants to go from 2D position $x_A$ to $x_B$ \ \

  *Input:* In @alg-rrt, the input is outlined to be a starting position, $x_"start"$, a goal position $x_"goal"$, a step length $s$, a maximum number of iterations, $N$, and lastly, a goal tolerance, $g_"tolerance"$. \ \

  *Output:* At the end of algorithm execution, the resulting graph is outputted as the combination of; $V$, the set of vertices, and $E$, the set of edges. \ \

  *Execution:*
  + $V$ is initialised to contain the initial position of the robot $x_"start" = x_A$, thus the set ${x_A}$. $E$ is initialised to be empty.
  + Enter a for loop, that will maximally run $N$ times, but will break early if the goal is reached.

    *Each iteration:*
    + A random point, $x_"random"$, is sampled from the configuration space, by calling the sampling function $"SampleRandomPoint"()$.
    + The nearest existing node in the tree, $x_"nearest"$, is found by $"NearestNeighbor"(G = (V, E), x_"random")$.
    + Thereafter, a new node, $x_"new"$, is created by making a new node $s$ distance from $x_"nearest"$ towards $x_"random"$ in the call to $"Steer"(s, x_"nearest", x_"random")$.

    *Checks:*
    + Only if the path from $x_"nearest"$ to $x_"new"$ is collision-free, the new node is added to the tree. Otherwise, continue to the next iteration.
    + If the node is added to the tree, and it is within $g_"tolerance"$ distance from $x_"goal"$, and the path from $x_"new"$ to $x_"goal"$ is collision-free, the goal is added to the tree, and the loop is broken.
]<ex.rrt>

== Optimal Rapidly Exploring Random Trees <s.b.rrt-star>

// FROM @erc-rrt-star
// In the year 2011, Sertac Karaman and Emilio Frazzoli in their paper Sampling-based Algorithms for Optimal Motion Planning, introduced three new path planning algorithms that improved upon the existing algorithms. These were, namely, optimal rapidly exploring random trees (RRT*), optimal probabilistic road mapping (PRM*), and rapidly exploring random graphs (RRG).

// The most popular algorithm among these is the RRT* algorithm, that is heavily based on the RRT algorithm, and has some improvisions, and provides a more optimal solution.

// Let’s now look at the RRT* algorithm that was originally proposed in the paper along with the pseudo code. All the mathematical notations and functions in the paper are clearly explained here.

// The following image shows the RRT* algorithm applied on a 2D graph.

// Intuition HEADING

// The node sampling and selection process is exactly the same as RRT, wherein a point is randomly generated and a node is created at that point or at a specified maximum distance from the existing node, whichever is closer.

// However, the difference is where the connection is made. We assign every node a cost function that denotes the length of the shortest path from the start node. We then search for nodes inside a circle of given radius r centred at the newly sampled point.

// We then rearrange the connections such that they minimize the cost function and optimize the path. This can rearrange the graph in such a way that we get the shortest path.

// Courtesy: Joon’s lectures

// In the image above, after rearranging the connections, the path to the green points, i.e.,
// is shorter through the red connections than through the earlier connections.

#acr("RRT*") is an extension of the #acr("RRT") algorithm, which was introduced in 2011 by Sertac Karaman and Emilio Frazzoli in their paper _Sampling-based Algorithms for Optimal Motion Planning_@sampling-based-survey. With only a couple of modifications to #acr("RRT"), the algorithm is able to reach asymptotic optimality, where the original algorithm makes no such promises. The modifications are explained below:

#set enum(numbering: box-enum.with(prefix: "M-", color: theme.mauve))
+ _*Cost Function:*_ The first modification is the introduction of a _cost function_, $c(v)$, for each node, $v in V$. The cost function outputs the length of the shortest path from the start node to the node $v$. This modification encodes an optimisable metric for each branch, which enables the next modification, #boxed(color: theme.mauve, [*M-2*]), to take place.
+ _*Rewiring:*_ The second modification is the introduction of a _neighbourhood radius_, $r in RR^+$, around each newly created node, which is used to search for nodes that can be reached with a lower cost.

  As such every time a new node is created, there is a possibility that other nodes within that radius, will have a lower cost if they were to be connected to the new node. Thus, comparing the nodes' old cost, and the cost they would have in case we connect them to the newly created node, determines whether to rewire or not.

#algorithm(
  caption: [The RRT\* Algorithm],
)[
  #set text(size: 0.85em)
  #show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
  #let ind() = h(2em)
  *Input:* $x_"start", x_"goal", s, N, g_"tolerance"$ \ \

  $V = {x_"start"}$ \
  $E = emptyset$ \ \

  *for* $i = 1, dots, n$ *do* \
  #ind()$x_"rand" #la "Sample"()$ \
  #ind()$x_"nearest" #la "Nearest"(V, E, x_"rand")$ \
  #ind()$x_"new" #la "Steer"(x_"nearest", x_"rand")$ \ \

  #ind()*if* $"ObstacleFree"(x_"nearest", x_"new")$ *then* \
  #ind()#ind()$V_"near" #la "Neighbourhood"(V, E, x_"new", r)$ \
  #ind()#ind()$V #la V union {x_"new"}$ \
  #ind()#ind()$c_"nearest" #la "cost"(x_"nearest") + c("Line"(x_"nearest", x_"new"))$ \ \

  #ind()#ind()$x_"min" #la "MinCostConnection"(V_"near", x_"new", x_"nearest", c_"nearest")$ \

  #ind()#ind()$E #la E union {[x_"min", x_"new"]}$ \ \

  #ind()#ind()$"Rewire"(V_"near", x_"new")$ \
  #ind()*end* \

  // Check for connection to goal like RRT
  #ind()*if* $"WithinGoalTolerance"(g_"tolerance", x_"new", x_"goal")$ \
  #ind()#h(1em)$and "CollisionFree"(x_"new", x_"goal")$ *then* \
  #ind()#ind()$V #la V union {x_"goal"}$ \
  #ind()#ind()$E #la E union {[x_"new", x_"goal"]}$ \
  #ind()#ind()*break* \
  #ind()*end* \
  *end* \ \

  *Output:* $G = (V, E)$
]<alg.rrt-star>

With the modifications made, the #acr("RRT*") algorithm is shown in @alg.rrt-star@erc-rrt-star. Two important blocks of the algorithm has been sectioned out in sub-algorithms @alg.rrt-star.min-cost-connection and #numref(<alg.rrt-star.rewire>), which are described along side the other new functions of #acr("RRT*") under @s.b.rrt-star.functions. The main parts of the algorithm are visualised in @f.rrt-rewire as three steps:
#set enum(numbering: box-enum.with(prefix: "Step ", color: theme.mauve))
+ A new point has been sampled, deemed collision-free, and thus node $v_"new"$ can be added to the tree. But first, we need to find which existing node to connect to. Here, $v_"nearest"$ is chosen by the `MinCostConnection` algorithm, as it is the node that minimizes the total cost from the root to $v_"new"$, within the step-length radius $s$.
+ In preparation, rewiring candidates will be found, by looking at all nodes in the tree, that are within a certain requiring radius, $r$, from $v_"new"$. This is done by the `Neighbourhood` function, which returns the set $V_"near" = {n_1, n_2, dots, n_n}$.
#[
  #show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
  + This step is where the rewiring takes place. By looking at the nodes in $V_"near"$, we can compute each node's cost, $c_"new"$ with equation @eq.rrt-star-cost

    $
      "Cost"(v_"new") + c("Line"(n_i, v_"new"))
    $<eq.rrt-star-cost>

    as if $v_"new"$ were its parent. Denote the costs $C_"near" = {c_1, c_2, dots, c_n}$. Now for each node $n_i in V_"near"$, check if $c_i < c_"new"$, and if so, rewire the connection to make $v_"new"$ the parent of $n_i$.
]

#figure(
  {
    v(1em)
    image("../../figures/out/rrt-rewire.svg", width: 100%)
  },
  caption: [The #acr("RRT*") algorithm drawn out in 3 steps. Firstly, a new node is sampled and added to the tree, where the cost is lowest, looking in a radius of $s$#swatch(theme.mauve.lighten(40%)). Then nodes within a neighbourhood $r$#swatch(theme.lavender.lighten(25%)), are then rewired if their cost would be lower by doing so.],
)<f.rrt-rewire>

=== RRT\* Functions <s.b.rrt-star.functions>

Here the functions used in the #acr("RRT*") algorithm are described in @alg.rrt-star. Functions from base-#acr("RRT") are not repeated here, as no change is made to them. The new functions are; `MinCostConnection`, `Rewire`, `Cost`, `Neighbourhood`, `Parent`, and `Line`.

// ==== `MinCostConnection(V_near, x_new, x_init, c_init) -> v` <s.b.rrt-star.min-cost-connection>
==== #fsig[MinCostConnection(V_near, v_new, v_init, c_init) -> v] <s.b.rrt-star.min-cost-connection>
This function is a main part of the #acr("RRT*") modification, as it attached the new node $v_"new"$, not to the node nearest to the randomly sampled point in $cal(X)$, but to the node that minimizes the cost from the root to $v_"new"$. This happens by looking at all nodes in a neighbourhood $V_"near"$ of radius $r$ from $v_"new"$, and then finding the node that minimizes the cost. To begin with the initial node $v_"init"$ and its cost $c_"init"$ is passed to the function as the initial comparison point. The initial comparison point is typically the nearest node in the tree, that would have been the parent for $v_"new"$ in #acr("RRT"). The function's operation is described in @alg.rrt-star.min-cost-connection.
#algorithm(
  caption: [Finding the Minimum Cost Connection],
  [
    #set text(size: 0.85em)
    #show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
    #let ind() = h(2em)
    *Input:* $V_"near", x_"new", x_"nearest", c_"nearest"$ \ \

    $x_"min" #la x_"nearest"$ \
    $c_"min" #la c_"nearest"$ \ \

    *for* $x_"near" in X_"near"$ *do* \
    #ind()$c_"near" #la "Cost"(x_"near") + c("Line"(x_"near", x_"new"))$ \
    #ind()*if* $"CollisionFree"(x_"near", x_"new") and c_"near" < c_"min"$ *then* \
    #ind()#ind()$x_"min" #la x_"near"$ \
    #ind()#ind()$c_"min" #la "Cost"(x_"near") + c("Line"(x_"near", x_"new"))$ \
    #ind()*end* \
    *end* \ \

    *Output:* $x_"min"$
  ]
)<alg.rrt-star.min-cost-connection>

// ==== `Rewire(V_near, x_new)` <s.b.rrt-star.rewire>
==== #fsig[Rewire(V_near, v_new)] <s.b.rrt-star.rewire>
The rewiring function is the second part of the #acr("RRT*") optimisation steps, which changes previously established connections in the tree. The function uses the neighbourhood $V_"near"$ of nodes in radius $r$ around $v_"new"$. For each $n_i in V_"near"$, if the cost of $n_i$ with $v_"new"$ as parent is lower than the previously established cost for $n_i$, the tree is rewired. The function is described in @alg.rrt-star.rewire.
#algorithm(
  caption: [Rewiring],
  [
    #show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
    #set text(size: 0.85em)
    #let ind() = h(2em)
    *Input:* $V_"near", x_"new"$ \ \

    *for* $x_"near" in V_"near"$ *do* \
    #ind()$c_"near" #la "Cost"(x_"new") + c("Line"(x_"new", x_"near"))$ \
    #ind()*if* $"CollisionFree"(x_"new", x_"near") and c_"near" < "Cost"(x_"near")$ *then* \
    #ind()#ind()$x_"parent" #la "Parent"(x_"near")$ \
    #ind()#ind()$E #la E \\ {[x_"parent", x_"near"]}$ \
    #ind()#ind()$E #la E union {[x_"new", x_"near"]}$ \
    #ind()*end* \
    *end* \ \

    *Output:* None
  ]
)<alg.rrt-star.rewire>

// ==== `Cost(v) -> c` <s.b.rrt-star.cost>
==== #fsig[Cost(v) -> c] <s.b.rrt-star.cost>
// By whatever means, returns the cost of a node, $v in V$. That is; the length of the line segments if one were to walk from $v$ and all the way back to the root node.

This function is used in @alg.rrt-star, #numref(<alg.rrt-star.min-cost-connection>), and #numref(<alg.rrt-star.rewire>) to access the cost $c$ of a node $v in V$. Typically the cost is a distance, and as such; the sum of the Euclidean distances between all nodes if one were to walk all the way back to the root node from $v$. Thus a mapping from a node $v in V$ to a cost $c in RR^+$ as shown in @eq.func-cost.

#algeq[
  $
    "Cost" : v arrow.r.bar c in RR^+
  $<eq.func-cost>
]

// ==== `Neighbourhood(V, E, x, r) -> V_near` <s.b.rrt-star.neighbourhood>
==== #fsig[Neighbourhood(V, E, x, r) -> V_near] <s.b.rrt-star.neighbourhood>
A more complex function, which returns a the set of all nodes in $V$ that are within a radius $r$ from a potential new node $x in cal(X)$. If the configuration space is $cal(X) = RR^2$, then the neighbourhood $V_"near"$ is a subset of $V$ such that $forall v in V_"near"$, $norm(v - x) <= r$. This mapping is described in @eq.func-neighbourhood.

#algeq[
  $
    "Neighbourhood" : (V, E, x, r) arrow.r.bar V_"near" subset V
  $<eq.func-neighbourhood>
]

// ==== `Parent(v) -> p` <s.b.rrt-star.parent>
==== #fsig[Parent(v) -> p] <s.b.rrt-star.parent>
Semantically denotes access to the parent node $p in V$ of a node $v in V$, see @eq.func-parent.

#algeq[
  $
    "Parent" : v arrow.r.bar p in V
  $<eq.func-parent>
]

// ==== `Line(x, y) -> l` <s.b.rrt-star.line>
==== #fsig[Line(x, y) -> l] <s.b.rrt-star.line>
#{
  show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)

  [
    Denotes the idea of the finding the line segment that is between two nodes $x, y in cal(X)$. This line segment expresses the relationship between $x$ and $y$ in the configuration space $cal(X)$. It can be used, as seen in algorithms #numref(<alg.rrt-star>), #numref(<alg.rrt-star.min-cost-connection>) and #numref(<alg.rrt-star.rewire>), to calculate the cost that this line segment provides. This is done by the function $c("Line"(x, y))$, which, in case of a Euclidean configuration space, and thus cost would express a mapping from two points $x, y in cal(X)$ to a distance $l in RR^+$, see @eq.func-line.

    $
      "Line" : (x, y) arrow.r.bar l in RR^+ \
      c("Line"(x, y)) = norm(x - y)
    $<eq.func-line>
  ]
}
