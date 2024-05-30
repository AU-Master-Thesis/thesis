#import "../../lib/mod.typ": *
// #jonas[Alright you can stop reading now. No more content at all.]
// == Overskrift
== #study.H-1.full.n <s.r.study-1>

// #todo[create an experiment where we measure the effect of number of internal iterations. Should give a lower error the higher it is.]

This sections presents all results pertaining to the first contribution, that is the #acr("MAGICS") simulator, along with it's capabilities to reproduce the results of the #acr("GBP") planner@gbpplanner. Sections #numref(<s.r.results.circle>)-#numref(<s.r.results.failure>) present the results of the experiments conducted in scenarios #boxed[*S-1*] to #boxed[*S-5*] respectively. For a description of these scenarios see the previous section #nameref(<s.r.scenarios>, "Scenarios").

=== Circle <s.r.results.circle>

For this scenario, similar to @gbpplanner, the #acr("LDJ") and _distance travelled_ metrics are presented, see @f.circle-experiment-ldj and @f.circle-experiment-distance-travelled respectively. By comparing both figures to the corresponding ones of @gbpplanner (Fig. 4 and Fig. 5), it is evident that #acr("MAGICS") is unable to reproduce the results of the #acr("GBP") planner for $l_m=3,t_(K-1)=13.33s$.

#let handles = (
  (
    label: [$l_m=3$, $t_(K-1)=5s$],
    color: theme.lavender,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [$l_m=1$, $t_(K-1)=13.33s$],
    color: theme.yellow,
    alpha: 50%,
    space: 1em,
  ),
  (
    label: [$l_m=3$, $t_(K-1)=13.33s$],
    color: theme.peach,
    alpha: 50%,
    space: 0em,
  )
)
#let value-swatches = [#sl#swatch(theme.yellow.lighten(45%))#swatch(theme.peach.lighten(45%))]

#figure(
  // image("../../figures/plots/circle-experiment-ldj.svg"),
  z-stack(
    image("../../figures/plots/circle-experiment-ldj.svg"),
    {
      set text(size: 1.1em)
      place(right + bottom, dy: -3.6em, dx: -1em, legend(handles, direction: ltr))
    }
  ),
  caption: [
  #acr("LDJ") metric for the _Circle_ scenario as the number of robots $N_R$ increases. Each value#value-swatches is averaged over five different seeds; $#equation.as-set(params.seeds)$.
]
)<f.circle-experiment-ldj>

#let lm3-th13 = (
  s: text(theme.peach, $l_m=3,t_(K-1)=13.33s$),
  n: $l_m=3,t_(K-1)=13.33s$
)
// #let lm1-th13 = text(theme.yellow, $l_m=1,t_(K-1)=13.33s$)
// #let lm3-th5 = text(theme.lavender, $l_m=3,t_(K-1)=5s$)
#let lm1-th13 = (
  s: text(theme.yellow, $l_m=1,t_(K-1)=13.33s$),
  n: $l_m=1,t_(K-1)=13.33s$
)
#let lm3-th5 = (
  s: text(theme.lavender, $l_m=3,t_(K-1)=5s$),
  n: $l_m=3,t_(K-1)=5s$
)

The results on both figures @f.circle-experiment-ldj and @f.circle-experiment-distance-travelled, show that lowering the lookahead multiple to #text(theme.yellow, $l_m=1$), or lowering the time horizon to #text(theme.peach, $t_(K-1)=5s$) individually obtain results that are closer to those of @gbpplanner. The best possible results are acheived with #text(theme.lavender, $l_m=3,t_(K-1)=5s$).

#figure(
  z-stack(
    // columns: 2,
    image("../../figures/plots/circle-experiment-distance-travelled.svg"),
    // place(right + bottom, dy: -4em, image("../../figures/plots/legend.svg", width: 10em)),
    {
      set text(size: 1.1em)
      place(right + bottom, dy: -3.6em, dx: -1em, legend(handles, direction: ltr))
    }
  ),
  caption: [
    Distribution of distances travelled as the number of robots $N_R$ increases. Each value#value-swatches is averaged over five different seeds; $#equation.as-set(params.seeds)$.
  ]
)<f.circle-experiment-distance-travelled>

=== Environment Obstacles <s.r.results.obstacles>

#let fig = [
  #figure(
    z-stack(
      pad(
        x: -4mm,
        y: -4mm,
        image("../../figures/plots/circle-experiment-makespan-no-legend.svg")
      ),
      {
        set text(size: 1.1em)
        place(right + top, dy: 0.5em, dx: -0.2em, legend(handles, direction: ttb))
      }
    ),
    caption: [
      Comparison of makespan for the _Circle_ and _Environment Obstacles_ scenarios as the number of robots $N_R$ increases. Each value #sl is averaged over five different seeds; $#equation.as-set(params.seeds)$.
    ]
  )<f.obstacle-experiment-makespan>
]

#let body = [
  The results of the _Environment Obstacles_ scenario are presented in @f.obstacle-experiment-makespan. The figure shows that the makespan for #lm3-th5.s is significantly lower than for the two runs with #text(gradient.linear(theme.yellow, theme.peach), $t_(K-1)=13.33s$). Furthermoe, the the makespan values for #lm3-th5.s are much closer to the corresponding values of @gbpplanner.
]

#grid(
  columns: (1fr, 90mm),
  column-gutter: 1em,
  body,
  fig
)


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
  caption: [Effect of varying communication range $r_C$ in the _Environment Obstacles_ experiment. Values in the #text(red, [them]) column is taken from table 1 in @gbpplanner. Performed over 5 different seeds; $#equation.as-set(params.seeds)$.],
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
    This plot illustrates the relationship between the input flowrate $Q_("in")$ the output flowrate $Q_("out")$ robots for the *Junction* scenario, @s.r.scenarios.junction. The dashed dark-gray line #box(line(length: 15pt, stroke:(dash: "dotted", paint: theme.overlay2, thickness: 2pt)), baseline: -0.25em) represents the ideal scenario where $Q_("in") = Q_("out")$. The solid lavender colored line with circle markers#sl indicates the average flowrate measured over a 50-second steady-state period. The results demonstrate a close approximation to the ideal flowrate, with slight deviations observed at higher flowrates. Performed over 5 different seeds; $#equation.as-set(params.seeds)$.
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
