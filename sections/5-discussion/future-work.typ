#import "../../lib/mod.typ": *

== Future Work


=== Verify simulation results in a Real World setup

=== Use ray casting instead of sampling an SDF image of the environment

#kristoffer[
  Obstacle/SDF node will not work if the environment is not static.
]

- Use different behavior when communication is very bad. Either change the factor graph by adding
new nodes with different policies or a new algorithm all together e.g. the game theory paper we read at
the start.

- Extend to 3D world. e.g. can it work with UAVS/drone. What would have to change?
 - The state space is more complex. As a result the matrices being sent around are larger, and more computationally costly
 - What factors would have to change or be updated?
 - Have other already done something similar

 - Have the factorgraph be able to change the number of variable nodes during the lifetime of the graph. I.e. having it dependant on the desired velocity. If we want to accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, while if we do not move very fast, fewer variables could be sufficient and less computationally taxing in that case.

- Establish a simple network protocol to negotiate and establish the lifecycle of the bidirected connection between two robots.
  - How do two robots connect?
  - How do they communicate?
  - How do they check the connection is still alive?
  - How do they reconnect? Is it any different from just disconnecting and then reconnecting, or is it necessary to have some kind of stateful protocol? Should be avoided
  - How do they disconnect?

#kristoffer[Experiment with different graph representations, e.g. matrix, csr, map based etc. and test if they match theoretical performance profiles derived in the graph representation section]

#kristoffer[
  Try to make an estimate about the throughput of the system, in terms of messages per second, and try and estimate how much bandwidth is used.

  Based on the results, discuss what implications this would have for a real world system.
]

#kristoffer[
  Talk about our simulation as an extendable tool/system to easily test various modifications to using different factorgraph configurations, for robot path planning
  - Extendable
  - Maintainable ahh...
]

#kristoffer[
  Does it make sense to queue messages?, or is it enough to only work on the latest one?
]

#kristoffer[
  Extend the code to work with ROS2. Would probably work well with the pub/sub middleware
  architecture and the QoS system in ROS2. E.g. each robot exposes a sub over the network, that
  acts as a queue for incoming messages. The factorgraph will the use a pub to send messages to other known
  robots on their respective topics.

  Consequently, why did we not use ROS2 to begin with?
]

#kristoffer[
  Create a factor, that ensures that the position/velocity update is always given the kinematics model of the robot
]

#kristoffer[
  Shortly discuss our choice of using static dispatch for the different factors in the graph.
  For a more expendable design, it would be better to use dynamic dispatch i.e. `dyn Factor` so users of the library
  can use the public api without having to extend the `FactorKind` enum to add new factors, and recompile the library.
]

#kristoffer[
  Explore opportunities to create a mini dsl to declaratively create the graph.

  Maybe use the `dot` language to create a graph.
   - It is already a common language for expressing graphs declaratively.
   - The node kind i.e. variable or factor, and the kind of factor, can be specified in the node attributes.
   - A missing feature of this language is the inability to specify loops, often we want to repeat the same
     group of nodes multiple times which is not possible in the dot language.
   - Another approach is to embed a simple scripting language like `Lua`. That gets evaluated in a VM instance by the simulator, that then returns a table with a fixed schema.


  ```dot
  graph {
    v1 [variable];
    v2 [variable];
    f1 [factor:obstacle];
    f2 [factor:dynamic];
    v1 -- f1
    v1 -- f2
    v2 -- f2
  }
  ```
]


#kristoffer[A need for some kind of proxy node abstraction to handle nodes that are in a external graph, on an external host]


- Model sensing uncertainty to better bridge a move to real-scenario robotics


Merge with a #acr("VIO") SLAM solution, and to substitute for obstacle factors in unknown environments with mapping.
