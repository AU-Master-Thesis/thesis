#import "../../lib/mod.typ": *

#pagebreak()

== Future Work

#jonas[If you have time you can quickly skim over these notes, and let us know which seem most relevant, and which make no sense?]

The following sections outline the most important next steps in order to further the work presented by this thesis. The suggestions are based on the idea of what the authors see as the most promising directions for future research, and what would be most beneficial for the field of multi-robot path planning; see sections #todo[refer to sections here]. Additionally, some future work in terms of the implementation of the #acr("MAGICS") tool is also discussed, see sections #todo[refer to sections here].

=== Algorithm

A limitation of the current approach to estimate obstacles in the environment is that it is assumed to be static, with no moving entities that the robot cannot communicate with to estimate its state. And that a #acr("SDF") representation of the entire environment is known before hand. This works in environments such as logistic facilities, but fails in scenarios where the environment is partially or fully unknown. A key limitation for more broader applicability in other potential application domains. Some existing work on #acr("VIO") #acr("SLAM") uses factorgraphs as the optimization methodology. A joint

- This raises the question of how obstacle factors associated with future variable nodes can be estimated, when the camera cannot sample images into the future.

#line(length: 100%, stroke: 1em + red)

- Model sensing uncertainty to better bridge a move to real-scenario robotics
- Merge with a #acr("VIO") SLAM solution, and to substitute for obstacle factors in unknown environments with mapping.
  // - Use ray casting instead of sampling an SDF image of the environment
    // - Obstacle/SDF node will not work if the environment is not static.

- Explore design of a modified dynamics factor that work with robots subjected to holonomic constraints. As is the case for unicycle robots

- Use different behavior when communication is very bad. Either change the factor graph by adding new nodes with different policies or a new algorithm all together e.g. the game theory paper we read at the start.

- Do not move the horizon state irrespective of the current state. If The robot has trouble finding a trajectory, and is moving very little our findings shows, that blindly advancing the horizon state can lead


=== New Environments

#line(length: 100%, stroke: 1em + red)

- Extend to 3D world. e.g. can it work with UAVS/drone. What would have to change?
 - The state space is more complex. As a result the matrices being sent around are larger, and more computationally costly
 - What factors would have to change or be updated?
 - Have other already done something similar



- Verify simulation results in a Real World setup
  - other sim-to-real considerations?

=== Simulation

#line(length: 100%, stroke: 1em + red)

- More sophisticated network modelleling

- Try to make an estimate about the throughput of the system, in terms of messages per second, and try and estimate how much bandwidth is used. Based on the results, discuss what implications this would have for a real world system. There are some assumptions and corresponding limitations in the current implementation, which will be improved in future work. Firstly, we assumed that communication between robots was achieved instantly without delay



=== Deployment

#line(length: 100%, stroke: 1em + red)

- have the code work irespective of bevy, not depend on

 - Have the factorgraph be able to change the number of variable nodes during the lifetime of the graph. I.e. having it dependant on the desired velocity. If we want to accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, while if we do not move very fast, fewer variables could be sufficient and less computationally taxing in that case.

- Extend the code to work with ROS2. Would probably work well with the pub/sub middleware
  architecture and the QoS system in ROS2. E.g. each robot exposes a sub over the network, that
  acts as a queue for incoming messages. The factorgraph will the use a pub to send messages to other known robots on their respective topics.
  - Consequently, why did we not use ROS2 to begin with?

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
