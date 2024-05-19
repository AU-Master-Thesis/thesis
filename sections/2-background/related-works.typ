#import "../../lib/mod.typ": *
== Related Works <s.b.related-works>

#jonas[Not close to done. No need to spend time in this section.]

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

#k[
  Good words/sentences to use:
  - static/holonomic and dynamic/non-holonomically-constrained systems
  - Taxonomy of different approaches

  - Factorgraphs used for other areas of robotics such as
    - SLAM (Simultaneous Localization and Mapping)
    - SfM (Structure-from-Motion)
]


The field of multi-agent path planning has a rich literature, with numerous methods differing significantly based on their underlying taxonomies.

These approaches vary in assumptions about the environment and the holonomic constraints of the robots. A critical element in multi-robot systems, path planning exhibits large dichotomies, such as whether an algorithm is centralized, with a single decision-making entity, or decentralized. The guarantees offered by these algorithms also differ, addressing factors like travel time, distance, and feasible trajectories based on the robot's motion model. Additionally, robustness to dynamic environments and communication interference is crucial. The methods range from classical approaches to modern AI-driven techniques, including sampling-based, graph-based, and potential field methods. Key indicators of a good path planning algorithm include path length, computational speed, smoothness, energy cost, and safety. Furthermore, it's important to distinguish between path planning and trajectory planning, as the former focuses solely on finding an obstacle-free path without considering the temporal aspects of motion.


#let coordinator = box(circle(radius: 0.5em, fill: orange.lighten(50%), stroke: orange), outset: 0.25em)
#figure(
  std-block(
    image("../../figures/out/multi-robot-path-planning-classification.svg", width: 80%),
  ),
  caption: [Multi-robot path planning can at a high level be classified as: Centralized, Decentralized, Distributed. #box(circle(radius: 0.5em, fill: orange.lighten(50%), stroke: orange)),
  #coordinator
]
) <f.multi-robot-path-planning-classification>



#line(length: 100%, stroke: 10pt + theme.maroon)


Originally Murai _et al._ showed, with their _A Robot Web for Distributed Many-Device Localisation_, that #acr("GBP") can be utilised to solve multi-agent _localisation_. Then Patwardhan _et al._ showed that the same algorithm structure can be adapted to multi-agent _planning_. This thesis aims to extend the work by Patwardhan _et al._@gbpplanner to include a global planning layer, which can provide a more robust solution to the multi-agent planning in highly complex environments. As such @gbpplanner will be covered more thoroughly in its own dedicated section below, see @background-related-works-gbp-planner.

#todo[maybe the 'dedicated section' is simply the rest of the background which contains the relevant theory.]

#todo[Split the related works into a subsection for each important work.]


- A Robot Web for Distributed Many-Device Localisation

proposes the idea of modelling the communication scheme using for exchaning messages between robots similar to how hypermedia is exchanged on the world wide web using a protocol like HTTP

- Distributing Collaborative Multi-Robot Planning with Gaussian Belief Propagation

- A comprehensive review of the latest path planning developments for multirobot formation systems

- Handling Constrained Optimization in Factor Graphs for Autonomous Navigation

-  Factor Graphs: Exploiting Structure in Robotics


- ORCA

@orca


=== GBP Planner <background-related-works-gbp-planner>

=== ORCA <background-related-works-orca>

formulate the problem as _reciprocal n-body collision avoidance_


The paper presents a formal approach to reciprocal n-body collision avoidance for multiple mobile robots. The methodology hinges on the concept of velocity obstacles, which are used to derive sufficient conditions for collision-free motion. The core idea is to compute collision-free actions for each robot independently by solving a low-dimensional linear program. The authors introduce the Optimal Reciprocal Collision Avoidance (ORCA) algorithm, which optimizes each robot's velocity to avoid collisions while maintaining a preferred trajectory. The method assumes each robot can sense the positions and velocities of other robots, and does not rely on communication or central coordination.


- Linear problem to solve
- Robot entities does not communicate

- holonomic, can move in any direction in the plane, i.e. control input is simply given as a 2d vector


=== Handling Constrained Optimization in Factor Graphs for Autonomous Navigation <s.background-related-works.handling>

@bazzana_handling_2023


// Barbara Bazzana


=== #todo[Some approach using deep learning ...]
