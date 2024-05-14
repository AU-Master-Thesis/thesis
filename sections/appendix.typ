#import "../lib/mod.typ": *

// == Appendix <s.appendix>


=== Reproduction Experiment Parameters <appendix.reproduction-experiment-parameters>

#todo[Beutify table]

#figure(
  table(
    columns: (1fr, 3fr, 1fr),
    align: (center, left, center),
    table.header([*Parameter*], [*Description*], [*Unit*]),
    [$C_("radius")$], [Radius of the circle that the robots spawn in circle scenarios like @s.r.scenarios.circle], [$m$],
    [$r_R$], [Robot radius], [$m$],
    [$r_C$], [Robot communication radius], [$m$],
    [$|v_0|$], [Initial speed], [$m"/"s$],
    [$N_r$], [Number of robots], [],
    [$s$], [prng seed], [],
    [$delta_t$], [Time passed between each simulation step], [$s$],
    [$M_i$], [Internal #acr("GBP") messages], [],
    [$M_r$], [External inter-robot #acr("GBP") messages], [],
    [$gamma$], [probability for the communication module to be toggled on/off], [$percent$],
    [$t_K-1$], [Extend of time horizon. The time it should take for the currrent variable to reach the horizon variable], [$s$],
    [$|V|$], [Number of variables in each factorgraph], [],
    [$sigma_d$], [sigma value of Dynamic factor], [],
    [$sigma_p$], [sigma value of Pose factor], [],
    [$sigma_r$], [sigma value of Range factor], [],
    [$sigma_o$], [sigma value of Obstacle factor], [],
    [$d_r$], [Inter-robot safety distance. When two variables connected by a interrobot factor are within this distance, the factor will send factor messages to alternate the course of both robot's path.], [$C_("radius")$],
  ),
  caption: [Experiment parameters for all reproduction scenarios. See @s.r.scenarios for an writeup of the scenarios.]
) <t.appendix.reproduction-experiment-parameters>


=== Interpretation of parameters <appendix.interpretation-of-parameters>

#set par(first-line-indent: 0em)

- $|v_(0)| = v_i = 15 m"/"s$

- $|v_("final")| = v_f = 0 m"/"s$

- $j(t) = (d a(t))/(d t) = 0 m"/"s^3$

- $C_("radius") = 50 m$

- $d = 2 C_("radius") = 100 m$

Use the following equations for velocity and displacement under constant acceleration@essential-university-physics:


$ v_f = v_i + a t $ <equ.kinematic-velocity>

$ d = v_i t + 1/2 a t^2 $ <equ.kinematic-distance>

Isolate $a$ in @equ.kinematic-velocity

#let a = $-15/t m / s$
$ 0 m/s = 15 m/s + a t  <=> a = #a $

Substituting $a$ into @equ.kinematic-distance to get:

$
  100 m &= 15 m/s  t + 1/2 (#a) t^2 \

  &= 15 m/s t - 7.5 m/s t \
  &= 7.5 m / s t \
  &<=>  t = (100 m) / (7.5 m / s) = 13 1/3 s


$
