#import "../../lib/mod.typ": *
// Additionally, some future work in terms of the implementation of the #acr("MAGICS") tool is also discussed, see sections #todo[refer to sections here].

// #pagebreak()

== Future Work

The following sections outline the most important next steps in order to further the work presented by this thesis. The suggestions are based on the idea of what the authors see as the most promising directions for future research, and what would be most beneficial for the field of multi-robot path planning; see @s.fw.3d-uav and @s.fw.advance-networking-simulation. Additionally challenges for going from simulation to real-world deployment are brought fourth and discussed, see @s.fw.algorithm-enhancements and @s.fw.deployment-interopability.

=== Algorithm Enhancements <s.fw.algorithm-enhancements>

The current approach to estimating obstacles assumes a static environment where all moving entities can be communicated with by each robot. It also requires a pre-known #acr("SDF") representation of the entire environment, which is suitable for logistic facilities but not for scenarios where the environment is partially or fully unknown. There exists work on #acr("VIO") based #acr("SLAM") that uses factorgraphs as the belief optimization algorithm@factor-graphs-exploiting-structure-in-robotics. Work into combining these two steps; localization and estimation with path planning, into a joint factorgraph could prove beneficial. The information contained in the assembled environment map could substitute for the existing obstacle factors. Another limitation is that dynamic factors assume the robot is not subjected to any non-holonomic constraints. A common choice for ground robots is to use differential drive dynamics, that has constraints on the ability to do lateral movements@diffential-drive-constraints. A dynamic factor that captures this hard constraint would be necessary for moving towards real-world applicability. As mentioned earlier, another issue is that the horizon state is updated to move closer to the goal pose regardless of the current state. More sophisticated logic is needed to advance the horizon state in these situations. Finally, it would be valuable to investigate the algorithm's capabilities for factor graphs with a dynamic number of variables throughout the graph's lifetime. For example; if the number of variables depends on the desired velocity, more variables and a longer future horizon might be beneficial for accelerating the robot and increasing its speed. This way, the robot's factor graph can prepare for static and dynamic obstacles further in the future. Conversely, at a lower desired velocity, fewer variables could suffice, making the process less computationally intensive.

// Finally it would be interesting to investigate the capabilities of the algorithm for factorgraphs with a a dynamic number of variables during the lifetime of the graph. I.e. having it dependant on the desired velocity. To accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, and contrary at a lower desired velocity, fewer variables could be sufficient and less computationally taxing in that case.
//
//
//
// Another issue identified with current algorithm
//
//
//
// #line(length: 100%, stroke: 1em + red)
//
// Combining localization and estimation with path planning, using methodologies like VIO-based SLAM with factor graphs, could make the algorithm more robust against obstacles.
//
// A significant challenge is estimating obstacle factors associated with future variable nodes when future images cannot be sampled by the camera. Additionally, the current algorithm does not account for non-holonomic constraints, such as those in differential drive dynamics common in ground robots. A dynamic factor that captures this constraint is necessary for real-world applicability.
//
// Another issue is that the horizon state is updated to move closer to the goal pose regardless of the current state, which can lead to the robot getting stuck. More sophisticated logic is needed to advance the horizon state in these situations. Finally, investigating the capabilities of the algorithm with a dynamic number of variables, depending on the desired velocity, could improve computational efficiency.
//
// #line(length: 100%, stroke: 1em + yellow)
//
//
// A limitation of the current approach to estimate obstacles in the environment is that it is assumed to be static, with no moving entities that the robot cannot communicate with to estimate its state. And that a #acr("SDF") representation of the entire environment is known before hand. This works in environments such as logistic facilities, but fails in scenarios where the environment is partially or fully unknown. A key limitation for more broader applicability in other potential application domains. Some existing work on #acr("VIO") based #acr("SLAM") uses factorgraphs as the optimization methodology @factor-graphs-exploiting-structure-in-robotics. Work into combining these two steps; localization and estimation with path planning could prove beneficial as pose estimation constrained with factors relating them to environment features could make the algorithm robust against obstacless. A key challenge is the question of how obstacle factors associated with future variable nodes can be estimated, when the camera cannot sample images into the future. Another limitation is that the dynamics factors are assuming the robot is not subjected to any non-holonomic constraints. A common choice for ground robots is to use differential drive dynamics, that has constraints on its ability to do lateral movements@diffential-drive-constraints. A dynamic factor that captures this hard constraint would be necessary for moving towards real-world applicability. Another issue identified with current algorithm, as listed in @s.m.algorithm, is that the horizon state is updated to move closer towards the goal pose irrespective of the current state. If a robot has trouble finding a trajectory, and is moving very little our findings shows, that blindly advancing the horizon state can lead to situations where the robot is stuck with the horizon state having moved beyond an obstacle in a way that makes to robot unable to arrive at a path that would not collide with the obstacle. More sophisticated logic on how to advance the horizon state would be needed in these infrequent situations to ensure more robustness. Finally it would be interesting to investigate the capabilities of the algorithm for factorgraphs with a a dynamic number of variables during the lifetime of the graph. I.e. having it dependant on the desired velocity. To accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, and contrary at a lower desired velocity, fewer variables could be sufficient and less computationally taxing in that case.

=== Extending to 3D with UAVs <s.fw.3d-uav>

// Extending the current algorithm to a three-dimensional context would allow broader applicability, particularly for quad-rotor UAVs. The state space in 3D is more complex, with 12 states instead of four. This increase would make the multivariate normal distribution messages exchanged during variable and factor iteration significantly larger and more computationally costly. The dynamic and obstacle factors, as well as the static environment representation, would need to be redesigned to replace the 2D SDF representation.

// #line(length: 100%, stroke: 1em + yellow)

Extending the current algorithm to a three-dimensional context would be interesting to explore to as it would extend applicability for use cases where quadrotor #acrpl("UAV") are deployed. With a state space comprized of 12 states@tahir2019state#footnote[Position $x,y,z$, linear velocity $dot(x), dot(y), dot(z)$, orientation $phi.alt, theta, psi$ and angular velocity $dot(phi.alt), dot(theta), dot(psi)$.] instead of four, the multivariate normal distribution messages exchanged during variable and factor iteration would be $7$ times larger in terms of bytes, and thereby a lot more costly in terms of both computation and network, which could limit the scalability in highly connected cases. Both the dynamic factor and obstable factor would have to be redesigned, with a new static environment representation to replace the #acr("SDF") representation used in 2D.

=== Advance Networking Simulation <s.fw.advance-networking-simulation>

// Current networking simulation is simplistic, with robots communicating within a certain radius and message exchanges occurring instantly without delay. Enhancements could include adding random delays to messages, modeling the transmission medium with a non-zero chance of noise, and analyzing the system's throughput and bandwidth usage. These improvements would help to better reflect real-world communication complexities and ensure the system does not overload available bandwidth.
//
//
// #line(length: 100%, stroke: 1em + yellow)

// Current networking simulation is simplistic, with robots being able to communicate as long as they are within a given radius of each other and their radio antenna is turned on. Exchange of messages happens instantly and without delay in simulated time. All of which poorly reflects the complexities present in wireless communication. Enhancements could include adding random delays to messages sent sampled from a stochastic distribution derived from empirical data on multi-robot short distance radio communication. And have the contents of messages be subject to noise through bit flips by modelling the transmission medium as channel with a non-zero chance of noise. With these improvements further analysis could be performed to try and estimate the throughput of the system, in terms of messages per second, and try and estimate how much bandwidth is used. To thoroughly arrive at bounds for how much external communication is possible, to not overload the available bandwidth for other core tasks needing communication access.

Current networking simulation is simplistic, with robots communicating within a given radius and external messages exchanged instantly without delay. This setup poorly reflects the complexities of real-world wireless communication. Enhancements could include adding random delays to messages, sampled from a stochastic distribution based on empirical data, and introducing noise through bit flips by modeling the transmission medium as a channel with a non-zero chance of noise. These improvements would allow further analysis to estimate system throughput and bandwidth usage, establishing bounds to prevent overloading the available bandwidth for other core tasks needing communication access.


=== Deployment & Interopability <s.fw.deployment-interopability>

Although work has been done to decouple the factor graph representation from the simulator, more is needed for distributed deployment. Each step of the algorithm loop,  as listed in @s.m.algorithm, needs to be decoupled from the Bevy framework, as its benefits are minimal outside a 3D rendered simulation with all entities running on the same host. Other challenges include host discoverability, managing persistent network connections between peers, and forwarding updated poses to hardware motor controllers. The #acr("ROS2") framework, with its robust #acr("QoS") middleware and client/server communication support, is a strong candidate for this. #acr("ROS2") application and libraries are primarily written in C++ and Python, due to having official library support. But it is possible to use other languages such as Rust by interfacing with the #acr("CFFI") based bindings through projects such as #source-link("https://github.com/ros2-rust/ros2_rust", "ros2_rust")@ros2_rust. Making integration feasible with the used technology stack. Using ROS2 would also allow leveraging high-quality packages available in its ecosystem and make it easier for other to make use of the work presented in this thesis and extend it.


// #line(length: 100%, stroke: 1em + yellow)

// Work has already been done to decouple the factor graph representation from the simulator. But more would be needed to deploy it in a distributed fashion. First each step of the algorithm loop, as listed in @s.m.algorithm, would need to decoupled from the Bevy framework, as its benefits are not substantial outside of a 3D rendered simulation with all entities running on the same host. Other challenges pertains to host discoverability, managing persistent network connections between peers and how to forward the updated pose to hardware motor controllers. The #acr("ROS2") framework would be an obvious consideration for this. Its robust #acr("QoS") middleware architecture to handle erroneous communication. Its support for client/server communication could be used for the message exchange between robots. While #acr("ROS2") application and libraries are primarily written in C++ and Python, due to having official library support. It is possible to use other languages such as Rust by interfacing with the #acr("CFFI") based bindings through projects such as #source-link("https://github.com/ros2-rust/ros2_rust", "ros2_rust")@ros2_rust. Another benefit of this is that it would be possible to make use of the wealth of high quality packages available in the ecosystem, and make it easier for other to make use of the work presented in this thesis and extend it.


// ------------------------------------------------------------------------------

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
