#import "../../lib/mod.typ": *

== Problem Definition <intro-problem-definition>
#jonas[No difference from last here. A lot of this is copied directly from the original contract, and thus not relevant anymore. You don't have to spend time on this section.]

// From the original contract:
// 2. Problem Definition & Objectives
// Efficient and safe approaches to multi-agent planning have been studied extensively, with many different approaches and assumptions about the environment and capabilities of the robotic agents. However, none of the existing approaches attempt to be able to operate in changing communication conditions, in a decentralized manner. Morteza[2], 2021, implements a modified A* algorithm that can handle dynamic obstacles in the environment. They also propose an architecture where the path planning optimization is done in a centralized manner on a cloud server. This reduces the number of messages sent between the agents but introduces a single point of failure. Xinjie[3], 2023, uses a game-theoretic approach to do path planning. Here agents cannot communicate with each other and instead have to predict how other agents will move based on the rules that govern the movement of the agents. Similar to how humans navigate in vehicle traffic, where the driver's own assumption/belief about how other drivers will follow the traffic law, is used to predict how other vehicles will move. Aalok[4], 2023, uses Gaussian Belief Propagation to do path planning for multiple agents. It is a decentralized approach using a data structure called a factor graph to model uncertainties about the position and velocity of other agents.

// The objective of this project is to build on top of the work of [4], and extend it to handle cases with limited communication possibilities, challenging environments, and non-holonomic kinematic constraints. The environment will be a static indoor environment at a logistics facility where robots are integrated into a baggage sorting handling system. Instead of extending the original paper's source code, we will reimplement our version of the Gaussian Belief Propagation Planner algorithm from scratch. The intention of the rewrite is not only to try and improve performance but also to get a better understanding of the algorithm, to make it easier to extend it. The implemented solution will be tested in a simulated environment, with common scenarios found at logistic facilities, such as three-way junctions and intersections.

Efficient and safe approaches to multi-agent planning have been studied extensively, with many different approaches and assumptions about the environment and capabilities of the robotic agents. However, none of the existing approaches attempt to be able to operate in changing communication conditions, in a decentralized manner. Morteza@kiadi_synthesized_2021, 2021, implements a modified A\* algorithm that can handle dynamic obstacles in the environment. They also propose an architecture where the path planning optimization is done in a centralized manner on a cloud server. This reduces the number of messages sent between the agents but introduces a single point of failure. Xinjie@liu_learning_2023, 2023, uses a game-theoretic approach to do path planning. Here agents cannot communicate with each other and instead have to predict how other agents will move based on the rules that govern the movement of the agents. Similar to how humans navigate in vehicle traffic, where the driver's own assumption/belief about how other drivers will follow the traffic law, is used to predict how other vehicles will move. Aalok@patwardhan_distributing_2023, 2023, uses Gaussian Belief Propagation to do path planning for multiple agents. It is a decentralized approach using a data structure called a factor graph to model uncertainties about the position and velocity of other agents.

The objective of this project is to build on top of the work of @patwardhan_distributing_2023, and extend it to handle cases with limited communication possibilities#note.k[ehh...], challenging environments, and non-holonomic kinematic constraints#note.k[ehh...]. The environment will be a static indoor environment at a logistics facility where robots are integrated into a baggage sorting handling system. Instead of extending the original paper's source code, we will reimplement our version of the Gaussian Belief Propagation Planner algorithm from scratch. The intention of the rewrite is not only to try and improve performance but also to get a better understanding of the algorithm, to make it easier to extend it. The implemented solution will be tested in a simulated environment, with common scenarios found at logistic facilities, such as three-way junctions and intersections.

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