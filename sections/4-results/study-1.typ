#import "../../lib/mod.typ": *
// #jonas[Alright you can stop reading now. No more content at all.]
// == Overskrift
== #study.H-1.full.n <s.r.study-1>
#jonas[all these results are new since last. We're working towards measuring ours and their code and then comparing their paper vs our code vs their code. Does that make sense? It will be obvious where we are still missing results]
// #todo[create an experiment where we measure the effect of number of internal iterations. Should give a lower error the higher it is.]

This sections presents all results pertaining to the first contribution, that is the #acr("MAGICS") simulator, along with it's capabilities to reproduce the results of the #acr("GBP") planner@gbpplanner. Sections #numref(<s.r.results.circle>)-#numref(<s.r.results.failure>) present the results of the experiments conducted in scenarios #boxed[*S-1*] to #boxed[*S-5*] respectively. For a description of these scenarios see the previous section #nameref(<s.r.scenarios>, "Scenarios").


#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty

  use this to argue on a non-measurable level why our implementation has is similar to theirs / has been reproduced
]

=== Circle <s.r.results.circle>

For this scenario, similar to @gbpplanner, the #acr("LDJ") and _distance travelled_ metrics are presented, see @f.circle-experiment-ldj and @f.circle-experiment-distance-travelled respectively. By comparing both figures to the corresponding ones of @gbpplanner (Fig. 4 and Fig. 5), it is evident that #acr("MAGICS") is unable to reproduce the results of the #acr("GBP") planner for lookahead multiple, $l_m=3$, and time horizon, $t_(K-1)=13.33s$.

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
  The results of the _Environment Obstacles_ scenario are presented in @f.obstacle-experiment-makespan. The figure shows that the makespan for #lm3-th5.s is significantly lower than for the two runs with #text(gradient.linear(theme.yellow, theme.peach), $t_(K-1)=13.33s$). Furthermore, the the makespan values for #lm3-th5.s are much closer to the corresponding values of @gbpplanner.
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
  lm3-th13: (
    rc: (20, 40, 60, 80),
    makespan: (46.012491607666014, 64.58217391967773, 65.34115142822266, 64.63148651123046),
    mean-dist: (236.89510927868324, 285.9908325030257, 295.2933289314799, 283.24733969761115),
    ldj: (-14.479386124124115, -15.966531007631174, -16.334361227393277, -16.105878378955726),
  )
)

#let tablify(dictionaries) = dictionaries.map(dict => dict.values()).flatten().map(it => [#it])
#let colors = (
  theirs: theme.peach.lighten(20%),
  ours: theme.lavender
)
#let vc = table.cell.with(inset: 1em)
#let tc = vc
#let tc2 = table.cell.with(fill: colors.theirs.lighten(70%), stroke: none)
#let oc = table.cell.with(fill: colors.ours.lighten(80%), stroke: none)
#let oc2 = table.cell.with(fill: colors.ours.lighten(80%), stroke: none)

#let theirs = boxed.with(color: colors.theirs)
#let ours = boxed.with(color: colors.ours)

#let T1 = theirs[*T-1*]
#let T2 = theirs[*T-2*]
#let O1 = ours[*O-1*]
#let O2 = ours[*O-2*]

The _makespan_, _distance travelled_, and _LDJ_ metrics are presented in @t.network-experiment. From these numbers, the experiment with communication range of 20 meters, $r_C=20"m"$, did much worse than the other three $r_C in {40, 60, 80}m$, where the change is very minimal in all three metrics.#note.j[Discussion: #sym.dash.en _if not negligible_.] In @t.network-experiment, results of 4 experiments are shown:

#term-table(
  colors: (colors.theirs, colors.ours, colors.ours, colors.theirs),
  boxed(color: colors.theirs, [*Theirs-1*]), [The results from the #gbpplanner paper@gbpplanner],
  boxed(color: colors.ours, [*Ours-1*]), [The results of #acr("MAGICS"), with the same parameters as the #gbpplanner paper; #lm3-th13.n.],
  boxed(color: colors.ours, [*Ours-2*]), [The results of #acr("MAGICS"), with tuned parameters; #lm3-th5.n.],
  boxed(color: colors.theirs, [*Theirs-2*]), [The results of the provided code by #gbpplanner, with the same parameters as the #gbpplanner paper; #lm3-th13.n.],
)
// #[
//   #set list(marker: boxed(color: theme.peach, [*Theirs-1*]))
//   - The results from the #gbpplanner paper@gbpplanner
//   #set list(marker: boxed(color: theme.lavender, [*Ours-1*]))
//   - The results of #acr("MAGICS"), with the same parameters as the #gbpplanner paper; #lm3-th13.n.
//   #set list(marker: boxed(color: theme.lavender, [*Ours-2*]))
//   - The results of #acr("MAGICS"), with tuned parameters; #lm3-th5.n.
//   #set list(marker: boxed(color: theme.peach, [*Theirs-3*]))
//   - The results of the provided code by #gbpplanner, with the same parameters as the #gbpplanner paper; #lm3-th13.n.
// ]

#figure(
  tablec(
    columns: (auto,) + range(12).map(_ => 1fr),
    align: center + horizon,
    header-color: (fill: theme.base, text: theme.text),
    header: table.header(
      tc(rowspan: 2, [$r_C$\ \[$m$\]]), tc(colspan: 4, [MS \[$s$\]]), tc(colspan: 4, [D \[$m$\]]), tc(colspan: 4, [LDJ \[$m"/"s^3$\]]), table.hline(), T1, O1, O2, T2, T1, O1, O2, T2, T1, O1, O2, T2
    ),
    vc[20], table.vline(), vc[$12.0$], oc2[], vc[$46.0$], tc2[], table.vline(), vc[$104$], oc2[], vc[$236.9$], tc2[], table.vline(), vc[$-9.02$], oc2[], vc[$-14.5$], tc2[],
    vc[40], vc[$12.3$], oc2[], vc[$64.6$], tc2[], vc[$104.5$], oc2[], vc[$286.0$], tc2[], vc[$-8.76$], oc2[], vc[$-16.0$], tc2[],
    vc[60], vc[$12.7$], oc2[], vc[$65.3$], tc2[], vc[$104.0$], oc2[], vc[$295.3$], tc2[], vc[$-8.38$], oc2[], vc[$-16.3$], tc2[],
    vc[80], vc[$14.8$], oc2[], vc[$64.6$], tc2[], vc[$103$], oc2[], vc[$283.2$], tc2[], vc[$-8.47$], oc2[], vc[$-16.1$], tc2[],
  ),
  caption: [Effect of varying communication range $r_C$ in the _Environment Obstacles_ experiment. Values in the #text(red, [them]) column is taken from table 1 in @gbpplanner. Performed over 5 different seeds; $#equation.as-set(params.seeds)$.],
)<t.network-experiment>

=== Junction <s.r.results.junction>
#let body = [
  The results of the _junction_ experiment are presented on a plot in @f.qin-vs-qout, similarly to how it was done in @gbpplanner. The plot shows that the input flowrate $Q_"in"$ is very close to the output flowrate $Q_"out"$ for $Q_"in" in [0, 6.5]$, where it starts deviating from the optimal flowrate at $Q_"in" = 7.5$, decreasing to an output flowrate of $Q_"out" approx 6.6$. This result is consisten with both the presented numbers in @gbpplanner and the provided `gbpplanner` code. In @t.qin-vs-qout, the raw data is presented. Here it becomes clear that the output flowrate follows the input flowrate perfectly up until $Q_"in" = 4$, where $Q_"out" = 3.98$ #sym.dash.en _and from here on $Q_"out"$ consistently deviates more and more_.
]

#let fig = [
  #figure(
    image("../../figures/plots/qin-vs-qout.svg"),
    // std-block({
    //   image("../../figures/plots/qin-vs-qout.svg")
    //   v(-1.5em)
    // }),
    caption: [
      This plot illustrates the relationship between the input flowrate $Q_"in"$ the output flowrate $Q_"out"$ robots for the *Junction* scenario, @s.r.scenarios.junction. The dashed dark-gray line #box(line(length: 15pt, stroke:(dash: "dotted", paint: theme.overlay2, thickness: 2pt)), baseline: -0.25em) represents the ideal scenario where $Q_"in" = Q_"out"$. The solid blue colored line with circle markers#sl indicates the average flowrate measured over a 50-second steady-state period. The results demonstrate a close approximation to the ideal flowrate, with slight deviations observed at higher flowrates. Performed over 5 different seeds; $#equation.as-set(params.seeds)$.
    ]
  )<f.qin-vs-qout>
]

#grid(
  columns: (1fr, 90mm),
  column-gutter: 1em,
  body,
  fig
)

#let qins = (0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0)
#let qouts = (0.0, 0.508, 1.0, 1.5199999999999998, 2.0, 2.5, 3.0, 3.5, 3.9760000000000004, 4.476, 4.948, 5.452, 5.964, 6.408000000000001, 6.555999999999999)
#figure(
  {
    let header-columns = (0,)
    tablec(
      columns: (auto,) + range(qins.len()).map(_ => 1fr),
      align: center + horizon,
      fill: (x, y) => if x in header-columns { theme.lavender.lighten(30%) } else if calc.even(x) { theme.base } else { theme.mantle },
      $Q_"in"$,
      ..qins.map(qin => [$#qin$]),
      $Q_"out"$,
      ..qouts.map(qout => [$#strfmt("{0:.2}", qout)$]),
    )
  },
  caption: [The relationship between the input flowrate $Q_"in"$ and the output flowrate $Q_"out"$ for the *Junction* scenario.]
)<t.qin-vs-qout>


=== Communications Failure <s.r.results.failure>
#jens[results from ours and their code.]
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
)<t.comms-failure-experiment>

// THEIR CAPTION
// shows that as γ increases, it takes longer for all robots to reach their goals. However, trajectories for the 10 m/s case are completely collision free up to γ = 80%. As the initial speed increases, collisions happen at lower values of γ as robots have less time to react to faster moving neighbours who they may not be receiving messages from. This experiment shows one of the benefits of GBP — safe trajectories can still be planned even with possible communication failures, which is likely in any realistic settings.
