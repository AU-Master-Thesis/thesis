#import "../../lib/mod.typ": *
== Related Works <s.b.related-works>

The field of multi-agent path planning has a rich literature spanning several decades, with numerous proposed methods. One of the key taxonomies that can be used to classify existing methods are in respect to how they distribute the computation of the jointly planned path among the robotic agents. In the majority of cases, methods attempt to solve the problem by one of three ways: _Centralized_, _Decentralized_ or _Distributed_@multi-robot-path-planning-review. A depiction of what is meant by each is shown in @f.multi-robot-path-planning-classification.
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
  let l = line(length: 5pt, stroke: theme.overlay2)
  let n = 3
  let lines = range(n).map(_ => l)
  box(grid(rows: 1, columns: n, column-gutter: 0.3em, ..lines), baseline: -0.25em)
}

#let velocity-vector = {
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
  let dotted = grid(rows: 1, columns: dots, column-gutter: 0.1em, ..range(dots).map(_ => text(c, [.])))
  box(dotted, baseline: -0.25em)
  box(arrow-head, baseline: 0.05em)
  // box(grid(rows: 1, columns: 2, column-gutter: 0.3em, dotted, arrow-head, ), baseline: -0.5em)
  // box(polygon(fill: c, (0pt, 0pt), (0pt, -8pt), (8pt, -4pt)), baseline: -0.5em)
}


  // line(from, to, stroke: (dash: "dashed", paint: theme.overlay2))


  // velocity
  // let c = theme.maroon.lighten(30%)
#figure(
  std-block(
    image("../../figures/out/multi-robot-path-planning-classification.svg", width: 80%),
  ),
  caption: [Multi-robot path planning can at a high level be classified as: Centralized or Decentralized, Distributed, depending on how decisions are arrived at across the group of robots. Orange #coordinator are robotic agents that take part in path planning. Blue #follower are ones that receive instructions on how to update its state. An #communication-line edge represent communication between the two vertices. #velocity-vector represent the planned velocity at the current timestep.
]
) <f.multi-robot-path-planning-classification>

=== Centralized approaches <s.related-works-centralized>

In the centralized case path planning solutions are laid out in hiearchial structure, where a single computing unit, either a remote server or another robotic agent, is responsible for generating a joint path for all robots to follow. In this model robots will unicast relevant information about their current state to the decision maker. And receive instructions from it on what trajectory they have to follow.

Fethi Matoui et al@matoui_contribution_2020 explore a centralized approach for the coordination of multiple unicycle robots in a two-dimensional workspace where they make use of an #acr("APF") to generate collision free trajectories. #acrpl("APF") are an intuitive way of thinking about trajectory planning. The entire workspace is overlaid with a vector field, where obstacles, be they static or other moving elements, are assigned repulsive forces. And target destinations are given an attractive force to pull the robot towards it. The gradient descent algorithm is then used to solve for an admissible trajectory. Than is each robot's next pose is determined by moving in the direction of the negative gradient of the total potential field. This gradient represents the combined influence of attractive and repulsive forces acting on the robot. Similar to other problems using gradient descent like the #acr("SGD") method often used in training of deep learning models, care must be taken to not construct a vector field, where the robot gets stuck in a local minima. #acr("APF") alone is not enough to do conflict resolution when two or more robots are close to each and follow the same slope. To handle this their supervisor node assign a numeric priority to each robot such that they form a total ordering. When two robots are within a configurable distance of each other the priority assignment is used to scale the repulsive force each robot exhibit on each other. The total ordering ensures that the repulsive force excerted is never equal. They motivate their choice of architecture by the argument that by having the core processing at a single supervisor node the other robots do not need to have have sophisticated sensors or a powerful computing unit. Which is advantageous for operations cost. But at the same time they admit that their method does not scale well, when the number of robots increases as the compute can only be scaled vertically and not horizontally as is the case for both the distributed and decentralized architecture@multi-robot-path-planning-review.

=== Decentralized approaches <s.related-works-decentralized>

A general trend in more recent literature is a stronger focus on strategies that do not rely on a centralized architecture@zhang2023multirobot@gbpplanner@orca@liu_learning_2023@bazzana_handling_2023. Reasons often brought up to discourage centralized approaches include their limitations in vertical scaling of compute resources, as seen in@matoui_contribution_2020, as the configuration space often grows exponentially with the number of robots. Additionally, coordination can become a significant bottleneck when all communication must go back and forth from a centralized service. This bottleneck not only increases latency but also risks single points of failure that can incapacitate the entire system. Consequently, decentralized and distributed approaches are increasingly favored for their scalability, robustness, and ability to handle complex, dynamic environments more efficiently.

// A prominent method for doing decentralized collision avoidance and trajectory planning is #acr("ORCA") proposed by van den Berg et al. @orca. They utilize the concept of velocity obstacles to define sets of velocities that could lead to collisions between robots over a configurable time horizon $tau$. Robots exists in a 2D workspace and are modelled as a circle having a center point $p$ and radius $r$ and velocity $v$. A strong assumption made is that these three state properties can be observed by all other robots at any given time with _perfect_ accuracy. Furthermore robots are considered to be holonomic. The core of their method, computes half-planes of permissible velocities for each robot, ensuring collision-free movement by solving a set of linear constraints using linear programming. The robots iteratively adjust their velocities to stay within these permissible regions. Their method also incorporates static obstacle avoidance by extending the velocity obstacle concept by modelling each obstacle as a set of line segments that together enclose a convex polygon. As each obstable is static their preferred velocity emposed on the surrounding robots as velocity constraints are set to $0$. In densely packed scenarios it can happen that the solver outputs that no feasible solution exists to satisfy the robots preferred velocity $v_("pref")$. When this happens the algorithm temporarily relaxes the velocity constraints imposed by other robots until a possible solution is found. Permitted velocities for the robot with respect to obstacles should be hard, as collisions with obstacles should be strongly avoided. Therefore the constraints imposed by obstacles are not relaxed. They demontrate in simulation that their method can be used even with thousands of robots in close proximity of each other. And still achieve smooth trajectories.


A prominent method for decentralized collision avoidance and trajectory planning is #acr("ORCA"), proposed by Van Den Berg et al.@orca. They utilize the concept of velocity obstacles to define sets of velocities that can lead to collisions between robots over a configurable time horizon $tau$. Robots exist in a 2D workspace and are modeled as circles with a center point $p$, radius $r$, and velocity $v$. A significant assumption made is that these state properties can be observed by all other robots at any given time with perfect accuracy. Furthermore, robots are considered to be holonomic. The core of their method computes half-planes of permissible velocities for each robot, ensuring collision-free movement by solving a set of linear constraints using linear programming. The robots iteratively adjust their velocities to stay within these permissible regions. Their method also incorporates static obstacle avoidance by extending the velocity obstacle concept, modeling each obstacle as a set of line segments that together enclose a convex polygon. As each obstacle is static, the preferred velocity imposed on the surrounding robots as velocity constraints is set to zero. In densely packed scenarios, it can happen that the solver finds no feasible solution to satisfy the robots' preferred velocities $v_("pref")$. When this occurs, the algorithm temporarily relaxes the velocity constraints imposed by other robots until a possible solution is found. However, constraints imposed by obstacles are not relaxed, as collisions with obstacles must be strongly avoided. They demonstrate in simulations that their method can be used with thousands of robots in close proximity, still achieving smooth trajectories. This demonstrates one of the clear benefits of scalability in comparison to centralised methods.

==== Game Theory

#k[read through and improve language]

In a recent paper published in 2023, Xinjie et al. @liu_learning_2023 presented a unique game-theoretic approach for decentralized path planning and collision avoidance using game theory as the fundamental model for doing collision avoidance. Contrary to #acr("ORCA")@orca they make no assumption that other moving agents operate under the same algorithm as the robot itself. Rather they consider the objective of others as being initially unknown to the robot .i.e. the robots perspective of the world is ego-centric. The game theoretical concept of forward- and inverse games are then used to iteratively update the robots model of others objective, and strategy for how they are going to achieve that object. In forward games, the objectives of players are known, and the task is to find players’ strategies. By contrast, inverse games take (partial) observations of strategies as inputs to recover initially unknown objectives. This is similar to how a human would operate when driving around in traffic. As a driver you have no way of knowing other drivers true objective but by observing their behaviour you are able to form a likelihood model over their objective and how that partial information influence your prediction about how they are going to move. The strength of their method is that it allows robot agents to better handle environments with heterogenous agents. For example a factory floor where there might be other vehicles and humans moving around, that the robot is not able to communicate with in order to obtain their objective. Their method, is designed to operate with partial and noisy observations, by employing a Gaussian observation model for state estimations coming from sensors. Another key quality for deploying such a approach in the real world. Through both simulation and rea-world experiments they demonstrate that their method is robust and able to run in real-time on hardware.


#k[maximum likelihood estimation]

// - This is similar to how a human would operate when driving around in traffic. As a driver you have no way of knowing other drivers true objective but by observing their behaviour you are able to form a likelihood model over their objective and how that partial information influence your prediction about how they are going to move.


// Their method, designed to operate with partial and noisy observations, involves an adaptive model-predictive game solver that infers the objectives of other agents in real-time. Their algorithms works as follows. At each timestemp

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




=== Distributed approaches <s.related-works-distributed>

The third architectural approach to multi-robot path planning models the robot system as a distributed one, where agents communicate to jointly arrive at collision-free paths. This methodology allows robots to share their internal states and external observations. It also enables coordination for higher-level goals, such as changing routes to optimize for robots with different priorities or urgent tasks. However, it introduces challenges common to traditional distributed systems, such as synchronizing shared states, ensuring fault tolerance against unavailable peers due to network latency, and handling variable message arrival times caused by network congestion@review-of-distributed-robotic-systems@distributed-optimization-methods-for-multi-robot-systems-part-2-a-survey. The content of messages exchanged between robots varies between different methods.

Laura Ferranti et al. demonstrates how to utilize #acr("NMPC") in an asynchronous message passing scenario to solve for collision free paths under the possible presence of packet delay. Messages from a robot $R_i$ to $R_j$ are composed of its estimated difference in position between its center point and $R_j$. Together with its estimated heading of $R_j$ wrt. $R_i$ body frame. In the presence of packet delay from nearby robots to $R_i$, robot $R_i$ will inflate its collision region by an amount proportional to the possible error $R_i$’s neighbors might have on the current position of $R_i$ to preserve safety. The predictions generated by the #acr("NMPC") solver are adjusted by the necessary number of steps to account for asynchronous communications and packet losses, interpolating the end of the horizon based on their predicted speed. They test their method with real-world hardware in an intersection crossing scenario with varying number of robots. Their results demonstrate that the asynchronous algorithm successfully achieved the planning goals while handling packet losses resulting from the robots falling out of sync during coordination@distributed-nonlinear-trajectory-optimization-for-multi-robot-motion-planning.


#line(length: 100%, stroke: 10pt + theme.maroon)

//
// A general trend in more recent literature is a stronger focus on strategies that do not rely on a centralized architecture@zhang2023multirobot@gbpplanner@orca@liu_learning_2023@bazzana_handling_2023. Reasons often brought up to discourage
//
// - limited by vertical scaling
// - Configuration space often grows exponentially with the number of robots
// - Coordiation can become a bottleneck when all communication has to go back and fourth from a centralized service.
//

// and possibility of more easily doing hkorizontal scaling in other to encompass a larger problem. #kristoffer[but there is a limit for how much vertical scaling you can do of the supervisor unit]

// - admit that their method does not scale well, when the number of robots increases

// Each robot's next pose is determined by moving in the direction of the negative gradient of the total potential field. This gradient represents the combined influence of attractive and repulsive forces acting on the robot.

// - conflict resolution

// This alone is not enough to ensure that

// robots do not collide, as it does not guarantee temporal consistency

// Local minima



// - That further ensures a state update that is feasible for the dynamics/kinematics of the unicycle model
// - Each robot receives from the centralized controller the angular control speeds applied to the right and left wheels.


// - Does not mention how they make state estimation of the robots

// - Known environment with static obstacles and moving/dynamic robots


// - Split over four modules
  // + Localization module
  // + Attraction towards the target module
  // + Collision avoidance module
  // + Conflict resolution module

// - APF simulating attractive and repulsive forces
// - Attractive Force: The goal exerts an attractive force on the robot, pulling it towards the target.
// - Repulsive Force: Obstacles exert a repulsive force, pushing the robot away to avoid collisions.
// - Total Force: The robot's movement is determined by the combination of these forces. The robot follows the path of the resultant force vector, moving towards the goal while avoiding obstacles.
// - Potential Function: The environment is represented as a potential field where the goal has a low potential, and obstacles have high potential. The robot moves along the gradient of this field, aiming to reach the minimum potential at the goal.

// QUOTE
// First, the robots used do not need embedded sensors or a powerful computing unit. This greatly reduces their cost. In addition, the concentration of sensors at a supervisor level provides a better understanding of the overall environment.



// When a viable set of paths are found they are


// more fault tolerant and robust in complex dynamic environments


// Each approach has its pros and cons and can be equally applicable depending on the


// Central solver

// increased coordination




#k[
  Good words/sentences to use:
  - static/holonomic and dynamic/non-holonomically-constrained systems
  - Taxonomy of different approaches

  - Factorgraphs used for other areas of robotics such as
    - SLAM (Simultaneous Localization and Mapping)
    - SfM (Structure-from-Motion)
]


// Approaches vary in assumptions about the environment and the holonomic constraints of the robots. A critical element in multi-robot systems, path planning exhibits large dichotomies, such as whether an algorithm is centralized, with a single decision-making entity, or decentralized. The guarantees offered by these algorithms also differ, addressing factors like travel time, distance, and feasible trajectories based on the robot's motion model. Additionally, robustness to dynamic environments and communication interference is crucial. The methods range from classical approaches to modern AI-driven techniques, including sampling-based, graph-based, and potential field methods. Key indicators of a good path planning algorithm include path length, computational speed, smoothness, energy cost, and safety. Furthermore, it's important to distinguish between path planning and trajectory planning, as the former focuses solely on finding an obstacle-free path without considering the temporal aspects of motion such as the velocity and jerk needed to safely executed the planned path.


Originally Murai _et al._ showed, with their _A Robot Web for Distributed Many-Device Localisation_, that #acr("GBP") can be utilised to solve multi-agent _localisation_. Then Patwardhan _et al._ showed that the same algorithm structure can be adapted to multi-agent _planning_. This thesis aims to extend the work by Patwardhan _et al._@gbpplanner to include a global planning layer, which can provide a more robust solution to the multi-agent planning in highly complex environments. As such @gbpplanner will be covered more thoroughly in its own dedicated section below, see @background-related-works-gbp-planner.

#todo[maybe the 'dedicated section' is simply the rest of the background which contains the relevant theory.]

#todo[Split the related works into a subsection for each important work.]


- A Robot Web for Distributed Many-Device Localisation

proposes the idea of modelling the communication scheme using for exchanging messages between robots similar to how hypermedia is exchanged on the world wide web using a protocol like HTTP

- Distributing Collaborative Multi-Robot Planning with Gaussian Belief Propagation

- A comprehensive review of the latest path planning developments for multirobot formation systems

- Handling Constrained Optimization in Factor Graphs for Autonomous Navigation

-  Factor Graphs: Exploiting Structure in Robotics


=== GBP Planner <background-related-works-gbp-planner>

// === ORCA <background-related-works-orca>

// formulate the problem as _reciprocal n-body collision avoidance_


// The paper presents a formal approach to reciprocal n-body collision avoidance for multiple mobile robots. The methodology hinges on the concept of velocity obstacles, which are used to derive sufficient conditions for collision-free motion. The core idea is to compute collision-free actions for each robot independently by solving a low-dimensional linear program. The authors introduce the Optimal Reciprocal Collision Avoidance (ORCA) algorithm, which optimizes each robot's velocity to avoid collisions while maintaining a preferred trajectory. The method assumes each robot can sense the positions and velocities of other robots, and does not rely on communication or central coordination.


// - Linear problem to solve
// - Robot entities does not communicate

// - holonomic, can move in any direction in the plane, i.e. control input is simply given as a 2d vector


=== Handling Constrained Optimization in Factor Graphs for Autonomous Navigation <s.background-related-works.handling>

@bazzana_handling_2023


// Barbara Bazzana


=== #todo[Some approach using deep learning ...]
