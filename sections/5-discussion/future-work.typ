#import "../../lib/mod.typ": *

#pagebreak()

== Future Work

The following sections outline the most important next steps in order to further the work presented by this thesis. The suggestions are based on the idea of what the authors see as the most promising directions for future research, and what would be most beneficial for the field of multi-robot path planning; see @s.fw.3d-uav and @s.fw.advance-networking-simulation. Additionally challenges for going from simulation to real-world deployment are also discussed, see @s.fw.algorithm-enhancements and @s.fw.deployment-interopability.

// Additionally, some future work in terms of the implementation of the #acr("MAGICS") tool is also discussed, see sections #todo[refer to sections here].

=== Algorithm Enhancements <s.fw.algorithm-enhancements>

A limitation of the current approach to estimate obstacles in the environment is that it is assumed to be static, with no moving entities that the robot cannot communicate with to estimate its state. And that a #acr("SDF") representation of the entire environment is known before hand. This works in environments such as logistic facilities, but fails in scenarios where the environment is partially or fully unknown. A key limitation for more broader applicability in other potential application domains. Some existing work on #acr("VIO") based #acr("SLAM") uses factorgraphs as the optimization methodology @factor-graphs-exploiting-structure-in-robotics. Work into combining these two steps; localization and estimation with path planning could prove beneficial as pose estimation constrained with factors relating them to environment features could make the algorithm robust against obstacless. A key challenge is the question of how obstacle factors associated with future variable nodes can be estimated, when the camera cannot sample images into the future. Another limitation is that the dynamics factors are assuming the robot is not subjected to any non-holonomic constraints. A common choice for ground robots is to use differential drive dynamics, that has constraints on its ability to do lateral movements#todo[cite]. A dynamic factor that captures this hard constraint would be necessary for moving towards real-world applicability. Another issue identified with current algorithm, as listed in @s.m.algorithm, is that the horizon state is updated to move closer towards the goal pose irrespective of the current state. If a robot has trouble finding a trajectory, and is moving very little our findings shows, that blindly advancing the horizon state can lead to situations where the robot is stuck with the horizon state having moved beyond an obstacle in a way that makes to robot unable to arrive at a path that would not collide with the obstacle. More sophisticated logic on how to advance the horizon state would be needed in these infrequent situations to ensure more robustness. Finally it would be interesting to investigate the capabilities of the algorithm for factorgraphs with a a dynamic number of variables during the lifetime of the graph. I.e. having it dependant on the desired velocity. To accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, and contrary at a lower desired velocity, fewer variables could be sufficient and less computationally taxing in that case.

// - Model sensing uncertainty to better bridge a move to real-scenario robotics
// - Merge with a #acr("VIO") SLAM solution, and to substitute for obstacle factors in unknown environments with mapping.
//   // - Use ray casting instead of sampling an SDF image of the environment
    // - Obstacle/SDF node will not work if the environment is not static.


// - Use different behavior when communication is very bad. Either change the factor graph by adding new nodes with different policies or a new algorithm all together e.g. the game theory paper we read at the start.

=== Extending to 3D with UAV's <s.fw.3d-uav>

Extending the current algorithm to work in the context of a three-dimensional world would be interesting to explore to open up for broader applicability for use cases where quad-rotor #acrpl("UAV") are deployed. One challenge from this is that state space is more complex with 12 states@tahir2019state#footnote[Position $x,y,z$, linear velocity $dot(x), dot(y), dot(z)$, orientation $phi.alt, theta, psi$ and angular velocity $dot(phi.alt), dot(theta), dot(psi)$.] instead of four. As a result the multivariate normal distribution messages exchanged during variable and factor iteration would be $7$ times larger in terms of bytes, and thereby a lot more computationaliy costly, which could limit the scalability to highly connected cases. Both the dynamic factor and obstable factor would have to be redesigned, with a new static environment representation to replace the #acr("SDF") representation used in 2D.

// #v(-1em)

=== Advance Networking Simulation <s.fw.advance-networking-simulation>

Current networking simulation is very simplistic with robots being able to communicate as long as they are with a given radius of each other and their radio antenna is turned on. Exchange of messages happens instantly and without delay in simulated time. All of which poorly reflects the complexities present in a real-scenario communication. Enhancements could be achieved by adding random delays to messages sent sampled from a stochastic distribution derived from empirical data on multi-robot short distance radio communication. And have the contents of messages be subject to noise through bit flips by modelling the transmission medium as channel with a non-zero chance of noise. With this and other improvements further analysis could be dnone to try and estimate the throughput of the system, in terms of messages per second, and try and estimate how much bandwidth is used. To thoroughly arrive at bounds for how much external communication is possible, to not overload the available bandwidth for other core tasks needing communication access.

// Based on the results, discuss what implications this would have for a real world system.


// communication challenge
//
// And have each robot go through a connection establishment phase to mimic stateful transport layer protocols such as #acr("TCP").
//
// Further analysis on ... to arrive at guidelines/limits
//
// - that would be present to establish connected for TCP based protocols
//


// There are some assumptions and corresponding limitations in the current implementation, which will be improved in future work. Firstly, we assumed that communication between robots was achieved instantly without delay

=== Deployment & Interopability <s.fw.deployment-interopability>

Work has already been done to decouple the factor graph representation from the simulator. But more would be needed to deploy it in a distributed fashion. First each step of the algorithm loop, as listed in @s.m.algorithm, would need to decoupled from the Bevy framework, as its benefits are not substantial outside of a 3D rendered simulation with all entities running on the same host. Other challenges pertains to host discoverability, managing persistent network connections between peers and how to forward the updated pose to hardware motor controllers. The #acr("ROS2") framework would be an obvious consideration for this. Its robust #acr("QoS") middleware architecture to handle erroneous communication. Its support for client/server communication could be used for the message exchange between robots. While #acr("ROS2") application and libraries are primarily written in C++ and Python, due to having official library support. It is possible to use other languages such as Rust by interfacing with the #acr("CFFI") based bindings through projects such as #source-link("https://github.com/ros2-rust/ros2_rust", "ros2_rust")@ros2_rust. Another benefit of this is that it would be possible to make use of the wealth of high quality packages available in the ecosystem, and make it easier for other to make use of the work presented in this thesis and extend it.


// ------------------------------------------------------------------------------


// #kristoffer[
//   Explore opportunities to create a mini dsl to declaratively create the graph.
//
//   Maybe use the `dot` language to create a graph.
//    - It is already a common language for expressing graphs declaratively.
//    - The node kind i.e. variable or factor, and the kind of factor, can be specified in the node attributes.
//    - A missing feature of this language is the inability to specify loops, often we want to repeat the same
//      group of nodes multiple times which is not possible in the dot language.
//    - Another approach is to embed a simple scripting language like `Lua`. That gets evaluated in a VM instance by the simulator, that then returns a table with a fixed schema.
//
//
//   ```dot
//   graph {
//     v1 [variable];
//     v2 [variable];
//     f1 [factor:obstacle];
//     f2 [factor:dynamic];
//     v1 -- f1
//     v1 -- f2
//     v2 -- f2
//   }
//   ```
// ]


// ```rust
// enum Variable {
//   Current(CurrentVariable),
//   InBetween(InBetweenVariable),
//   Horizon(HorizonVariable),
// }
// ```
