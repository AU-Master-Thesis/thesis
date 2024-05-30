#import "../../lib/mod.typ": *
// #jonas[Alright you can stop reading now. No more content at all.]
// == Overskrift
== #study.H-1.full.n <s.r.study-1>

// #todo[create an experiment where we measure the effect of number of internal iterations. Should give a lower error the higher it is.]

=== Circle <s.r.results.circle>

#figure(
  image("../../figures/plots/circle-experiment-distance-travelled.svg"),
  // std-block({
  //   image("../../figures/plots/circle-experiment-distance-travelled.svg")
  //   v(-1.5em)
  // }),
  caption: [
    Distribution of distances travelled as the number of robots $N_R$ increases. Each value #sl is averaged over five different seeds.

    #todo[for $t_(K-1) = 13.33 s$ and lookahead multiple = 1]
  ]
) <f.circle-experiment-distance-travelled>


#figure(
  image("../../figures/plots/circle-experiment-ldj.svg"),
  caption: [
  #acr("LDJ") metric for the _Circle_ scenario as the number of robots $N_R$ increases. Each value #sl is averaged over five different seeds.

  #todo[for $t_(K-1) = 13.33 s$ and lookahead multiple = 1]
]
) <f.circle-experiment-ldj>

=== Environment Obstacles <s.r.results.obstacles>

#figure(
  image("../../figures/plots/circle-experiment-makespan-no-legend.svg"),
  caption: [
Comparison of makespan for the _Circle_ and _Environment Obstacles_ scenarios as the number of robots $N_R$ increases. Each value #sl is averaged over five different seeds.

  #todo[for $t_(K-1) = 13.33 s$ and lookahead multiple = 1]
]
) <f.obstacle-experiment-makespan>


=== Varying Network Connectivity <s.r.results.network>



#let gbpplanner-results = (
  rc: (20, 40, 60, 80),
  makespan: (12.0, 12.3, 12.7, 14.8),
  mean-dist: (104.0, 104.5, 104.0, 103.8),
  ldj: (-9.02, -8.76, -8.38, -8.47),
)

#let ours = (
  rc: (20, 40, 60, 80),
  makespan: (0, 0, 0, 0),
  mean-dist: (0, 0, 0, 0),
  ldj: (0, 0, 0, 0),
)

#let tablify(dictionaries) = dictionaries.map(dict => dict.values()).flatten().map(it => [#it])

#let tc = table.cell
#let vc = table.cell.with(inset: 1em)
#let oc = table.cell.with(fill: theme.maroon.lighten(50%), stroke: theme.maroon)

#let gbpplanner-results = (
  rc: (20, 40, 60, 80),
  makespan: (12.0, 12.3, 12.7, 14.8),
  mean-dist: (104.0, 104.5, 104.0, 103.8),
  ldj: (-9.02, -8.76, -8.38, -8.47),
)

#figure(
  table(
    columns: range(7).map(_ => 1fr),
    align: center + horizon,
    stroke: gray,
    table.header( tc(rowspan: 2, $r_C$), tc(colspan: 2, [MS $s$]), tc(colspan: 2, [D $m$]), tc(colspan: 2, [LDJ]), [them], [us], [them], [us], [them], [us]),

    vc[20], vc[$12$], oc[], vc[$104$], oc[], vc[$-9.02$], oc[],
    vc[40], vc[$12.3$], oc[], vc[$104.5$], oc[], vc[$-8.76$], oc[],
    vc[60], vc[$12.7$], oc[], vc[$104.0$], oc[], vc[$-8.38$], oc[],
    vc[80], vc[$14.8$], oc[], vc[$103$], oc[], vc[$-8.47$], oc[],
  ),
  caption: [Effect of varying communication range $r_C$ in the _Environment Obstacles_ experiment. Values in the #text(red, [them]) column is taken from table 1 in @gbpplanner.],
)

=== Junction <s.r.results.junction>
The results of the

#figure(
  image("../../figures/plots/qin-vs-qout.svg"),
  // std-block({
  //   image("../../figures/plots/qin-vs-qout.svg")
  //   v(-1.5em)
  // }),
  caption: [
    This plot illustrates the relationship between the input flowrate $Q_("in")$ the output flowrate $Q_("out")$ robots for the *Junction* scenario, @s.r.scenarios.junction. The dashed dark-gray line #box(line(length: 15pt, stroke:(dash: "dotted", paint: theme.overlay2, thickness: 2pt)), baseline: -0.25em) represents the ideal scenario where $Q_("in") = Q_("out")$. The solid lavender colored line with circle markers#sl indicates the average flowrate measured over a 50-second steady-state period. The results demonstrate a close approximation to the ideal flowrate, with slight deviations observed at higher flowrates.
  ]
) <f.qin-vs-qout>



=== Communications Failure <s.r.results.failure>


// Circle experiment: distribution of distances travelled as number of robots in the formation NR is varied. The GBP planner creates shorter paths and a smaller spread of distances than ORCA; robots collaborate to achieve their goals.

// Circle experiment: distribution of the LDJ metric as NR increases, with smoother trajectories shown by more positive values. The worst performing GBP planning robots had smoother paths than the best robots for ORCA.

#let gbpplanner-results = (
  rc: (0, 10, 20, 30, 40, 50, 60, 70, 80, 90),
  makespan_10: (19.5, 20.3, 22.9, 25.7, 30.8, 35.6, 42.0, 51.3, 87.4, 146.9),
  mean_collisions_10: (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.6),
  makespan_15: (14.9, 17.1, 18.9, 22.5, 26.5, 30.6, 38.8, 44.6, 63.4, 12.6),
  mean_collisions_15: (0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.8, 0.8, 0.8, 4.6),
)

#figure(
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.cell(colspan: 1, [Initial speed m/s]), table.cell(colspan: 2, $10$), table.cell(colspan: 2, $15$),
    table.hline(),
    [$gamma$], [Makespan $s$], [Mean num collisions], [Makespan $s$], [Mean num collisions],
    table.hline(),

    ..tablify(aos(gbpplanner-results)),
    table.hline(),
  ),
  caption: [ttt]
)

#figure(
  table(
    columns: range(9).map(_ => 1fr),
    align: center + horizon,
    stroke: gray,
    table.header(
      tc(colspan: 1, [$|v_0|$]), tc(colspan: 4, $10$), tc(colspan: 4, $15$),
      tc(rowspan: 2, $gamma$), tc(colspan: 2, [MS $s$]), tc(colspan: 2, [C]), tc(colspan: 2, [MS $s$]), tc(colspan: 2, [C]),
      ..range(4).map(_ => ([them], [us])).flatten()
    ),
    $0$, $19.5$, oc[], $0$, oc[], $14.9$, oc[], $0$, oc[],
    $10$, $20.3$, oc[], $0$, oc[], $17.1$, oc[], $0$, oc[],
    $20$, $22.9$, oc[], $0$, oc[], $18.9$, oc[], $0$, oc[],
    $30$, $25.7$, oc[], $0$, oc[], $22.5$, oc[], $0$, oc[],
    $40$, $30.8$, oc[], $0$, oc[], $26.5$, oc[], $0$, oc[],
    $50$, $35.6$, oc[], $0$, oc[], $30.6$, oc[], $0.2$, oc[],
    $60$, $42$, oc[], $0$, oc[], $38.8$, oc[], $0.8$, oc[],
    $70$, $51.3$, oc[], $0$, oc[], $44.6$, oc[], $0.8$, oc[],
    $80$, $87.4$, oc[], $0$, oc[], $63.4$, oc[], $0.8$, oc[],
    $90$, $146.9$, oc[], $1.6$, oc[], $12.6$, oc[], $4.6$, oc[],
  ),
  caption: [
    Values in the #text(red, [them]) column is taken from table 2 in @gbpplanner.
  ]
)

// THEIR CAPTION
// shows that as γ increases, it takes longer for all robots to reach their goals. However, trajectories for the 10 m/s case are completely collision free up to γ = 80%. As the initial speed increases, collisions happen at lower values of γ as robots have less time to react to faster moving neighbours who they may not be receiving messages from. This experiment shows one of the benefits of GBP — safe trajectories can still be planned even with possible communication failures, which is likely in any realistic settings.
