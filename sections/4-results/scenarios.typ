#import "../../lib/mod.typ": *
== Scenarios <s.r.scenarios>

// #jonas[Read this, and all subsections]
The performance of the reimplementation is evaluated across #numbers.written(scen.len()) different scenarios. The scenarios adhere to the original paper's@gbpplanner experiments, and are described in the following listing
// #jonas[fixed the boldness overload here]

#set enum(numbering: box-enum.with(prefix: "S-"))
+ _*Circle:*_ The environment of this scenario is empty. Robots are placed along the perimeter of a circle centered at the origin with radius $r$. Every robot is tasked with reaching the opposite side of the circle.



+ _*Environment Obstacles:*_ This scenario is similar to the Circle scenario, but with obstacles near the center of the circle. // Again robots are placed in a circle, centered at $(0, 0)$ with $r=50m$, and are tasked with reaching the opposite side of the circle.

+ _*Varying Network Connectivity:*_ Identical environment to the Environment Obstacles scenario, but with larger spawning radius. The radius of the robots communication range varied.

+ _*Junction:*_ This environment is much more constrained, only with two roads; a vertical and horizontal one, centered in their cross-axis. Thus creating a simple crossroads at the very center of the environment. Robots are spawned repeatedly in two formations. One group begins on the left side with instructions to cross to the right, while the other starts at the top, with a mission to reach the bottom.

+ _*Communications Failure:*_ This scenario is based in the same environment as the Circle scenario. It tests how resilient the #acrpl("GBP") algorithm is to spurious loss of communication between robots. By randomly toggling a robots ability to communicate with others at different probabilities every timestep.


// + _*Communications Failure:*_ This scenario is based in the same environment as the Circle scenario. In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.

// In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.


Specific details and parameters for each scenario are presented in the following sections #numref(<s.r.scenarios.circle>)-#numref(<s.r.scenarios.communications-failure>). Parameters are selected to be identical to whats presented in @gbpplanner. The numerical value of a few parameters in some of the scenarios are not listed explicitly. In these cases an argument for the selected interpretation is presented to justify the values chosen. An asterisk is used as a postfix for the values for which this applies, e.g. $x^*$. A lot of the values are the same between scenarios. To make the differences stand out, each value that is different from its value in the Circle scenario is colored #text(theme.red, [red]). Parameters related to the #acr("GBP") algorithm are explained in detail in @s.m.study-2. New parameters not explained previously are:

#term-table(
  [$bold(C_("radius"))$], [The radius of the circle that the robots are spawned in. Omitted in the Junction scenario, as it is not applicable.],
  [$bold(s e e d)$], [
    The seed used for the #acr("PRNG"). Randomness is used in one place throughout the different scenarios. For randomly selecting a robots radius $r_R$ in the scenarios using a circle formation. In the work of @gbpplanner, the Mersenne Twister pseudorandom number generator from the C++ standard library is used. In the reimplementation the WyRand algorithm is used as it was more easily available through@bevy_prng. This of course introduces a slight potential for deviation between results. Nevertheless this is deemed acceptable given that the randomness does not have a large affect on the #acr("GBP") algorithm. And secondly the seeds used for the tested scenarios is not listed explicitly in @gbpplanner. To make the results more robust each scenario is executed five times each with a different seed. Note in @gbpplanner this approach is only used for the _Communication Failure Experiment_. The seeds chosen are:

    $ #equation.as-set(params.seeds) $
  ]
)

They have been chosen such that all seeds have a minimum Hamming Distance of $5$, to ensure a moderate amount of entropy@review-of-methodologies-and-metrics-for-assessing-the-quality-of-random-number-generators. For a full summary of all experimental parameters used in the reproduction experiments see @appendix.reproduction-experiment-parameters. Additionally, environment visualisations are provided in figures #numref(<f.scenarios.circle>), #numref(<f.scenarios.environment-obstacles>), and #numref(<f.scenarios.junction>).


#show quote: emph
=== #scen.circle.n <s.r.scenarios.circle>
// EXCEPT from their paper
// Robots of various sizes are initialised in a circle formation of radius 50 m, with an initial speed of 15 m/s, towards a stationary horizon state at the opposite side of the circle. The radii of the robots are sampled randomly from rR ∼ U (2, 3) m. We set tK−1 as the ideal time taken for a single robot moving from the initial speed to rest across the circle at constant acceleration. This would correspond to a smooth (zero jerk) trajectory. Each robot has a communication range rC = 50 m representing a partially connected network of robots. In addition, we set σd = 1 m.
This scenario is the basis for all the other scenarios expect for the Junction scenario. Robots are placed in a circle of radius $C_("radius") =50m$ and are tasked to reach the opposite side of the circle. e.g. If a robot is placed at an arc length of $theta$, then it has to reach the point at arc length $theta + pi$ of the circle, also known as its _antipodal point_. The challenge of this scenario is that the optimal path for each robot all intersect each other at the same point, at the same time. To handle this case the robots will have to collaboratively arrive at a solution that accomedate all of them. All parameters are listed in @t.scenarios.circle. To make the layout of each table more compact they have been grouped into three categories; _Environment_, _GBP Algorithm_ and _Factor Settings_. Robot radiis are sampled randomly from a uniform distribution over the interval $[2.0, 3.0] m$. For the time horizon $t_(K-1)$ no numerical value is explicitly stated. Instead the following sentence is used to explain its value: #quote[towards a stationary horizon state at the opposite side of the circle ... We set $t_(K-1)$ as the ideal time taken for a single robot moving from the initial speed to rest across the circle at constant acceleration. This would correspond to a smooth (zero jerk) trajectory@gbpplanner]. This statement is interpreted as follows. For a robot to move across the circle it has to traverse $2C_("radius") = 100m$. With initial speed $|v_0| = 15 m"/"s$ and final speed $|v_("final")| = 0 m"/"s$ the time taken to traverse at constant acceleration can be computed using the kinematic equations for velocity and displacement@essential-university-physics. Doing this one get $t_(K-1) = 13 + 1/3 s$. See @appendix.interpretation-of-parameters for the derivation. The value of the _seed_ parameter is not stated either. A value of 2 was selected such that it matches the `"SEED":` key in the simulation config found in the papers code #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/config/circle_cluttered.json#L14", "config/circle_cluttered.json:14")
@gbpplanner-code. Note that the parameters in the #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/config/circle_cluttered.json", "config/circle_cluttered.json") and `config/*.json` does not match any of the experimental scenarios listed in @gbpplanner #todo[ref to discussion about mismatch between code and paper experiments].


#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.circle.env, title: [Environment]),
    params.tabular(params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.circle.factor, title: [Factor Settings]),
  ),
  caption: [Circle scenario parameters.],
)<t.scenarios.circle>


#figure(
  // image("../../../figures/out/circle.svg", width: 30%),
  // std-block(todo[Add image]),
  // std-block(image("../../figures/img/circle-scenario-preview-1.png")),
  std-block(image("../../figures/img/circle-scenario-preview-2.png")),
  // std-block(image("../../figures/img/circle-scenario-preview-3.png")),
  caption: [
  Screenshot of the circle environment with $N_R = 20$. The lines with low opacity represent the trajectory that each robot has to follow.

  // with $Q_("in") = 6$. The green #sg edges represent the the joint factorgraph.
],
)<f.scenarios.circle>

=== #scen.environment-obstacles.n <s.r.scenarios.environment-obstacles>

// EXCEPT from their paper
// Environment obstacles: Also shown in figure 6 with dotted lines are the makespans for ORCA and our GBP planner when 6 polygonal obstacles are placed in the middle of the circle. The paths can be seen in figure 3. The results are for one layout of obstacles averaged over 5 seeds. For NR = 25 and 30 some robots using ORCA became deadlocked with the obstacle configuration. Our method performs well with obstacles, producing makespans that are only slightly higher than in those in free space
In this scenario the robots are placed in a circle similar to the Circle scenario, see @s.r.scenarios.circle. The environment is sparsely populated with six small obstacles; two triangles, three squares and one rectangle. The obstacles are placed near the middle of the environment. This change adds to the difficultly. Not only does the robots have to find collision free paths around each other. They also have to adjust their solution to not collide with the obstacles that obstruct the optimal path straight across the interior of the circle.


#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.clear-circle.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.clear-circle.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.clear-circle.factor, previous: params.circle.factor, title: [Factor Settings]),
  ),
  caption: [Environment Obstacles scenario parameters.],
)<t.scenarios.environment-obstacles>

#figure(
  // image("../../../figures/out/clear-circle.svg", width: 30%),
  // std-block(todo[Add image]),
  std-block(image("../../figures/img/environment-obstacles-scenario-preview.png")),
  caption: [Visualisation Environment Obstacles scenario. The red #sr outline of each obstacle is boundary of the collider volume used to check for environment collisions.]
)<f.scenarios.environment-obstacles>


=== #scen.varying-network-connectivity.n <s.r.scenarios.varying-network-connectivity>

// EXCEPT from their paper
// Varying network connectivity: Robots within a communication range rC of each other form a partially connected network, and can collaboratively modify their planned paths. We investigate the effect of varying rC for NR = 30 for the 100 m diameter circle formation with obstacles. Table I shows that as rC increases robots take more of their neighbours into account, resulting in greater makespans but small changes in the distances travelled and path smoothness. This highlights the applicability of our method to real networks where sensing and communication range may be limited.


This scenario uses the same environment as the Environment Obstacles scenario, see @s.r.scenarios.environment-obstacles. Now each robots communication range $r_C$ is varied from $20m$ up to $80m$ at $20m$ intervals. The purpore of this scenario is to check what affect connectivity between factorgraphs has on the robots capability to plan collaboratively. When $r_C$ is small it is more likely that robots have few connected neighbours, resulting in multiple smaller disjoint subclusters. When $r_C$ grows larger the connectivity of the overall network will grow as disjoint subclusters are merged into larger connected ones.

// As $r_C$
// Robots within a communication range $r_C$ of each other form a partially connected network. By varying $r_C$ most

// As more robots are connected with each other the more information about each others uncertainty is available during the variable optimisation step. As a result each robot should arrive

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.varying-network-connectivity.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.varying-network-connectivity.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.varying-network-connectivity.factor, previous: params.circle.factor, title: [Factor Settings]),
  ),
  caption: [Junction scenario parameters.],
)<t.scenarios.junction>

=== #scen.junction.n <s.r.scenarios.junction>

Robots working in crowded environments may need to operate at high speeds with high levels of coordination, such as when traversing junctions between shelves in a warehouse. This scenario simulates one such junction with channel widths of 16 meters and robots moving at 15 $m "/" s$. $t_(K-1) = 2s$ to force the robots to have a short horizon to plan a path within when they reach the junction center. In addition $sigma_d =0.5m$. An explanation for why this parameter is changed from $1m$ is not given. Its presumed here that it is done to have the dynamic factors have a larger influence to better react when robots are crossing each other perpendicularly in the junction.
A desirable trait of multirobot systems is to maintain a high flow rate without causing blockages at junctions. To test this the the rate $Q_("in")$ at which robots enter the central section of the junction is adjusted, and the rate $Q_("out")$ at which they exit is measured. To measure flow, the central section is observed over 500 timesteps to represent steady-state behavior. Robots must exit the junction in the same direction they entered, without collisions. $Q_("in")$ is adjusted over the list of values

$ Q_("in") in [0.5, 1, ..., 6] $

// - $Q_("in")$ vary $"robots" "/" s$
// - $Q_("out")$ measure $"robots" "/" s$
// - $Q_("in")$ should equal $Q_("out")$


#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.junction.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.junction.gbp, previous: params.circle.gbp,  title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.junction.factor, previous: params.circle.factor, title: [Factor Settings]),
  ),
  caption: [Junction scenario parameters.],
)<t.scenarios.junction>

#figure(
  // image("../../../figures/out/junction.svg", width: 30%),
  // std-block(todo[Add image]),
  std-block(image("../../figures/img/junction-experiment-preview.png")),
  caption: [
  Screenshot of the junction scenario with $Q_("in") = 6$. The green #sg edges represent the the joint factorgraph.
],
)<f.scenarios.junction>

=== #scen.communications-failure.n <s.r.scenarios.communications-failure>


// EXCEPT from their paper
// Our GBP planner relies on per-timestep peer-to-peer communication between robots. It is assumed that each robot follows a protocol similar to [11]; it always broadcasts its state information. We consider a communications failure scenario where a robot is not able to receive messages from robots it is connected to. We would expect more cautious behaviour when planning a trajectory. We simulate a communication failure fraction γ: at each timestep the robot cannot receive any messages from a randomly sampled proportion γ of its connected neighbours. We repeat the circle experiment with 21 robots at two different initial speeds of 10 m/s and 15 m/s, measuring the makespan. The reported result is an average over 5 different random seeds. To be fair, at any timestep for any robot, the failed communications are exactly the same given a fixed seed for both initial velocities considered.

This scenario uses the same environment as the Environment Obstacles scenario (see @s.r.scenarios.environment-obstacles). The purpose of this scenario is to test the planning algorithm's performance under sub-optimal external communication conditions. In real-world situations, this could be caused by phenomena such as packet loss due to congestion in the radio frequency band or high interference from other electrical equipment transmitting messages. Under these conditions, the expected behavior is for the planning algorithm to exhibit increased caution when determining a trajectory. #note.k[should probably be in the dedicated section about interrobot factor] To simulate this the same non-zero probability $gamma$ is assigned to each robot. At every simulated timestep a robots ability to communicate with other factorgraphs through any established interrobot factors are toggled with probability $gamma$. For two robots $A$ and $B$ with variable $v_n^A$ and $v_n^B$, connected by interrobot factors $f_(r_n)^A (v_n^A, v_n^B)$ and $f_(r_n)^B (v_n^A, v_n^B)$. There are four possible states the system can be in.
+ The communication medium of both $A$ and $B$ are active allowing the factors and variable to exchange messages between each other during external message passing.
+ The communication medium of both $A$ and $B$ are inactive, preventing the factors and variable from exchanging messages.
+ The communication medium of $A$ is active, preventing $B$ from exchanging messages with $A$ during external message passing.
+ The communication medium of $B$ is active, preventing $A$ from exchanging messages with $B$ during external message passing.

The scenario is tested with 21 robots at two different initial speeds of 10 m/s and 15 m/s.

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.communications-failure.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.communications-failure.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.communications-failure.factor, previous: params.circle.factor, title: [Factor Settings]),
  )
  , caption: [Communications Failure scenario parameters.],
) <t.scenarios.communications-failure>
