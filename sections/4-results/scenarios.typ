#import "../../lib/mod.typ": *
== Scenarios <s.r.scenarios>

The performance of the reimplementation is evaluated in four different scenarios;
#scen.circle.s, #scen.clear-circle.s, and #scen.junction.s. These scenarios adhere to the original paper's@gbpplanner experiments.

#set enum(numbering: box-enum.with(prefix: "S-"))
+ _*Circle:*_ This environment presents 6 small obstacles in the middle of the environment. 30 robots are placed in a circle, centered on the environment with radius $r=50m$ around the obstacles. The robots are tasked with reaching the opposite side of the circle.
+ _*Clear Circle:*_ This environment is similar to the Circle scenario, but without any obstacles. Again 30 robots are placed in a circle, centered with $r=50m$, and are tasked with reaching the opposite side of the circle.
+ _*Junction:*_ This environment is much more constrained, only with two roads; a vertical and horizontal one, centered in their cross-axis. Thus creating a simple crossroads the very center of the environment.

Specific details and parameters for each environment are presented in the following sections #numref(<s.r.scenarios.circle>), #numref(<s.r.scenarios.clear-circle>), and #numref(<s.r.scenarios.junction>). Additionally, environment visualisations are provided in figures #numref(<f.scenarios.circle>), #numref(<f.scenarios.clear-circle>), and #numref(<f.scenarios.junction>).

=== #scen.circle.n <s.r.scenarios.circle>

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.circle.env, title: [Environment]),
    params.tabular(params.circle.gbp, title: [GBP Algorithm], extra-rows: 1),
    params.tabular(params.circle.gbp.factor, title: [Factor Settings]),
  ),
  caption: [Circle scenario parameters.],
)<t.scenarios.circle>


/ $M_I$ : Internal #acr("GBP") messages
/ $M_R$ : External inter-robot #acr("GBP") messages
/ $N_R$ : Number of robots
/ $r_R$ : Robot radius

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
    params.tabular(params.clear-circle.env, title: [Environment]),
    params.tabular(params.clear-circle.gbp, title: [GBP Algorithm], extra-rows: 1),
    params.tabular(params.clear-circle.gbp.factor, title: [Factor Settings]),
  ),
  caption: [Clear Circle scenario parameters.],
)<t.scenarios.clear-circle>

#figure(
  // image("../../../figures/out/clear-circle.svg", width: 30%),
  {},
  caption: [Visualisation clear Circle scenario.],
)<f.scenarios.clear-circle>

=== #scen.junction.n <s.r.scenarios.junction>

#figure(
  grid(
    columns: (40%, 30% - 0.5em, 30% - 0.5em),
    column-gutter: 0.5em,
    params.tabular(params.junction.env, title: [Environment]),
    params.tabular(params.junction.gbp, title: [GBP Algorithm], extra-rows: 1),
    params.tabular(params.junction.gbp.factor, title: [Factor Settings]),
  ),
  caption: [Junction scenario parameters.],
)<t.scenarios.junction>

#figure(
  // image("../../../figures/out/junction.svg", width: 30%),
  {},
  caption: [Visualisation junction scenario.],
)<f.scenarios.junction>
