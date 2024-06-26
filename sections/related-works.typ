#import "../lib/mod.typ": *

#let etal = [_et al._]

// #jonas[do please read the stuff in here]

= Related Works <s.b.related-works>

The field of multi-agent path planning has a rich literature spanning several decades, with numerous proposed methods. One of the key taxonomies that can be used to classify existing methods is in respect to how they distribute the computation of the jointly planned paths among the robotic agents. In the majority of cases, methods attempt to solve the problem by one of three ways: _Centralized_, _Decentralized_ or _Distributed_@multi-robot-path-planning-review. A depiction of how to conceptualize each is shown in @f.multi-robot-path-planning-classification.


// differing significantly based on their underlying taxonomies.


// #jonas[Not close to done. No need to spend time in this section.]

// things to cover

// at @multi-robot-path-planning-review

// multi robot systems
// path planning element is a crucial part of such systems
// various axis, where these approaches differ
// large dichotomies like whether the algorithm is a distributed/decentralized OR if it is a centralized algorithm, where all decision making is done by a single "god" entity, which then instructs other robot agents of how to move.
// - What kind of guarantees the algorithm offer:
// - Are the planned routes optional with regard to one or more (independent) variables
//   - time it takes to get from A to B
//   - the distance a robot needs to traverse to get from A to B
//   - A feasible list of trajectories that the robot can satisfy given its motion/dynamic/kinematic model e.g. not all turns/paths are feasible for a differential robot compared to a robot using mechanum wheels.

// robustness in the presence of detrimental stochastic processes, like
// - A dynamic environment where things can move around. This invalidates algorithms that assume a static environment.
// - Noise/interference in the communication medium e.g. GPS, or radio interference causing communicating agents not being able to reach each other.

// is the algorithm classical, or more modern like system using learning/AI?
// - sampling based?
// - graph-based?
// - potential field?

// There are several indicators for a good path planning algorithm.
// Some well-known indicators are:
// - the path length,
// - the computational speed
// - the smoothness of the path
// - the energy cost
// - safety, both for equipment robot, but also for any humans that might operate/interact/be in the environment

// there is a distinction between path planning and trajectory planning
// taken from the survey paper:
// A backbone process required by an autonomous robotic system is path planning [4, 5]. Path planning is the problem of finding an obstacle-free path to the desired destination. In contrast with trajectory planning, a path planning problem ignores the temporal evolution of motion which means neither velocities nor acceleration is taken into account

// is there a need to synchronize in time the ordering of operations/messages?





#let coordinator = box(circle(radius: 0.35em, fill: theme.peach.lighten(70%), stroke: theme.peach.lighten(20%)), baseline: 0.05em)
#let follower = box(circle(radius: 0.35em, fill: theme.blue.lighten(70%), stroke: theme.blue.lighten(20%)), baseline: 0.05em)

#let communication-line = {
  // let l = line(length: 5pt, stroke: theme.overlay2)
  // let n = 3
  // let lines = range(n).map(_ => l)
  // box(grid(rows: 1, columns: n, column-gutter: 0.3em, ..lines), baseline: -0.25em)
  let l = place(dy: -0.35em, line(length: 1.6em, stroke: (thickness: 2pt, paint: theme.overlay2, dash: "dashed")))
  box(inset: (x: 2pt), outset: (y: 2pt), l + h(1.6em))
}

#let velocity-vector = {
  import cetz.draw: *
// #polygon(
//   fill: blue.lighten(80%),
//   stroke: blue,
//   (20%, 0pt),
//   (60%, 0pt),
//   (80%, 2cm),
//   (0%,  2cm),
// )
  let c = theme.maroon.lighten(30%)
  let arrow-head = polygon(fill: c, (0em, 0em), (0em, -0.7em), (0.7em, -0.35em))
  let dots = 3
  // let dotted = grid(rows: 1, columns: dots, column-gutter: 0.1em, ..range(dots).map(_ => text(c, [.])))
  let dotted = place(dy: -0.5em, cetz.canvas({line((0em, 0em), (1.5em, 0em), stroke: (paint: c, dash: "dotted"), mark: (end: "stealth", fill: c))}))
  box(inset: (x: 2pt), outset: (y: 2pt), [#dotted#h(1.5em)]) //, baseline: -0.25em)
  // box(inset: (x: 2pt), outset: (y: 2pt), ) //, baseline: 0.05em)
  // box(grid(rows: 1, columns: 2, column-gutter: 0.3em, dotted, arrow-head, ), baseline: -0.5em)
  // box(polygon(fill: c, (0pt, 0pt), (0pt, -8pt), (8pt, -4pt)), baseline: -0.5em)
}


  // line(from, to, stroke: (dash: "dashed", paint: theme.overlay2))


  // velocity
  // let c = theme.maroon.lighten(30%)
#figure(
  std-block(
    image("../figures/out/multi-robot-path-planning-classification.svg", width: 80%),
  ),
  caption: [Multi-robot path planning can at a high level be classified as: Centralized, Decentralized, Distributed, depending on how decisions are arrived at across the group of robots. Orange #coordinator are robotic agents that take part in path planning. Blue #follower are ones that receive instructions on how to update its state. An edge #communication-line represents communication between the two vertices. Lastly, an arrow #velocity-vector represents the planned velocity at the current timestep.
]
) <f.multi-robot-path-planning-classification>

== Centralized Approaches <s.related-works-centralized>

In the centralized case, path planning solutions are laid out in hierarchical structure, where a single computing unit, either a remote server or another robot unit, is responsible for generating a joint path for all robots to follow. In this model robots will unicast relevant information about their current state to the decision maker, and receive instructions from it on what trajectory they have to follow.

=== Artificial Potential Field <s.related-works-potential-field>

Fethi Matoui #etal@matoui_contribution_2020 explores a centralized approach for the coordination of multiple unicycle robots in a two-dimensional workspace where they make use of an #acr("APF") to generate collision free trajectories. #acrpl("APF") are an intuitive way of thinking about trajectory planning. The entire workspace is overlaid with a vector field, where obstacles, either static or other moving elements, are assigned repulsive forces. The target destination is given an attractive force to pull the robot towards it. The gradient descent, algorithm is then used to solve for an admissible trajectory. Each robot's next pose is determined by moving in the direction of the negative gradient of the total potential field. This gradient represents the combined influence of attractive and repulsive forces acting on the robot. As in gradient descent problems, such as the #acr("SGD") method commonly used for training deep learning models, it is important to avoid creating a vector field where the robot could get trapped in a local minima. #acr("APF") alone is not enough to do conflict resolution when two or more robots are close to each other and follow the same slope. To handle this their supervisor node assigns a numeric priority to each robot such that they form a total ordering. When two robots are within a configurable distance of each other, the priority assignment is used to scale the repulsive force, that each robot exhibit on another. The total ordering ensures that the repulsive force excerted is never equal. They motivate their choice of architecture by arguing that centralizing core processing at a single supervisor node eliminates the need for the other robots to have sophisticated sensors or powerful computing units, thereby reducing operational costs. However, they acknowledge that their method does not scale well with an increasing number of robots, as the computational resources can only be scaled vertically, unlike in distributed and decentralized architectures where scaling can be done horizontally@multi-robot-path-planning-review.

== Decentralized Approaches <s.related-works-decentralized>

A general trend in more recent literature is a stronger focus on strategies that do not rely on a centralized architecture@liu_learning_2023@zhang2023multirobot@gbpplanner@orca@bazzana_handling_2023. Reasons often brought up to discourage centralized approaches include their limitations in vertical scaling of compute resources, as seen in@matoui_contribution_2020, as the configuration space often grows exponentially with the number of robots. Additionally, coordination can become a significant bottleneck when all communication must go back and forth from a centralized service. This bottleneck not only increases latency but also risks single points of failure that can incapacitate the entire system. Consequently, decentralized and distributed approaches are increasingly favored for their scalability, robustness, and ability to handle complex, dynamic environments more efficiently.

// A prominent method for doing decentralized collision avoidance and trajectory planning is #acr("ORCA") proposed by van den Berg et al. @orca. They utilize the concept of velocity obstacles to define sets of velocities that could lead to collisions between robots over a configurable time horizon $tau$. Robots exists in a 2D workspace and are modelled as a circle having a center point $p$ and radius $r$ and velocity $v$. A strong assumption made is that these three state properties can be observed by all other robots at any given time with _perfect_ accuracy. Furthermore robots are considered to be holonomic. The core of their method, computes half-planes of permissible velocities for each robot, ensuring collision-free movement by solving a set of linear constraints using linear programming. The robots iteratively adjust their velocities to stay within these permissible regions. Their method also incorporates static obstacle avoidance by extending the velocity obstacle concept by modelling each obstacle as a set of line segments that together enclose a convex polygon. As each obstable is static their preferred velocity emposed on the surrounding robots as velocity constraints are set to $0$. In densely packed scenarios it can happen that the solver outputs that no feasible solution exists to satisfy the robots preferred velocity $v_("pref")$. When this happens the algorithm temporarily relaxes the velocity constraints imposed by other robots until a possible solution is found. Permitted velocities for the robot with respect to obstacles should be hard, as collisions with obstacles should be strongly avoided. Therefore the constraints imposed by obstacles are not relaxed. They demontrate in simulation that their method can be used even with thousands of robots in close proximity of each other. And still achieve smooth trajectories.

=== Optimal Reciprocal Collision Avoidance <s.related-works-orca>

A prominent method for decentralized collision avoidance and trajectory planning is #acr("ORCA"), proposed by Van Den Berg #etal.@orca. They utilize the concept of velocity obstacles to define sets of velocities that can lead to collisions between robots over a configurable time horizon $tau$. Robots exist in a 2D workspace and are modeled as circles with a center point $p$, radius $r$, and velocity $v$. A significant assumption made, is that these state properties can be observed by all other robots at any given time with perfect accuracy. Furthermore, robots are considered to be holonomic. The core of their method computes half-planes of permissible velocities for each robot, ensuring collision-free movement by solving a set of linear constraints using linear programming. The robots iteratively adjust their velocities to stay within these permissible regions. Their method also incorporates static obstacle avoidance by extending the velocity obstacle concept, modeling each obstacle as a set of line segments that together enclose a convex polygon. As each obstacle is static, the preferred velocity imposed on the surrounding robots as velocity constraints is set to zero. In densely packed scenarios, it can happen that the solver finds no feasible solution to satisfy the robots' preferred velocities $v_("pref")$. When this occurs, the algorithm temporarily relaxes the velocity constraints imposed by other robots until a possible solution is found. However, constraints imposed by obstacles are not relaxed, as collisions with obstacles must be strongly avoided. They demonstrate in simulations that their method can be used with thousands of robots in close proximity, still achieving admissible trajectories. This demonstrates one of the clear benefits of scalability in comparison to centralized methods.

=== Game Theory


In a recent paper published in 2023, Xinjie #etal. @liu_learning_2023 presented a unique game-theoretic approach for decentralized path planning and collision avoidance using game theory as the fundamental model for collision avoidance. Contrary to #acr("ORCA")@orca they make no assumption that other moving agents operate under the same algorithm as the robot itself. Rather they consider the objective of others as being initially unknown to the robot .i.e. the robot's perspective of the world is ego-centric. The concept of forward- and inverse games from Game theory are then used to iteratively update the robots model of others objective, and their strategy for how they are going to achieve that objective. In forward games, the objectives of players are known, and the task is to find players' strategies. In contrast, inverse games take partial observations of strategies as inputs to recover initially unknown objectives. This is similar to how a human would operate when driving around in traffic. As a driver, you have no way of knowing the other drivers' true objective, but by observing their behaviour you are able to form a likelihood model over their objective, and make predictions about how they are going to move. The strength of their method lies in its ability to handle environments with heterogeneous agents, such as a factory floor with various vehicles and humans that the robot cannot communicate with to determine their objectives. Their approach works with partial and noisy observations using a Gaussian observation model for state estimations from sensors. This quality is necesssary for most real-world deployments. Through both simulation and real-world experiments, they demonstrate that their method is robust and can operate in real-time on physical hardware.


// The strength of their method is that it allows robot agents to better handle environments with heterogenous agents. For example a factory floor where there might be other vehicles and humans moving around, that the robot is not able to communicate with in order to obtain their objective. Their method, is designed to operate with partial and noisy observations, by employing a Gaussian observation model for state estimations coming from sensors. Another key quality for deploying such a approach in the real world. Through both simulation and real-world experiments they demonstrate that their method is robust and able to run in real-time on physical hardware.




// - This is similar to how a human would operate when driving around in traffic. As a driver you have no way of knowing other drivers true objective but by observing their behaviour you are able to form a likelihood model over their objective and how that partial information influence your prediction about how they are going to move.


// Their method, designed to operate with partial and noisy observations, involves an adaptive model-predictive game solver that infers the objectives of other agents in real-time. Their algorithms works as follows. At each timestamp

// The key innovation in their approach is the integration of a differentiable trajectory game solver. This solver computes the gradients of the game solution, enabling the use of gradient descent for estimating the unknown objectives of other agents. This process involves solving the game’s first-order necessary conditions, framed as a mixed complementarity problem (MCP). The differentiable nature of this solver allows it to be combined with other differentiable components, such as neural networks, enhancing its adaptability and efficiency.


// - The strength of their method is ...

// - adaptive model-predictive game solver

// - a model-predictive game solver, which adapts to unknown opponents’ objectives and solves for generalized Nash equilibrium (GNE) strategies. The adaptivity of our approach is enabled by a differentiable trajectory game solver whose gradient signal is used for MLE of opponents’ objectives.

// - computes forward game solutions while estimating player objectives.

// - objectives of other agents, such as humans are often initially unknown to a robot.


// - reducing the problem to solving a low-dimensional linear program.
// - assume that the robot is holonomic, i.e. it can move in any direction, such that the control input of each robot is simply given by a two-dimensional velocity vector. Also, we assume that each robot has perfect sensing, and is able to infer the exact shape, position and velocity of obstacles and other robots in the environment
// - Our approach is velocity-based. That implies that each robot takes into account the observed velocity of other robots in order to avoid collisions with them, and also that the robot selects its own velocity from its velocity space in which certain regions are marked as ‘forbidden’ because of the presence of other robots

// - Our formulation, “optimal reciprocal collision avoidance”, infers for each other robot a half-plane (in velocity-space) of velocities that are allowed to be selected in order to guarantee collision avoidance. The robot then selects its optimal velocity from the intersection of all permitted half-planes, which can be done efficiently using linear programming. Under certain conditions with densely packed robots, the resulting linear program may be infeasible, in which case we select the ‘safest possible’ velocity using a three-dimensional linear program.


// - Demonstrate their technique to work in simulation with thousands of robots

// - It is assumed that each robot has a center point $p$ of its circular or convex polygonal shape, a radius $r$ and a velocity $v$ that can all be observed *perfectly* by other robots in the workspace.

// - The optimization function is the distance to the preferred velocity vpref A .Even though this is a quadratic optimization function, it does not invalidate the linear programming characteristics, as it has only one local minimum

// - On the other hand, the constraints on the permitted velocities for the robot with respect to obstacles should be hard, as collisions with obstacles should be avoided at all cost. Therefore, when the linear program of Section 5.1 is infeasible due to a high density of robots, the constraints of the obstacles are not relaxed

// - We note that the half-planes of permitted velocities with respect to obstacles as defined above only make sure that the robot avoids collisions with the obstacle; they do not make the robot move around them. The direction of motion around obstacles towards the robot’s goal should be reflected in the robot’s preferred velocity,which could be obtained using (efficient) global path planning techniques.




== Distributed approaches <s.related-works-distributed>

The third architectural approach to multi-robot path planning models the robot system as a distributed one, where agents communicate to jointly arrive at collision-free paths. This methodology allows robots to share their internal states and external observations. It also enables coordination for higher-level goals, such as changing routes to optimize for robots with different priorities or urgent tasks. However, it introduces challenges common to traditional distributed systems, such as synchronizing shared states, ensuring fault tolerance against unavailable peers due to network latency, and handling variable message arrival times caused by network congestion@review-of-distributed-robotic-systems@distributed-optimization-methods-for-multi-robot-systems-part-2-a-survey. The content of messages exchanged between robots varies between different methods.


=== Nonlinear Model-Predictive Control <s.related-works-nmpc>

Laura Ferranti #etal demonstrates how to utilize #acr("NMPC") in an asynchronous message passing scenario to solve for collision-free paths under the possible presence of messages being delayed. Messages from a robot $R_i$ to $R_j$ are composed of its estimated difference in position between its center point and $R_j$. Together with its estimated heading of $R_j$ with respect to $R_i$'s body frame. In the presence of message delays from nearby robots to $R_i$, robot $R_i$ will inflate its collision region by an amount proportional to the possible error $R_i$'s neighbors might have on the current position of $R_i$, to preserve safety. The predictions generated by the #acr("NMPC") solver are adjusted based on the number of messages lost, and the time measured for recent asynchronuos messages to ararrivey changing the prediction horizon. They test their method with real-world hardware in an intersection crossing scenario with varying number of robots. Their results demonstrate that the asynchronous algorithm successfully achieved the planning goals while handling packet losses resulting from the robots falling out of sync during coordination@distributed-nonlinear-trajectory-optimization-for-multi-robot-motion-planning.

// The NMPC solver updates its predictions to account for communication delays and lost messages, using the predicted speed to estimate the final position.The NMPC solver updates its predictions to account for communication delays and lost messages, using the predicted speed to estimate the final position.


=== Graph Neural Networks <s.related-works-gnn>

Li Qingbiao #etal presents the idea of using #acrpl("GNN") for distributed multi-agent path planning in @li2020graph. Their method is split into three steps, each incorporating a different deep learning architecture to process different representations of information available. Each robot takes in an image signal of the environment, represented as a pixel map with static obstacles, other robots, and the goal position within its field of view (FOV). This input is processed by a #acr("CNN") to extract high-level features, which are then communicated to nearby robots to be processed by a #acr("GNN"). The GNN aggregates and fuses the states within the communication radius, producing a hyper-representation of the fused information. This data is then passed to a #acr("MLP") to predict the next action for each robot. Through simulation results they report that their method performs well and even better than #acr("ORCA")@orca when comparing on differences of the planned path from the optimal. But at the same time they bring attention to the fact that their way of modelling the environment and communication is simplistic, and would need more work to robustly be deployed in real-world environments.

// The authors identify some issues with using GNNs in decentralized planning.  While the approach generalizes well to larger teams, handling significantly larger numbers of robots or more complex environments might still pose scalability issues.

// #k[
//   Le chat
//
// decentralized framework composed of Convolutional Neural Networks (CNNs) and Graph Neural Networks (GNNs). Each robot takes in an image signal of the environment, represented as a pixel map with static obstacles, other robots, and the goal position within its field of view (FOV). This input is processed by a CNN to extract high-level features, which are then communicated to nearby robots using a GNN. The GNN aggregates and fuses the states within the communication radius, producing a hyper-representation of the fused information. This data is then passed to a multi-layer perceptron (MLP) to predict the next action for each robot.
//   This 3-step model is then tested
//
// ]
//
// - Takes in an image signal of the environment as a seen from above pixel map, with pixels for static obstacles other actors and the goal pose limited to the robots FOV and then feed it into a CNN that is run internally on each robot.
//
// - These observations can then be communicated to nearby robots. The intuition behind using a CNN is to process the input map Zit into a higher-level feature tensor  ̃ xit describing the observation, goal and states of other robots. This feature tensor is then transmitted via the communication network
//
//  - The decentralized framework consists of a CNN to extract observations from the input tensor, a GNN to exchange information between the neighboring agents, and an MLP to predict the actions
//
// - robots are restricted to partial observations
//
// - action policy MLP, which is used to predict the action a robot should take
//
// - (1st channel: partial observation of the environment; 2nd channel: the position of goal (pi дoal ), or its projection onto the boundary of the field-of-view; 3rd channel: self (agent) at center, with other agents within its field-of-view).
//
// - Each individual robot communicates its compressed observation vector  ̃ xit with neighboring robots within its communication radius rCOMM over the multi-hop communication network, whereby the number of executed hops is limited by K. As described in Sec. 4.2, we apply our GNN to aggregate and fuse the states (  ̃ xj t ) within this K-hop neighborhood of robots j ∈ Ni , for each robot i. The output of the communication GNN is a hyper-representation of the fused information of the robot itself and its K-hop neighbors, which is passed to the action policy
//
// architecture is composed of a convolutional neural network (CNN) that extracts adequate features from local observations, and a graph neural network (GNN) that communicates these features among robots.

=== Gaussian Belief Propagation on Factor Graphs <s.related-works-gbp>

Another method with contributions from multiple authors is the use of factor graphs to represent probabilistic relationships between variables with potentially coupled constraints@bazzana_handling_2023@patwardhan_distributing_2023@robotweb@factor-graphs-exploiting-structure-in-robotics. Factor graphs are undirected bipartite graph structures with two types of nodes: variables and factors. Variables represent possible states or unknowns, while factors represent constraints between these variables. This versatile structure solves constrained optimization problems in an iterative fashion. It has been used in different important areas of robotics such as #acr("SLAM"), #acr("SfM"), and optimal control to name a few@factor-graphs-exploiting-structure-in-robotics. In #acr("SLAM"), factor graphs can be used for estimating a robot's pose over time, the robot poses and landmark measurements are variables connected by binary factors representing measurements that correlate them.


Patwardhan #etal presents the idea of using factor graphs for multi-agent path planning in _Distributing Collaborative Multi-Robot Planning with Gaussian Belief Propagation_@gbpplanner. In their formulation each robot has a factor graph where variables are possible future states spread out over a forward time window. Four different factors are used; pose, obstacle, dynamic and interrobot. Each one encodes a different constraint needed for efficient and collision-free paths. As this thesis aims to reimplement and extend the work by Patwardhan #etal a detailed explanation of each factor will be omitted here, and instead be presented in detail in @s.m.factor-graph. The most important factor to mention here is the interrobot factor which is used to facilitate communication between robots. These factors are ephemeral and are added whenever two robots are within communication range of each other. They add shared constraints of minimum tolerable distance between variables in each robots factorgraph. Their approach incorporates #acr("GBP") as the inference algorithm used to determine marginal distributions for the future poses which best satisfy all constraints. Robots exchange messages between each other where the payload are marginalized multivariable gaussian distributions that describe a robots belief about the other robots future states.
They demonstrate in a simulation how their method can handle high-density scenarios securely, achieving significantly shorter makespans compared to #acr("ORCA"), while still generating smooth paths.
One key strength of their approach is its robustness in the presence of communication failures. As new messages are iteratively incorporated into the other robots' factor graphs, there are no strict constraints on messages arriving out of order or guarantees about the frequency of message arrival. These attributes enable it to tackle some of the previously listed challenges common in distributed multi-robot path planning systems. Qualities like these, along with others to be presented, motivate the choice of this method as the basis for further analysis and improvement in this thesis.


// // _A Robot Web for Distributed Many-Device Localization_, by incorporating #acr("GBP") as the messaging scheme used for doing inference on a joint factorgraph shared between robots.
//
// earlier showed that large parts of the same approach can be used fro multi robot localization demonstrating the versatility of their method.
//
// that #acr("GBP") can be utilised to solve multi-agent _localization_
//
// // *good*
//
// - This partitioning allows robots to operate on smaller, manageable segments of the overall graph.
// // - over a forward time window
// - local planner
//
//
// - constraint and obstacle factors
//
// @bazzana_handling_2023
//
// - A Robot Web for Distributed Many-Device Localization
//
// proposes the idea of modelling the communication scheme using for exchanging messages between robots similar to how hypermedia is exchanged on the world wide web using a protocol like HTTP
//
// - constraint and obstacle factors
//
// @bazzana_handling_2023
