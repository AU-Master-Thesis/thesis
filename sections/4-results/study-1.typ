#import "../../lib/mod.typ": *
// #jonas[Alright you can stop reading now. No more content at all.]
// == Overskrift
#pagebreak(weak: true)
== #study.H-1.full.n <s.r.study-1>
// #jonas[all these results are new since last. We are working towards measuring ours and their code and then comparing their paper vs our code vs their code. Does that make sense? It will be obvious where we are still missing results]
// #todo[create an experiment where we measure the effect of number of internal iterations. Should give a lower error the higher it is.]

This section presents all results pertaining to the first contribution, that is the #acr("MAGICS") simulator, along with its capabilities to reproduce the results of the #acr("GBP") Planner@gbpplanner. Sections #numref(<s.r.results.circle-obstacles>)-#numref(<s.r.results.failure>) present the results of the experiments conducted in scenarios #boxed[*S-1*] to #boxed[*S-5*] respectively. For a description of these scenarios see the previous section #nameref(<s.r.scenarios>, "Scenarios").

=== Circle & Environment Obstacles <s.r.results.circle-obstacles>

For this scenario, similar to @gbpplanner, the _#acr("LDJ")_ and _distance travelled_ metrics are presented, see @f.circle-experiment-ldj and @f.circle-experiment-distance-travelled respectively. By comparing both figures to the corresponding ones of @gbpplanner, Figure 4 and 5, it is evident that #acr("MAGICS") is unable to reproduce the results of the #acr("GBP") Planner for lookahead multiple, $l_m=3$, and time horizon, $t_(K-1)=13.33s$.

#let handles = (
  (
    label: [C: $l_m=3,t_(K-1)=5s$],
    color: theme.lavender,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [C: $l_m=1,t_(K-1)=13.33s$],
    color: theme.teal,
    alpha: 70%,
    space: 1em,
  ),
  (
    label: [C: $l_m=3,t_(K-1)=13.33s$],
    color: theme.green,
    alpha: 70%,
    space: 1em,
  ),
  (
    label: [EB: $l_m=3,t_(K-1)=5s$],
    color: theme.mauve,
    alpha: 50%,
    space: 0em,
  )
)
// #let value-swatches = [#sl#swatch(theme.yellow.lighten(45%))#swatch(theme.peach.lighten(45%))]

#let value-swatches = {
  for s in handles.map(handle => swatch(handle.color.lighten(handle.alpha))) {
    s
  }
}

#figure(
  grid(
    columns: 2,
    align: horizon,
    block(
      clip: true,
      pad(
        top: -2mm,
        right: -2mm,
        rest: -3mm,
        image("../../figures/plots/circle-experiment-ldj.svg"),
      )
    ),
    {
      v(-1.75em)
      legend(handles, direction: ttb, fill: theme.base)
    }
  ),
  caption: [
  #acr("LDJ") metric for the _Circle_ scenario as the number of robots $N_R$ increases. Each value#value-swatches is averaged over five different seeds; $#equation.as-set(params.seeds)$. Corresponds with Figure 5 in @gbpplanner. C = Circle Scenario, EB = Environment Obstacles Scenario.
]
)<f.circle-experiment-ldj>

The results on both figures #numref(<f.circle-experiment-ldj>) and #numref(<f.circle-experiment-distance-travelled>), show that lowering the lookahead multiple to $l_m=1$, or lowering the time horizon to $t_(K-1)=5s$ individually obtain results that are closer to those of @gbpplanner. The best possible results for are achieved with #text(theme.lavender, $l_m=3,t_(K-1)=5s$).

#figure(
  grid(
    columns: 2,
    align: horizon,
    block(
      clip: true,
      pad(
        top: -2mm,
        right: -2mm,
        rest: -3mm,
        image("../../figures/plots/circle-experiment-distance-travelled.svg"),
      )
    ),
    {
      v(-1.75em)
      legend(handles, direction: ttb, fill: theme.base)
    }
  ),
  caption: [
    Distribution of distances travelled, as the number of robots $N_R$ increases. Each value#value-swatches is averaged over five different seeds; $#equation.as-set(params.seeds)$. Corresponds with Figure 4 in @gbpplanner. C = Circle Scenario, EB = Environment Obstacles Scenario.
  ]
)<f.circle-experiment-distance-travelled>

#pagebreak(weak: true)
The results for the Environment Obstacles scenario are shown with purple and a tag of EB in all three figures; #numref(<f.circle-experiment-ldj>), #numref(<f.circle-experiment-distance-travelled>), and #numref(<f.obstacle-experiment-makespan>). It can be seen how these results are consistently worse-
#v(-0.55em)

#let fig = [
  #v(1em)
  #figure(
    z-stack(
      pad(
        x: -4mm,
        y: -4mm,
        image("../../figures/plots/circle-experiment-makespan.svg")
      ),
      {
        set text(size: 1.1em)
        place(right + top, dy: 0.2em, dx: 0.1em, legend(handles, direction: ttb, fill: white.transparentize(40%)))
      }
    ),
    caption: [
      Comparison of makespan for the _Circle_ and _Environment Obstacles_ scenarios, as the number of robots $N_R$ increases. Each value #sl is averaged over five different seeds; $#equation.as-set(params.seeds)$. Corresponds with Figure 6 in @gbpplanner. C = Circle Scenario, EB = Environment Obstacles Scenario.
    ]
  )<f.obstacle-experiment-makespan>
]

#let body = [
  performing than the Circle scenario, and are comparable to @gbpplanner, with only a small expected descrepency.

  @f.obstacle-experiment-makespan presents the makespan results for both the Circle and Environment Obstacles scenarios. The figure shows that the makespan for #lm3-th5.n is significantly lower than for the two runs with $t_(K-1)=13.33s$. Furthermore, the makespan values for #lm3-th5.s are much closer to the corresponding values of @gbpplanner. Hence, it was deemed unnecessary to have validative results from the `gbpplanner` code itself.
]

#grid(
  columns: (1fr, 85mm),
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
// #let colors = (
//   theirs: theme.peach.lighten(20%),
//   ours: theme.lavender
// )
#let vc = table.cell.with(inset: 0.75em)
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

The _makespan_, _distance travelled_, and _LDJ_ metrics are presented in @t.network-experiment. From these numbers, the experiment with communication range of 20 meters, $r_C=20"m"$, did much worse than the other three $r_C in {40, 60, 80}m$, where the change is very minimal in all three metrics.//#note.j[Discussion: #sym.dash.en _if not negligible_.] In @t.network-experiment, results of four experiments are shown:

#term-table(
  colors: (colors.theirs, colors.theirs, colors.ours, colors.ours),
  boxed(color: colors.theirs, [*Theirs-1*]), [The results from the #gbpplanner paper@gbpplanner],
  boxed(color: colors.theirs, [*Theirs-2*]), [The results of the provided code by #gbpplanner, with the same parameters as the #gbpplanner paper; #lm3-th13.n.],
  boxed(color: colors.ours, [*Ours-1*]), [The results of #acr("MAGICS"), with the same parameters as the #gbpplanner paper; #lm3-th13.n.],
  boxed(color: colors.ours, [*Ours-2*]), [The results of #acr("MAGICS"), with tuned parameters; #lm3-th5.n.],
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

// O1
// makespan: {20: 110.84, 40: 169.78, 60: 178.6, 80: 176.23999999999998}
// distance: {20: 295.5999750811273, 40: 469.9587116164673, 60: 499.84999164026755, 80: 514.5135772497284}
// ldj:      {20: -17.5307399430643, 40: -19.511392192446536, 60: -19.940552192799846, 80: -20.232993297885482}

#figure(
  tablec(
    columns: (auto,) + range(12).map(_ => 1fr),
    alignment: center + horizon,
    header-color: (fill: theme.base, text: theme.text),
    header: table.header(
      tc(rowspan: 2, [$bold(r_C)$\ \[$bold(m)$\]]), tc(colspan: 4, [Makespan \[$bold(s)$\]]), tc(colspan: 4, [Distance Travelled \[$bold(m)$\]]), tc(colspan: 4, [LDJ \[$bold(m"/"s^3)$\]]), table.hline(), T1, T2, O1, O2, T1, T2, O1, O2, T1, T2, O1, O2
    ),
    // vc[20], table.vline(), vc[$12.0$], vc[$110.8$], vc[$46.0$], vc[$199.50$], table.vline(), vc[$104$], vc[$295.6$], vc[$236.9$], vc[$519.5$], table.vline(), vc[$-9.02$], vc[$-17.5$], vc[$-14.5$], vc[$-22.9$],
    vc[20], table.vline(), vc[$12.0$], vc[$199.50$], vc[$110.8$], vc[$46.0$], table.vline(), vc[$104$],   vc[$519.5$],  vc[$295.6$], vc[$236.9$], table.vline(), vc[$-9.02$], vc[$-22.9$], vc[$-17.5$], vc[$-14.5$],
    vc[40], vc[$12.3$], vc[$260.9$],  vc[$169.8$], vc[$64.6$], vc[$104.5$], vc[$751.1$],  vc[$470.0$], vc[$286.0$], vc[$-8.76$], vc[$-23.7$], vc[$-19.5$], vc[$-16.0$],
    vc[60], vc[$12.7$], vc[$443.3$],  vc[$178.6$], vc[$65.3$], vc[$104.0$], vc[$1551.7$], vc[$499.8$], vc[$295.3$], vc[$-8.38$], vc[$-25.3$], vc[$-19.9$], vc[$-16.3$],
    vc[80], vc[$14.8$], vc[$379.0$],  vc[$176.2$], vc[$64.6$], vc[$103$],   vc[$1069.4$], vc[$514.5$], vc[$283.2$], vc[$-8.47$], vc[$-24.9$], vc[$-20.2$], vc[$-16.1$],
  ),
  caption: [Results for the Varying Network Connectivity scenario. Shows the effect of varying communication range $r_C$ in the same environment as the Environment Obstacles scenario. Values in the #T1 column is taken from Table 1 in @gbpplanner. Column #T2 are results obtained by running the experiment in `gbpplanner`@gbpplanner-code, where #O1 and #O2 are results from #acr("MAGICS"). #O1 is with lookahead multiple $l_m=3$ and time horizon $t_(K-1)=13.33s$, where #O2 is with #lm3-th5.n. Performed over 5 different seeds; $#equation.as-set(params.seeds)$. Corresponds with Table 1 in @gbpplanner.],
)<t.network-experiment>

=== Junction <s.r.results.junction>
#let body = [
  The results of the Junction experiment are presented on a plot in @f.qin-vs-qout, similarly to how it was done in @gbpplanner. The plot shows that the input flowrate $Q_"in"$ is very close to the output flowrate $Q_"out"$ for $Q_"in" in [0, 6.5]$, where it starts deviating from the optimal flowrate at $Q_"in" = 7.5$, decreasing to an output flowrate of $Q_"out" approx 6.6$. This result is consistent with both the presented numbers in @gbpplanner and the provided `gbpplanner` code. In @t.qin-vs-qout, the raw data is presented. Here it becomes clear that the output flowrate follows the input flowrate perfectly up until $Q_"in" = 4$, where $Q_"out" = 3.98$ #sym.dash.en _and from here on $Q_"out"$ consistently deviates more and more_. These results are comparable to the results of @gbpplanner, looking at their Figure 7.
]


#let handles = (
  (
    patch: inline-line(stroke: (thickness: 2pt, paint: theme.overlay2, dash: "dotted")),
    label: [$Q_"in" = Q_"out"$],
    color: theme.overlay2,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [$60s$ Mean Flowrate],
    color: theme.lavender,
    alpha: 0%,
    space: 0em,
  ),
)

#let fig = [
  #figure(
    block(
      clip: true,
      z-stack(
        pad(
          top: -2mm,
          right: -2mm,
          rest: -3mm,
          image("../../figures/plots/qin-vs-qout.svg"),
        ),
        {
          set text(size: 1.1em)
          place(right + bottom, dy: -2.4em, dx: -0.9em, legend(handles, direction: ttb, fill: white.transparentize(40%)))
        }
      )
    ),
    caption: [
      This plot illustrates the relationship between the input flowrate $Q_"in"$ the output flowrate $Q_"out"$ robots for the Junction scenario, @s.r.scenarios.junction. The dashed dark-gray line #inline-line(stroke: (thickness: 2pt, paint: theme.overlay2, dash: "dotted")) represents the ideal scenario where $Q_"in" = Q_"out"$. The solid blue colored line with circle markers#sl indicates the average flowrate measured over a 50-second steady-state period. The results demonstrate a close approximation to the ideal flowrate, with slight deviations observed at higher flowrates. Performed over 5 different seeds; $#equation.as-set(params.seeds)$. Corresponds with Figure 7 in @gbpplanner.
    ]
  )<f.qin-vs-qout>
]

#grid(
  columns: (1fr, 80mm),
  column-gutter: 1em,
  body,
  fig
)

#let qins = (0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0)
#let qouts = (0.0, 0.508, 1.0, 1.5199999999999998, 2.0, 2.5, 3.0, 3.5, 3.9760000000000004, 4.476, 4.948, 5.452, 5.964, 6.408000000000001, 6.555999999999999)
#figure(
  {
    let header-columns = (0,)

    show table.cell : it => {
      if it.x == 0 {
        set text(white)
        it
      } else {
        it
      }
    }
    tablec(
      columns: (auto,) + range(qins.len()).map(_ => 1fr),
      alignment: center + horizon,
      fill: (x, y) => if x in header-columns { theme.lavender } else if calc.even(x) { theme.base } else { theme.mantle },
      $bold(Q_"in")$,
      ..qins.map(qin => [$#qin$]),
      $bold(Q_"out")$,
      ..qouts.map(qout => [$#strfmt("{0:.2}", qout)$]),
    )
  },
  caption: [The relationship between the input flowrate $Q_"in"$ and the output flowrate $Q_"out"$ for the Junction scenario.]
)<t.qin-vs-qout>


=== Communications Failure <s.r.results.failure>
// #jens[results from ours and their code.]
// Circle experiment: distribution of distances travelled as number of robots in the formation NR is varied. The GBP planner creates shorter paths and a smaller spread of distances than ORCA; robots collaborate to achieve their goals.
// Circle experiment: distribution of the LDJ metric as NR increases, with smoother trajectories shown by more positive values. The worst performing GBP planning robots had smoother paths than the best robots for ORCA.

Results for communications failure rates $gamma in {0, 10, 20, 30, 40, 50, 60, 70, 80, 90}%$ are shown in @t.comms-failure-experiment. Results from the #gbpplanner paper are marked #T1 and #T2, where #O1 and #O2 are results from #acr("MAGICS"). #O1 is with lookahead multiple $l_m=3$ and time horizon $t_(K-1)=13.33s$, where #O2 is with #lm3-th5.n. For $gamma in {80, 90}%$ it was deemed impossible to gather results for #acr("MAGICS"), as the rate of convergence almost without any communication resulted in exceedingly long simulation times. That fact in itself should speak to the missing numbers.

#pagebreak(weak: true)

#let gbpplanner-results = (
  rc: (0, 10, 20, 30, 40, 50, 60, 70, 80, 90),
  makespan_10: (19.5, 20.3, 22.9, 25.7, 30.8, 35.6, 42.0, 51.3, 87.4, 146.9),
  mean_collisions_10: (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.6),
  makespan_15: (14.9, 17.1, 18.9, 22.5, 26.5, 30.6, 38.8, 44.6, 63.4, 12.6),
  mean_collisions_15: (0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.8, 0.8, 0.8, 4.6),
)

// │ target_speed ┆ failure_rate ┆ makespan   │
// │ 10.0         ┆ 0.0          ┆ 86.300003  │
// │ 10.0         ┆ 0.1          ┆ 146.300003 │
// │ 10.0         ┆ 0.2          ┆ 140.199997 │
// │ 10.0         ┆ 0.3          ┆ 163.699997 │
// │ 10.0         ┆ 0.4          ┆ 157.400009 │
// │ 10.0         ┆ 0.5          ┆ 231.400009 │
// │ 10.0         ┆ 0.6          ┆ 257.200012 │
// │ 10.0         ┆ 0.7          ┆ 260.899994 │
// │ 10.0         ┆ 0.8          ┆ 362.100006 │
// │ 10.0         ┆ 0.9          ┆ 938.900024 │

// │ 15.0         ┆ 0.0          ┆ 238.600006 │
// │ 15.0         ┆ 0.1          ┆ 203.199997 │
// │ 15.0         ┆ 0.2          ┆ 329.800018 │
// │ 15.0         ┆ 0.3          ┆ 231.100006 │
// │ 15.0         ┆ 0.4          ┆ 220.800003 │
// │ 15.0         ┆ 0.5          ┆ 221.5      │
// │ 15.0         ┆ 0.6          ┆ 328.700012 │
// │ 15.0         ┆ 0.7          ┆ 505.600006 │
// │ 15.0         ┆ 0.8          ┆ 799.600037 │
// │ 15.0         ┆ 0.9          ┆ 864.600037 │

// OURS 10 lm3 th5
// │ 0.0          ┆ 21.125   │
// │ 0.1          ┆ 24.24    │
// │ 0.2          ┆ 27.1     │
// │ 0.3          ┆ 29.06    │
// │ 0.4          ┆ 33.16    │
// │ 0.5          ┆ 39.84    │
// │ 0.6          ┆ 48.4     │
// │ 0.7          ┆ 60.82    │

// OURS 15 lm3 th5
// │ 0.0          ┆ 20.3     │
// │ 0.1          ┆ 23.8     │
// │ 0.2          ┆ 26.9     │
// │ 0.3          ┆ 29.6     │
// │ 0.4          ┆ 33.5     │
// │ 0.5          ┆ 40.2     │
// │ 0.6          ┆ 48.78    │
// │ 0.7          ┆ 68.2     │

// │ 0.0          ┆ 1.2        │
// │ 0.1          ┆ 1.8        │
// │ 0.2          ┆ 6.2        │
// │ 0.3          ┆ 11.2       │
// │ 0.4          ┆ 18.2       │
// │ 0.5          ┆ 36.0       │
// │ 0.6          ┆ 41.6       │
// │ 0.7          ┆ 55.6       │

// OURS 10 lm3 th13.33
// │ 0.0          ┆ 139.06   │
// │ 0.1          ┆ 160.36   │
// │ 0.2          ┆ 179.12   │
// │ 0.3          ┆ 194.74   │
// │ 0.4          ┆ 211.86   │
// │ 0.5          ┆ 211.58   │
// │ 0.6          ┆ 222.12   │
// │ 0.7          ┆ 276.76   │

// │ 0.0          ┆ 6.0        │
// │ 0.1          ┆ 11.6       │
// │ 0.2          ┆ 27.6       │
// │ 0.3          ┆ 50.2       │
// │ 0.4          ┆ 84.6       │
// │ 0.5          ┆ 89.0       │
// │ 0.6          ┆ 111.4      │
// │ 0.7          ┆ 121.4      │

// OURS 15 lm3 th13.33
// │ 0.0          ┆ 165.26   │
// │ 0.1          ┆ 190.64   │
// │ 0.2          ┆ 207.22   │
// │ 0.3          ┆ 189.68   │
// │ 0.4          ┆ 215.98   │
// │ 0.5          ┆ 235.92   │
// │ 0.6          ┆ 251.62   │
// │ 0.7          ┆ 363.22   │

// │ 0.0          ┆ 7.4        │
// │ 0.1          ┆ 12.0       │
// │ 0.2          ┆ 33.6       │
// │ 0.3          ┆ 47.8       │
// │ 0.4          ┆ 68.0       │
// │ 0.5          ┆ 107.2      │
// │ 0.6          ┆ 118.8      │
// │ 0.7          ┆ 136.8      │
#let d = sym.dash.en
#figure(
  tablec(
    columns: range(15).map(_ => 1fr),
    alignment: center + horizon,
    // stroke: gray,
    header-color: (fill: theme.base, text: theme.text),
    header: table.header(
      tc(colspan: 1, [$bold(|v_0|)$]), tc(colspan: 7, $bold(10m"/"s)$), tc(colspan: 7, $bold(15m"/"s)$), table.hline(),
      tc(rowspan: 2, $bold(gamma)$), tc(colspan: 4, [MS $s$]), tc(colspan: 3, [C]), tc(colspan: 4, [MS $s$]), tc(colspan: 3, [C]), table.hline(),
      ..range(2).map(_ => (T1, T2, O1, O2, T1, O1, O2)).flatten(),
    ),
    // $0$, table.vline(), $19.5$, oc[], vc[$21.1$], vc[$86.3$], table.vline(), $0$, oc[], vc[$0.5$], table.vline(), $14.9$, oc[], vc[$20.3$], vc[$238.6$], table.vline(), $0$, oc[], vc[$1.2$],
    $0$,  table.vline(), $19.5$,  vc[$86.3$],  vc[$139.1$],   vc[$21.1$], table.vline(), $0$,   vc[$6.0$],   vc[$0.5$], table.vline(), $14.9$, vc[$238.6$], vc[$165.3$],   vc[$20.3$], table.vline(), $0$, vc[$7.4$],   vc[$1.2$],
    $10$, $20.3$,  vc[$146.3$], vc[$160.4$],   vc[$24.2$], $0$,   vc[$11.6$],   vc[$1.8$],  $17.1$, vc[$203.2$],  vc[$190.6$],   vc[$23.8$], $0$,   vc[$12.0$],   vc[$1,8$],
    $20$, $22.9$,  vc[$140.2$], vc[$179.1$],   vc[$27.1$], $0$,   vc[$27.6$],   vc[$6.8$],  $18.9$, vc[$329.8$],  vc[$207.2$],   vc[$26.9$], $0$,   vc[$33.6$],   vc[$6.2$],
    $30$, $25.7$,  vc[$163.7$], vc[$194.7$],   vc[$29.1$], $0$,   vc[$50.2$],   vc[$11.0$], $22.5$, vc[$231.1$],  vc[$189.7$],   vc[$29.6$], $0$,   vc[$47.8$],   vc[$11.2$],
    $40$, $30.8$,  vc[$157.4$], vc[$211.9$],   vc[$33.2$], $0$,   vc[$84.6$],   vc[$18.4$], $26.5$, vc[$220.8$],  vc[$216.0$],   vc[$33.5$], $0$,   vc[$68.0$],   vc[$18.2$],
    $50$, $35.6$,  vc[$231.4$], vc[$211.6$],   vc[$39.8$], $0$,   vc[$89.0$],   vc[$33.0$], $30.6$, vc[$221.5$],  vc[$235.9$],   vc[$40.2$], $0.2$, vc[$107.2$],   vc[$36.0$],
    $60$, $42$,    vc[$257.2$], vc[$222.1$],   vc[$48.4$], $0$,   vc[$11.4$],   vc[$39.6$], $38.8$, vc[$328.7$],  vc[$251.6$],   vc[$48.8$], $0.8$, vc[$118.8$],   vc[$41.6$],
    $70$, $51.3$,  vc[$260.9$], vc[$276.8$],   vc[$60.8$], $0$,   vc[$121.4$],   vc[$51.8$], $44.6$, vc[$505.6$], vc[$363.2$],   vc[$68.2$], $0.8$, vc[$136.8$],   vc[$55.6$],
    $80$, $87.4$,  vc[$362.1$], vc[#d], vc[#d],     $0$,   vc[#d], vc[#d],     $63.4$, vc[$799.6$], vc[#d], vc[#d],     $0.8$, vc[#d], vc[#d],
    $90$, $146.9$, vc[$938.9$], vc[#d], vc[#d],     $1.6$, vc[#d], vc[#d],     $12.6$, vc[$864.6$], vc[#d], vc[#d],     $4.6$, vc[#d], vc[#d],
  ),
  caption: [
    Communications Failure experiment results. Results pertaining to #acr("MAGICS") are marked #O1 and #O2. #O1 is with lookahead multiple $l_m=3$, and time horizon $t_(K-1)=13.33s$, where #O2 is with #lm3-th5.n. Values in column #T1 is taken from Table 2 in @gbpplanner, where #T2 columns are results obtained from the `gbpplanner`@gbpplanner-code with #lm3-th13.n. Cells marked with a dash, #sym.dash.en, had a very low rate of convergence as so few interrobot messages were shared, and thus were not measurable. Corresponds with Table 2 in @gbpplanner.
  ]
)<t.comms-failure-experiment>

// THEIR CAPTION
// shows that as γ increases, it takes longer for all robots to reach their goals. However, trajectories for the 10 m/s case are completely collision free up to γ = 80%. As the initial speed increases, collisions happen at lower values of γ as robots have less time to react to faster moving neighbours who they may not be receiving messages from. This experiment shows one of the benefits of GBP — safe trajectories can still be planned even with possible communication failures, which is likely in any realistic settings.
