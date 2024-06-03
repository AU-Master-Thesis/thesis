#import "../../lib/mod.typ": *
= Conclusion <conclusion>

// Hypothesis 1
// Reimplementing the original GBP Planner in a modern, ﬂexible multi-agent simulator
// framework using a modern programming language will enhance the software’s scien-
// tiﬁc communication and extendibility. This redevelopment will not only ensure ﬁdelity
// in reproducing established results but also improve user engagement and development
// through advanced tooling, thereby signiﬁcantly upgrading the usability and function-
// ality for multi-agent system simulations.

// Accompanying research questions:
// RQ-1.1 Which architecture and framework is suitable for such a task, and can it reproduce the original results? Specify which tasks it suitable for. Decoupling? Modelling? Visualisation?
// RQ-1.2 What kind of tooling will be most beneﬁcial for the software?
// RQ-1.3 How can tooling help with future reproducibility and engagement with the software?
// RQ-1.4 How can tooling help with understanding and extending the software?

// Produced an interactive simulation tool, that can work as a tool to more easierly explore the future algorithms and variations on using GBP as a method for distributed path planning.

// A valuable tool that can be used by others, e.g. companies to quickly assess if the gbpplanner algorithm is a suitable method for doing multi-agent distributed path planning given their requirements, such as density of robots, and environment structure.

// On hypothesis 1
The original GBP Planner has been reimplemented in a modern, flexible multi-agent simulator framework using a modern programming language. The chosen #acr("ECS") architecture in the Bevy Engine has proven itself to be a suitable framework both for reproducing the original `gbpplanner` and for extending it with a large amount of tooling. The result is a fully-fledged interactive simulation tool called #acr("MAGICS"). The tool is designed to enhance the scientific communication and extendibility by introducing a highly configurable #acr("UI"), with a lot of options for visualisation; providing many different perspective on the underlying theoretical concepts. The hope is that #acr("MAGICS") can provide a simple playground for the further development of multi-agent systems based off of #acr("GBP") at its core.

Furthermore, extensive though has been put into the configuration formats; the main configuration `config.toml` providing the initial tool state, while the `environment.yaml` provides a simplified way to design a plethora of environments, either by using the character matrix or placing obstacles manually; both in a highly declarative manner. Lastly, the `formation.yaml` once again provides a declarative interface, but this time for expressing the otherwise highly dynamic and sporatic nature of multi-agent formations. This is accomplished through a series of spawning rules that when put together can represent highly complex scenarios of interweaving robots. Not only do these three configuration formats provide a single source of truth, not dependant on the program state, but they also collectively make up the notion of a scenario, which is easily reproduced and shared between users of #acr("MAGICS").

// Hypothesis 2
// The original work can be enhanced through speciﬁc modiﬁcations without interfering
// with the original work’s functionality. Speciﬁcally, we introduce and rigorously test
// various GBP iteration schedules, and strategically enhance the system by advancing
// towards a more distributed approach. These targeted improvements are expected to op-
// timize ﬂexibility and move towards a closer-to-reality system.

// Accompanying research questions:
// RQ-2.1 Which possible ways can the GBP iteration scheduling be improved?
// RQ-2.2 How can such iteration schedules be tested, to ensure that they are an improvement?
// RQ-2.3 Which possible avenues exist to advance towards a more distributed approach?
// RQ-2.4 Are these targeted improvements able to enhance the original work without transforming it?

// On hypothesis 2
#k[hypothesis 2]

While expected a ...

Two additional experiments have been performed to test different parameters of the GBP algorithm not explored in the original work.

- Firstly the effect the number of internal and external iterations has on the converge of the algorithm and performance.

- Found that more internal iterations than external iterations is beneficial. when internal iterations is low. Generally that no more than 10 iterations of each is sufficient across a broader range of scenarios to achieve good results.

- A result that is promising for the potential to deploy on a broad range of robots with not a lot of compute power.

- Secondly the order in which new information is passed from interrobot factors between robots does not appear to be significant. With roughly the same results for all five schedules considered. Supporting the strong benefits of using GBP as an inference algorithm for multi agent path planning.  Although it is hard to state conclusively without real world test or a more advanced/sophisticated simulation of networking conditions.

- Simulating factorgraphs in a more distributed manner that maps more realisticly to the a real-scenario.

- use different graph structure and still reproduce/get similar results

#line(length: 100%, stroke: 1em + red)

// Hypothesis 3
// Extending the original GBP Planner software with a global planning layer will extend
// the actors’ capability to move in complex environments, without degradation to the re-
// produced local cooperative collision avoidance, while maintaining a competitive level
// of performance. Furthermore, to this end, a new type of factor can be added to the GBP
// factor graphs to aid in path-following.

// Accompanying research questions:
// RQ-3.1 Will global planning improve the actors' capability to move autonomously in complex environments?
// RQ-3.2 Will global planning degrade the existing local cooperative collision avoidance?
// RQ-3.3 What impact will the global planning layer have on performance?
// RQ-3.4 Is it possible to introduce a new type of factor that can aid in path-following?
// RQ-3.5 What impact will this factor have on the existing behaviour of the actors, importantly; will it degrade their ability to collaborate and avoid collisions - both with each other and the environment?
// RQ-3.6 What will the impact of this factor be on the actors' capability to move in complex environments?

// On hypothesis 3
The agents have received the ability to perform individual pathfinding by using an #acr("RRT*") algorithm. This path-finding element has been embedded into the concept of a _robot mission_, which keeps track of the mission state and when to call the asynchronous global path-finder. The global planning element in itself does not degrade the local cooperative collision avoidance. This is due to the fact that the waypoint tracking approach is simply an automated way of placing the waypoints that were placed manually before. The downside of the implemented solution is the random nature of the #acr("RRT*") algorithm, which causes an inoptimal amount of crossing paths. Oppositely, when manually placing waypoints, the waypoints can be placed in a risk-averse way; decreasing the amount of crosses.

This problem is excaserbated by the introduction of the tracking factor, which pulls the actors towards the planned paths. And when these paths have no concern for the paths of other actors, the tracking factor makes it very difficult for the interrobot factors to push hard enough to avoid collisions. If the path tracking approach with the tracking factors is desired, this is the main problem to solve. Even with an attempt to balance the tracking and interrobot factors to the point where the tracking factor has little impact of the path deviation error, the amount of collisions is still worse than that of the waypoint tracking approach without tracking factors alltogether.

One thing that becoms easier for the actors is the avoidance of static obstacles in the environment. As the global path-finder already takes care of only planning paths that are collision free, the actors can simply follow the planned paths without having to worry about the environment in any major way. Due to this, it can be concluded that the waypoint tracking approach is highly superior, as it lets the actors avoid each other much more effectively while still being able to use their obstacle factors to avoid static obstacles even when deviating from their otherwise collision-free paths.
