#import "../../lib.typ": *
= Introduction <introduction>

== Motivation <intro-motivation>
#todo[A lot of this is probably in the original contract.]

// From the original contract:
// 1. Motivation
// Automation is constantly increasing, and multi-agent systems are proportionally relevant. Many current-day systems, such as the agriculture industry[1], along with many other fields, are on a trajectory toward autonomous multi-agent robotics. This trend can also be projected onto more mainstream everyday tasks, such as manual transportation. The adoption of autonomous vehicles is increasing, and the technology is becoming more and more mature. As the fraction of autonomous vehicles increases, the possibilities for efficient traffic expand exponentially with the ability to coordinate and communicate between vehicles. For such systems to reach their full potential, it is preferred to move at high speeds and ensure deadlocks are avoided. This is especially relevant in scenarios where the room for movement is limited, this could be an indoor environment or roads with specific boundaries. Overall, putting effort towards the development of the multi-agent field will help enable many current and future systems to do more in less time, and with fewer resources.

// Step 1: Explain the broad scale of the motivation
Harnessing the power of automation has been a key driver for the long term development of human manufacturing and quality of life in the modern world since the industrial revolution#todo[cite]. Along with an increase in automation comes more playroom#todo[wording] for autonomous systems of higher complexity. Many current-day systems, such as the agriculture industry@wisse_wp1_2020 are on a trajectory toward autonomous multi-agent robotics. This trend can also be projected onto more mainstream everyday tasks, such as manual transportation. The adoption of autonomous vehicles is increasing, and the technology is becoming more and more mature. As the fraction of autonomous vehicles increases, the possibilities for efficient traffic expand exponentially with the ability to coordinate and communicate between vehicles. For such systems to reach their full potential, it is preferred to move at high speeds and ensure deadlocks are avoided. This is especially relevant in scenarios where the room for movement is limited, this could be an indoor environment or roads with specific boundaries. Overall, putting effort towards the development of the multi-agent field will help enable many current and future systems to do more in less time, and with fewer resources.

// Step 2: Explain how the broad scale applies to the specific motivation of multi-agent systems
With this development, the possibility and thus also demand for multi-agent systems have become much more prevalent. This is especially impacting the field of robotics, where separate agents can work together to achieve a common goal, or even work together to achieve separate goals as efficiently as possible.

// Step 3: Connect that to the specific problem of path planning, collaboration, communication, and collision avoidance
In the context of multi-agent systems, path planning is a key component. It is a process of optimization to find the most efficient path for an agent to reach its goal. This is especially important in the context of multi-agent systems, where multiple agents need to coordinate their movements to avoid collisions and reach their goals as efficiently as possible. This requires a high level of collaboration and communication between the agents, as well as a high level of collision avoidance to ensure that the agents do not collide with each other or with obstacles.

== Problem Definition <intro-problem-definition>
#todo[A lot of this is probably in the original contract.]

// From the original contract:
// 2. Problem Definition & Objectives
// Efficient and safe approaches to multi-agent planning have been studied extensively, with many different approaches and assumptions about the environment and capabilities of the robotic agents. However, none of the existing approaches attempt to be able to operate in changing communication conditions, in a decentralized manner. Morteza[2], 2021, implements a modified A* algorithm that can handle dynamic obstacles in the environment. They also propose an architecture where the path planning optimization is done in a centralized manner on a cloud server. This reduces the number of messages sent between the agents but introduces a single point of failure. Xinjie[3], 2023, uses a game-theoretic approach to do path planning. Here agents cannot communicate with each other and instead have to predict how other agents will move based on the rules that govern the movement of the agents. Similar to how humans navigate in vehicle traffic, where the driver's own assumption/belief about how other drivers will follow the traffic law, is used to predict how other vehicles will move. Aalok[4], 2023, uses Gaussian Belief Propagation to do path planning for multiple agents. It is a decentralized approach using a data structure called a factor graph to model uncertainties about the position and velocity of other agents.

// The objective of this project is to build on top of the work of [4], and extend it to handle cases with limited communication possibilities, challenging environments, and non-holonomic kinematic constraints. The environment will be a static indoor environment at a logistics facility where robots are integrated into a baggage sorting handling system. Instead of extending the original paper's source code, we will reimplement our version of the Gaussian Belief Propagation Planner algorithm from scratch. The intention of the rewrite is not only to try and improve performance but also to get a better understanding of the algorithm, to make it easier to extend it. The implemented solution will be tested in a simulated environment, with common scenarios found at logistic facilities, such as three-way junctions and intersections.

Efficient and safe approaches to multi-agent planning have been studied extensively, with many different approaches and assumptions about the environment and capabilities of the robotic agents. However, none of the existing approaches attempt to be able to operate in changing communication conditions, in a decentralized manner. Morteza@kiadi_synthesized_2021, 2021, implements a modified A\* algorithm that can handle dynamic obstacles in the environment. They also propose an architecture where the path planning optimization is done in a centralized manner on a cloud server. This reduces the number of messages sent between the agents but introduces a single point of failure. Xinjie@liu_learning_2023, 2023, uses a game-theoretic approach to do path planning. Here agents cannot communicate with each other and instead have to predict how other agents will move based on the rules that govern the movement of the agents. Similar to how humans navigate in vehicle traffic, where the driver's own assumption/belief about how other drivers will follow the traffic law, is used to predict how other vehicles will move. Aalok@patwardhan_distributing_2023, 2023, uses Gaussian Belief Propagation to do path planning for multiple agents. It is a decentralized approach using a data structure called a factor graph to model uncertainties about the position and velocity of other agents.

The objective of this project is to build on top of the work of @patwardhan_distributing_2023, and extend it to handle cases with limited communication possibilities, challenging environments, and non-holonomic kinematic constraints. The environment will be a static indoor environment at a logistics facility where robots are integrated into a baggage sorting handling system. Instead of extending the original paper's source code, we will reimplement our version of the Gaussian Belief Propagation Planner algorithm from scratch. The intention of the rewrite is not only to try and improve performance but also to get a better understanding of the algorithm, to make it easier to extend it. The implemented solution will be tested in a simulated environment, with common scenarios found at logistic facilities, such as three-way junctions and intersections.

#todo[Motivations for why our project is interesting]

- What makes multi robot systems, better/more interesting than single robot systems?
- What challenges does it bring with it?



#todo[formulate a strong and clear definition of what path planning is, and ensure it is consistent with the rest of the document]


#kristoffer[
 Enumerate what makes the Gaussian Belief Propagation algorithm attractive.
]

- Peer to Peer based
- No need to synchronize the ordering of messages in time
- Modular. New factors can be added to the factor graph to encode different constraints.

== Research Hypothesis <intro-research-hypothesis>
This thesis poses the following hypothesis:

// #todo[Maybe this should multiple hypothesis, or maybe it should be more specific or rephrased.]

#set enum(numbering: req-enum.with(prefix: "H-"))
+ Reproducing the results of the original GBP Planner in a new programming language will improve the software's scientific communication and its extensibility.

+ Extending the original GBP Planner software with a global planning layer will extend the actors' capability to move in complex environments, without degradation to the reproduced local cooperative collision avoidance, while maintaining a competitive level of performance#note.layout[How to measure, frame time, fps].

From this point on, anything pertaining to the context of #H(1) will be #study.H-1, and anything pertaining to the context of #H(2) will be #study.H-2.


== Research Questions <intro-research-questions>

// === Study 1
#study.H-1: Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-1", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-1.", color: theme.teal))
+ Which programming language will be optimal for scientific communication and extensibility?
+ Is it possible to reproduce the results of the original GBP Planner in the chosen programming language?

// === Study 2
#study.H-2: Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-2", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-2.", color: theme.teal))
+ Will global planning improve the actors' capability to move in complex environments?
+ Will global planning degrade the reproduced local cooperative collision avoidance?
+ Will the global planning maintain a competitive level of performance?

// #todo[1 hypothesis to many research question]

== Research Objectives <intro-research-objectives>
// #todo[1 research question to many research objectives]

// #let o-num() = req-enum.with(color: accent)
#study.H-1: Objectives for research question #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.1", weight: 900):
#set enum(numbering: req-enum.with(prefix: "O-1.1.", color: theme.green))
+ Evaluate possible programming languages on several metrics for scientific communication and extensibility. #todo[rephrase, or mention different metrics.] #note.layout([Learn by reproducing])

#study.H-1: Objectives for research question #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.2", weight: 900):
#set enum(numbering: req-enum.with(prefix: "O-1.2.", color: theme.green))
+ Reimplement the original GBP Planner in the chosen programming language.
+ Evaluate whether the reimplementation is faithful to the original GBP Planner by comparing the four metrics: distance travelled, makespan, smoothness, and collision count.

#study.H-2: Objectives for research question #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.1", weight: 900):
#set enum(numbering: req-enum.with(prefix: "O-2.1.", color: theme.green))
+ Implement a global planning layer in the reimplemented GBP Planner.
+ Evaluate the actors' capability to move in complex environments by looking at the four metrics: distance travelled, makespan, smoothness, and collision count, comparing against the reimplemented reproduction and the original GBP Planner.

#study.H-2: Objectives for research question #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.2", weight: 900):
#set enum(numbering: req-enum.with(prefix: "O-2.2.", color: theme.green))
+ Compare the four metrics: distance travelled, makespan, smoothness, and collision count of the reimplemented reproduction with and without the global planning layer.

#study.H-2: Objectives for research question #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.3", weight: 900):
#set enum(numbering: req-enum.with(prefix: "O-2.3.", color: theme.green))
+ Compare performance metrics of the reimplemented reproduction with and without the global planning layer against the original GBP Planner.

#todo[Part of the argument for H-2: Furthermore, a language with that shares qualities#kristoffer[wording] with modelling languages will improve the software's ability to communicate scientific results.]
#todo[argument for rust: Half way a modelling language, which is optimal for scientific communication and extensibility.]
