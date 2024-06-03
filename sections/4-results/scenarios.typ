#import "../../lib/mod.typ": *
== Scenarios <s.r.scenarios>

#let scenario(name) = [_*#name*_]

// #jonas[Read this, and all subsections]
The performance of #acr("MAGICS") is evaluated across #numbers.written(scen.len()) different scenarios. The first five, #boxed(color: theme.peach, [*S-X*]), scenarios adhere to the original paper's@gbpplanner experiments, where the last 2, #boxed(color: colors.ours, [*S-X*]), are specifically designed for the global planning extension that #acr("MAGICS") provides. The scenarios are:
// #jonas[fixed the boldness overload here]

#set enum(numbering: box-enum.with(color: colors.theirs, prefix: "ST-"))
+ #scenario[Circle:] The environment of this scenario is empty. Robots are placed along the perimeter of a circle centered at the origin with radius $r$. Every robot is tasked with reaching the opposite side of the circle.

+ #scenario[Environment Obstacles:] This scenario is similar to the Circle scenario, but with obstacles near the center of the circle. // Again robots are placed in a circle, centered at $(0, 0)$ with $r=50m$, and are tasked with reaching the opposite side of the circle.

+ #scenario[Varying Network Connectivity:] Identical environment to the Environment Obstacles scenario, but with larger spawning radius. The radius of the robots communication range varied.

+ #scenario[Junction:] This environment is much more constrained, only with two roads; a vertical and horizontal one, centered in their cross-axis. Thus creating a simple crossroads at the very center of the environment. Robots are spawned repeatedly in two formations. One group begins on the left side with instructions to cross to the right, while the other starts at the top, with a mission to reach the bottom.

+ #scenario[Communications Failure:] This scenario is based in the same environment as the Circle scenario. It tests how resilient the #acrpl("GBP") algorithm is to spurious loss of communication between robots. By randomly toggling a robots ability to communicate with others at different probabilities every timestep.

#set enum(numbering: box-enum.with(color: colors.ours, prefix: "SO-"))
+ #scenario[Solo Global Planning:] This scenario serves as an isolated test for automated placement of waypoints with #acr("RRT*") and the impact of the tracking factor, $f_t$, on a single robot. This scenario takes place in a complex maze-like environment, where a single robot is spawned in one end, and tasked with reaching the other end.

+ #scenario[Collaborative Global Planning:] This scenario is similar to #boxed(color: colors.ours, [*SO-1*]), but with many robots. Several spawning locations are possible, where each individual robot get a task to traverse the complex environment. The purpose of this scenario is to test the interactivity between the tracking factors and the interrobot factors, $f_i$.

+ #scenario[Iteration Amount:] Same environment as the Circle scenario. This explores the effect of varying $M_I$ and $M_R$. The goal is to determine optimal values for these parameters and whether increasing the iteration count consistently improves performance.

+ #scenario[Iteration Schedules:] Identical environment and formation as the Circle scenario. This scenario explores the effect of the various iteration schedules presented in @s.iteration-schedules.


// + _*Communications Failure:*_ This scenario is based in the same environment as the Circle scenario. In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.

// In this scenario simulates the possibility of communication failure between the robots by flipping a communication toggle with some probability at every timestep.


Specific details and parameters for each scenario are presented in the following sections #numref(<s.r.scenarios.circle>)-#numref(<s.r.scenarios.communications-failure>). Parameters are selected to be identical to whats presented in @gbpplanner. The numerical value of a few parameters in some of the scenarios are not listed explicitly. In these cases an argument for the selected interpretation is presented to justify the values chosen. An asterisk is used as a postfix for the values for which this applies, e.g. $x^*$. For example the lookahead multiple $l_m$ is only set as a default value to $3$ in the source codes configuration class #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/inc/Globals.h#L49", "./inc/Globals.h:49") and not overwritten in any of the provided experimental configuration files. A lot of the values are the same between scenarios. To make the differences stand out, each value that is different from its value in the Circle scenario is colored #text(theme.red, [red]). Parameters related to the #acr("GBP") algorithm have been explained in detail throughout the @methodology. New parameters not explained previously are:

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
@gbpplanner-code. Note that the parameters in the #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/config/circle_cluttered.json", "config/circle_cluttered.json") and #source-link("https://github.com/aalpatya/gbpplanner/tree/main/config", "config/*.json") does not match any of the experimental scenarios listed in @gbpplanner.
#note.a[ref to discussion about mismatch between code and paper experiments]

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.circle.env, title: [Environment]),
    params.tabular(params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.circle.factor, title: [Factor Settings]),
  ),
  caption: [#scenario[Circle] scenario parameters.],
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
  caption: [#scenario[Environment Obstacles] scenario parameters.],
)<t.scenarios.environment-obstacles>

#figure(
  // image("../../../figures/out/clear-circle.svg", width: 30%),
  // std-block(todo[Add image]),
  std-block(image("../../figures/img/environment-obstacles-scenario-preview.png")),
  caption: [Visualisation of #scenario[Environment Obstacles] scenario. The red #sr outline of each obstacle is boundary of the collider volume used to check for environment collisions.]
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
  caption: [#scenario[Junction] scenario parameters.],
)<t.scenarios.junction>

=== #scen.junction.n <s.r.scenarios.junction>

Robots working in crowded environments may need to operate at high speeds with high levels of coordination, such as when traversing junctions between shelves in a warehouse. This scenario simulates one such junction with channel widths of 16 meters and robots moving at 15 $m "/" s$. $t_(K-1) = 2s$ to force the robots to have a short horizon to plan a path within when they reach the junction center. In addition $sigma_d =0.5m$. An explanation for why this parameter is changed from $1m$ is not given. Its presumed here that it is done to have the dynamic factors have a larger influence to better react when robots are crossing each other perpendicularly in the junction.
A desirable trait of multirobot systems is to maintain a high flow rate without causing blockages at junctions. To test this the the rate $Q_("in")$ at which robots enter the central section of the junction is adjusted, and the rate $Q_("out")$ at which they exit is measured. To measure flow, the central section is observed over 500 timesteps to represent steady-state behavior. Robots must exit the junction in the same direction they entered, without collisions. $Q_("in")$ is adjusted over the list of values

$ Q_("in") in [0.5, 1, ..., 7] $

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
  caption: [Junction scenario parameters. $C_("radius")$ is not relevant for this scenario, as robots are not spawned in a circle. Likewise the number of robots $N_R$ is not fixed, but instead given as $Q_("in") times 500 "/" Delta_t = Q_("in") times 50 s$.],
)<t.scenarios.junction>

#figure(
  // image("../../../figures/out/junction.svg", width: 30%),
  // std-block(todo[Add image]),
  std-block(image("../../figures/img/junction-experiment-preview.png")),
  caption: [
  Screenshot of the junction scenario with $Q_("in") = 6 "robots/s"$. The green #sg edges represent the the joint factorgraph.
],
)<f.scenarios.junction>

=== #scen.communications-failure.n <s.r.scenarios.communications-failure>


// EXCEPT from their paper
// Our GBP planner relies on per-timestep peer-to-peer communication between robots. It is assumed that each robot follows a protocol similar to [11]; it always broadcasts its state information. We consider a communications failure scenario where a robot is not able to receive messages from robots it is connected to. We would expect more cautious behaviour when planning a trajectory. We simulate a communication failure fraction γ: at each timestep the robot cannot receive any messages from a randomly sampled proportion γ of its connected neighbours. We repeat the circle experiment with 21 robots at two different initial speeds of 10 m/s and 15 m/s, measuring the makespan. The reported result is an average over 5 different random seeds. To be fair, at any timestep for any robot, the failed communications are exactly the same given a fixed seed for both initial velocities considered.

This scenario uses the same environment as the Environment Obstacles scenario (see @s.r.scenarios.environment-obstacles). The purpose of this scenario is to test the planning algorithm's performance under sub-optimal external communication conditions. In real-world situations, this could be caused by phenomena such as packet loss due to congestion in the radio frequency band or high interference from other electrical equipment transmitting messages. Under these conditions, the expected behavior for the planning algorithm to exhibit is increased caution when determining a trajectory. #note.k[should probably be in the dedicated section about interrobot factor] To simulate this the same non-zero probability $gamma$ is assigned to each robot. At every simulated timestep a robots ability to communicate with other factorgraphs through any established interrobot factors are toggled with probability $gamma$. For two robots $A$ and $B$ with variable $v_n^A$ and $v_n^B$, connected by interrobot factors $f_(r_n)^A (v_n^A, v_n^B)$ and $f_(r_n)^B (v_n^A, v_n^B)$. There are four possible states the system can be in.
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
  , caption: [#scenario[Communications Failure] scenario parameters.],
)<t.scenarios.communications-failure>

=== #scen.solo-gp.n <s.r.scenarios.solor-gp>

In this scenario a complex, maze-like environment has been constructed#footnote[Found in #gbp-rs(content: "AU-Master-Thesis/gbp-rs"), in file #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/c17370455af38a6cab0eb5acea1a576247a0e732/config/simulations/Complex/environment.yaml", "config/simulations/Complex/environment.yaml")], similar to the one shown in @f.m.maze-env. #att[A demonstration of this environment, with and without global planning enabled is shown in an accompanying video#todo[cite video or footnote]]. A single robot is spawned in the bottom-left corner of the environment, see @f.scenarios.solo-gp. The robot is tasked with reaching the top-right corner of the environment. The environment is designed to be challenging, with narrow corridors, tight corners, and a plethora of possible paths. The accompanying `formation.yaml`#footnote[#jens[source-link]] file specifies the planning strategy to be that of `rrt-star` instead of `only-local`, which has been the case for all of the above scenarios. The robot is equipped with a #acr("RRT*") pathfinding component, which, in @f.scenarios.solo-gp, has just finished computing the path it is expected to take. The path is shown as a faint red line across the corridors of the map. Parameters are listed in @f.scenarios.solo-gp.

```toml
[rrt]
max-iterations       = 5000000
step-size            = 5.0
collision-radius     = 3.0
neighbourhood-radius = 8.0
#
# [rrt.smoothing]
# enabled        = true
# max-iterations = 500
# step-size      = 0.5
```
#note.jo[this will be put into table and referenced to]

// The tracking factor $f_t$ is set to $0.5$ to test the impact of the tracking factor on a single robot in a complex environment.

#figure(
  // std-block(todo[Screen of environment after global planning]),
  std-block(
    width: 80%,
    block(
      clip: true,
      pad(
        x: -8mm,
        y: -0.2mm,
        image("../../figures/img/solo-gp.png")
      )
    )
  ),
  caption: [
    Screenshot of the complex maze-like environment. The robot#sg has just spawned in the bottom-left corner, and its #acr("RRT*") pathfinding has just finished. The path it is expected to take is shown as a faint red line #inline-line(stroke: theme.green.lighten(50%) + 2pt) across the corridors of the map. Here the tracking factors have been enabled.
  ]
)<f.scenarios.solo-gp>

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.solo-gp.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.solo-gp.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.solo-gp.factor, previous: params.circle.factor, title: [Factor Settings]),
  )
  , caption: [#scenario[Solo GP] scenario parameters.],
)<t.scenarios.solo-gp>

=== #scen.collaborative-gp.n <s.r.scenarios.collaborative-gp>

Here, the same complex environment as in the #scen.solo-gp.n scenario is used. However, instead of a single robot, multiple robots are spawned in different locations across the environment. That means the `formation.yaml`#footnote[#jens[source-link to formation file]] file is significantly more detailed. Specifically there are four spawning location, one in each corner; where each robot is tasked with reaching the opposite corner. Each robot is, once again, equipped with a #acr("RRT*") pathfinding component, which will compute a collision free path in terms of the static environment. @f.scenarios.collaborative-gp shows a screenshot of the simulation in progress, where multiple robots are using the waypoint tracking approach, as described in @s.m.planning.waypoint-tracking. Parameters are listed in @t.scenarios.collaborative-gp

```toml
[rrt]
max-iterations = 5000000
step-size = 5.0
collision-radius = 3.0
neighbourhood-radius = 8.0

# [rrt.smoothing]
# enabled = true
# max-iterations = 500
# step-size = 0.5
```
#note.jo[this will be put into table and referenced to]


#figure(
  // std-block(todo[image of many robots driving in the maze]),
  std-block(
    width: 80%,
    block(
      clip: true,
      pad(
        x: -8mm,
        y: -0.2mm,
        image("../../figures/img/collaborative-gp.png")
      )
    )
  ),
  caption: [Screenshot of the maze-like environment#footnote[#todo[...]], with multiple robots spawned in different locations. Tracking factors are not enables here.]
)<f.scenarios.collaborative-gp>

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.collaborative-gp.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.collaborative-gp.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.collaborative-gp.factor, previous: params.circle.factor, title: [Factor Settings]),
  )
  , caption: [#scenario[Collaborative GP] scenario parameters.],
)<t.scenarios.collaborative-gp>

=== #scen.iteration-amount.n <s.r.scenarios.iteration-amount>

This scenario explores the effect of varying $M_I$ and $M_R$. Both $M_I$ and $M_R$ are varied over the second to tenth number in the Fibonacci sequence.
$ M_I and M_R =  {"fib(i)" | i in [2,3, ..., 10]} $

This sequence of values are chosen to test the algorithm at very few iterations initially and increasingly at more iterations with larger difference between each step.

#par(first-line-indent: 0pt)[
  _*Expectation*_: Performance should converge after 8-10 iterations of both $M_I$ and $M_R$. Performance is poor with very few iterations for either parameter. Consequently, performance will be suboptimal if either $M_I$ or $M_R$ are close to $1$ while the other is higher.
]

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.iteration-amount.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.iteration-amount.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.iteration-amount.factor, previous: params.circle.factor, title: [Factor Settings]),
  ),
  caption: [#scenario[Iteration Amount] scenario parameters.],
)
<t.scenarios.iteration-amount>

=== #scen.iteration-schedules.n <s.r.scenarios.iteration-schedules>

The parameters for this scenario are listed in @t.scenarios.iteration-schedules. The number of robots spawning in the circular formation is kept constant at $N_R = 30$ for all runs. Each of the five schedules presented in @s.iteration-schedules are tested with internal iteration $M_i = 50$, and external iteration $M_R$ varied between ${5, 10, 15, 20, 25}$. $M_R$ is varied instead of $M_I$ as it represents the external communication that would be subject to jitter and latency in a real-scenario.

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.iteration-schedules.env, previous: params.circle.env, title: [Environment]),
    params.tabular(params.iteration-schedules.gbp, previous: params.circle.gbp, title: [GBP Algorithm], extra-rows: 0),
    params.tabular(params.iteration-schedules.factor, previous: params.circle.factor, title: [Factor Settings]),
  )
  , caption: [#scenario[Iteration Schedules] scenario parameters.],
)<t.scenarios.iteration-schedules>
