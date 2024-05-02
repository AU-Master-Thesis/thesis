#import "../../lib.typ": *
== Related Works <s.b.related-works>

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
Originally Murai _et al._ showed, with their _A Robot Web for Distributed Many-Device Localisation_, that #acr("GBP") can be utilised to solve multi-agent _localisation_. Then Patwardhan _et al._ showed that the same algorithm structure can be adapted to multi-agent _planning_. This thesis aims to extend the work by Patwardhan _et al._@gbpplanner to include a global planning layer, which can provide a more robust solution to the multi-agent planning in highly complex environments. As such @gbpplanner will be covered more thoroughly in its own dedicated section below, see @background-related-works-gbp-planner.

#todo[maybe the 'dedicated section' is simply the rest of the background which contains the relevant theory.]

=== GBP Planner <background-related-works-gbp-planner>
