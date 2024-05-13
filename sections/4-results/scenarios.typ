#import "../../lib/mod.typ": *
== Scenarios <s.r.scenarios>

The performance of the reimplementation is evaluated across #numbers.written(scen.len()) different scenarios;
#scen.circle.s, #scen.clear-circle.s, #scen.varying-network-connectivity.s, #scen.junction.s and #scen.communications-failure.s. These scenarios adhere to the original paper's@gbpplanner experiments.

#set enum(numbering: box-enum.with(prefix: "S-"))
+ _*Circle:*_ This environment is sparsely populated with six small obstacles; two triangles, three squares and one rectangle. The obstacles are placed in the middle of the environment. Robots are placed along the perimeter of a circle centered at $(0, 0)$ with a radius of $r=50m$. Every robot is tasked with reaching the opposite side of the circle.

+ _*Clear Circle:*_ This environment is similar to the Circle scenario, but without any obstacles. Again robots are placed in a circle, centered at $(0, 0)$ with $r=50m$, and are tasked with reaching the opposite side of the circle.

+ _*Varying Network Connectivity:*_ Identical environment to the Circle scenario, but with the radius of the robots communication range varied.

+ _*Junction:*_ This environment is much more constrained, only with two roads; a vertical and horizontal one, centered in their cross-axis. Thus creating a simple crossroads the very center of the environment. Robots are spawned repeatedly in two formations. One group begins on the left side with instructions to cross to the right, while the other starts at the top, aiming to reach the bottom.

+ _*Communications Failure:*_ This scenario is based in the same environment as the Circle scenario. It tests how resilient the #acrpl("GBP") algorithm is to spurious loss of communication between robots. By randomly toggling a robots ability to communicate with others at different probabilities every timestep.


// + _*Communications Failure:*_ This scenario is based in the same environment as the Circle scenario. In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.

// In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.


Specific details and parameters for each environment are presented in the following sections #numref(<s.r.scenarios.circle>), #numref(<s.r.scenarios.clear-circle>), #numref(<s.r.scenarios.varying-network-connectivity>), #numref(<s.r.scenarios.junction>) and #numref(<s.r.scenarios.communications-failure>). Parameters are selected to be identical to whats presented in @gbpplanner. The numerical value of a few parameters in some of the scenarios are not listed explicitly. In these cases an argument for the selected interpretation is presented to justify the values chosen. Additionally, environment visualisations are provided in figures #numref(<f.scenarios.circle>), #numref(<f.scenarios.clear-circle>), and #numref(<f.scenarios.junction>).

=== #scen.circle.n <s.r.scenarios.circle>

// EXCEPT from their paper
// Robots of various sizes are initialised in a circle formation of radius 50 m, with an initial speed of 15 m/s, towards a stationary horizon state at the opposite side of the circle. The radii of the robots are sampled randomly from rR ∼ U (2, 3) m. We set tK−1 as the ideal time taken for a single robot moving from the initial speed to rest across the circle at constant acceleration. This would correspond to a smooth (zero jerk) trajectory. Each robot has a communication range rC = 50 m representing a partially connected network of robots. In addition, we set σd = 1 m.

The challenge of this scenario is that the robots both have to navigate around each other in a a dense area, while also have to evade around the numerous obstacles.

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


/ $M_I$ : Internal #acr("GBP") messages
/ $M_R$ : External inter-robot #acr("GBP") messages
/ $N_R$ : Number of robots
/ $r_R$ : Robot radius
/ $r_C$ : Robot communication radius
/ $s$ : prng seed
/ $|v_0|$ : Initial speed
/ $gamma$ : probability of communication failure
/ $t_K-1$ : #todo[...]
/ $sigma_d$ : sigma value of Dynamic factor
/ $sigma_p$ : sigma value of Pose factor
/ $sigma_r$ : sigma value of Range factor
/ $sigma_o$ : sigma value of Obstacle factor
/ $d_r$ : Inter-robot safety distance

#figure(
  // image("../../../figures/out/circle.svg", width: 30%),
  {},
  caption: [Visualisation circle scenario.],
)<f.scenarios.circle>

=== #scen.clear-circle.n <s.r.scenarios.clear-circle>

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.clear-circle.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.clear-circle.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.clear-circle.factor, previous: params.circle.factor, title: [Factor Settings]),
  ),
  caption: [Clear Circle scenario parameters.],
)<t.scenarios.clear-circle>

#figure(
  // image("../../../figures/out/clear-circle.svg", width: 30%),
  {},
  caption: [Visualisation clear Circle scenario.],
)<f.scenarios.clear-circle>


=== #scen.varying-network-connectivity.n <s.r.scenarios.varying-network-connectivity>

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
  {},
  caption: [Visualisation junction scenario.],
)<f.scenarios.junction>

=== #scen.communications-failure.n <s.r.scenarios.communications-failure>


// EXCEPT from their paper
// Our GBP planner relies on per-timestep peer-to-peer communication between robots. It is assumed that each robot follows a protocol similar to [11]; it always broadcasts its state information. We consider a communications failure scenario where a robot is not able to receive messages from robots it is connected to. We would expect more cautious behaviour when planning a trajectory. We simulate a communication failure fraction γ: at each timestep the robot cannot receive any messages from a randomly sampled proportion γ of its connected neighbours. We repeat the circle experiment with 21 robots at two different initial speeds of 10 m/s and 15 m/s, measuring the makespan. The reported result is an average over 5 different random seeds. To be fair, at any timestep for any robot, the failed communications are exactly the same given a fixed seed for both initial velocities considered.

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


#line(length: 100%, stroke: 10pt + red)
