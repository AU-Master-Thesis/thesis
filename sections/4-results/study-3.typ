#import "../../lib/mod.typ": *
== #study.H-3.full.n <s.r.study-3>

The results for the two scenarios; #scen.solo-gp.n and #scen.collaborative-gp.n, are presented in @s.r.study-3.solo-global and @s.r.study-3.collaborative-global respectively. These experiments belong to the third contribution of this thesis, which corresponds to the third hypothesis, #study.H-3.box.

=== Solo Global Planning <s.r.study-3.solo-global>

The results of the #scen.solo-gp.n scenario are shown as box plots in @f.solo-box, which clearly shows a reduction in path deviation when the tracking factor is used. The mean path deviation#h(1fr)error#h(1fr)is#h(1fr)reduced#h(1fr)from#h(1fr)1.03#h(1fr)to#h(1fr)0.74#h(1fr)when#h(1fr)the#h(1fr)tracking#h(1fr)factor#h(1fr)is#h(1fr)enabled,#h(1fr)which#h(1fr)is#h(1fr)a
#v(-0.65em)

#let body = [
  // The path adherence is shown in @f.solo-plot, and @f.solo-box, where we can see how the tracking factor has lowered the path-deviation error across the board.

  $tilde.op#strfmt("{0:.0}", solo-gp-mean-decrease)%$ improvement. @t.solo-stats presents some raw statics, where it is easy to make out, not only the decrease in mean path deviation error but also a reduction in variance as shown by the standard deviation.

  Since the improvement is slightly intangible, the paths driven by the robots are visualised in @f.solo-plot. The blue#sl robot is using the waypoing tracking approach, which the green robot is equipped with path tracking. The figure shows how the tracking factor has kept the green robot much closer to the planned path, which is visualised in grey#swatch(theme.text). This is especially evident in the sharp turns, where the blue robot deviates significantly, both before and after the turn.
]

#let fig-deviation = [
  #figure(
    block(
      clip: true,
      pad(
        y: -3.5mm,
        x: -4mm,
        image("../../figures/plots/solo-gp-deviation.svg"),
      ),
    ),
    caption: [The paths of the robot with no tracking factors is shown as a blue line #inline-line(stroke: theme.lavender + 2pt), and a robot with tracking factors as a green line #inline-line(stroke: theme.green + 2pt). Underneath the planned path is visualised in grey #inline-line(stroke: theme.text + 2pt).]
  )<f.solo-plot>
]

#let fig = [
  #figure(
    block(
      clip: true,
      pad(
        y: -4mm,
        x: -3.5mm,
        image("../../figures/plots/solo-gp.svg"),
      ),
    ),
    caption: [Box plots showing the path deviation error when the tracking factor is disabled as "No Tracking"#sl, and enabled as "Tracking"#sg.]
  )<f.solo-box>
]

// No tracking:
// │ mean       ┆ 1.032871 │
// │ std        ┆ 0.108944 │
// │ min        ┆ 0.92563  │
// │ 25%        ┆ 0.94813  │
// │ 50%        ┆ 1.028276 │
// │ 75%        ┆ 1.062415 │
// │ max        ┆ 1.199902 |

// Tracking:
// │ mean       ┆ 0.739331 │
// │ std        ┆ 0.078216 │
// │ min        ┆ 0.674259 │
// │ 25%        ┆ 0.67759  │
// │ 50%        ┆ 0.71177  │
// │ 75%        ┆ 0.77322  │
// │ max        ┆ 0.859816 │

#let data = (
  no-tracking: (
    mean: 1.032871,
    std: 0.108944,
    min: 0.92563,
    max: 1.199902
  ),
  tracking: (
    mean: 0.739331,
    std: 0.078216,
    min: 0.674259,
    max: 0.859816
  )
)

#let tab = [
  #figure(
    {
      tablec(
        columns: 3,
        alignment: (x, y) => (left, center, center).at(x),
        header: table.header(
          [Stat], [No Tracking], [With Tracking]
        ),
        [*Mean*], [1.03], [0.74],
        [*Std. Dev.*], [0.11], [0.08],
        [*Min*], [0.93], [0.67],
        [*Max*], [1.20], [0.86]
      )
      v(4mm)
    },
    caption: [Mean, standard deviation, minimum, and maximum path deviation error for tracking factors disabled in the first column and enabled in the second.]
  )<t.solo-stats>
]

#grid(
  columns: (1fr, 73mm),
  gutter: 1em,
  body,
  fig-deviation,
  fig,
  v(5mm) + tab,
)

=== Collaborative Global Planning <s.r.study-3.collaborative-global>
// #jens[Effect of tracking factor on ability to avoid each other]

// #jens[Waypoint tracking vs path tracking and their effects on collissions vs path adherence.]

The results for the #scen.collaborative-gp.n scenario are presented similarly to those of the solo scenario above. The box plots in @f.collaborative-box show the path deviation error for the waypoint tracking approach explained in @s.m.planning.waypoint-tracking, and for the path tracking approach explained in @s.m.planning.path-tracking. For the path tracking approach, two different values for the certainty of the tracking factor are used, see @eq.sigma-t.

$ sigma_t = 0.15#h(1em)"and"#h(1em)sigma_t = 0.5 $<eq.sigma-t>

// Similar nothions as to the solo scenario
Once again the tracking factor has a significant impact on the mean path deviation, this time reducing by $#strfmt("{0:.0}", collaborative-gp-mean-decrease)%$ for the same tracking factor certainty of $sigma_t = 0.15$ versus the pure waypoint tracking approach with no tracking factors at all. Furthmore, with a lower certainty where $sigma_t = 0.5$, the mean path deviation error is increased once again to basically match waypoint tracking in the mean, but a standard deviation which is a negligible $0.02$ lower, see @t.collaborative-stats.


#let fig = [
  #figure(
    block(
      clip: true,
      pad(
        y: -4mm,
        x: -4mm,
        image("../../figures/plots/collaborative-gp.svg"),
      ),
    ),
    caption: [Box plots for each of the three configurations: Tracking factors diabled#sl, and for tracking factors enabled, respectively with a certainty of $sigma_t = 0.15$#stl, and $sigma_t = 0.5$#sg.]
  )<f.collaborative-box>
]

// No tracking
// │ mean       ┆ 1.003978  │
// │ std        ┆ 0.230388  │
// │ min        ┆ 6.5345e-8 │
// │ 25%        ┆ 0.898321  │
// │ 50%        ┆ 1.042123  │
// │ 75%        ┆ 1.153165  │
// │ max        ┆ 1.464897  │

// Sigma 0.15
// │ mean       ┆ 0.855876  │
// │ std        ┆ 0.247935  │
// │ min        ┆ 6.5345e-8 │
// │ 25%        ┆ 0.695161  │
// │ 50%        ┆ 0.842916  │
// │ 75%        ┆ 1.045296  │
// │ max        ┆ 1.464897  │

// Sigma 0.5
// │ mean       ┆ 0.98681   │
// │ std        ┆ 0.212813  │
// │ min        ┆ 6.4935e-8 │
// │ 25%        ┆ 0.889289  │
// │ 50%        ┆ 1.008476  │
// │ 75%        ┆ 1.131919  │
// │ max        ┆ 1.533094  │

#let tab = [
  #figure(
    {
      tablec(
        columns: 4,
        alignment: (x, y) => (left, center, center, center).at(x),
        header: table.header(
          [Stat], [NT], [$bold(sigma_t=0.15)$], [$bold(sigma_t=0.5)$]
        ),
        [*Mean*], [1.00], [0.86], [0.99],
        [*Std. Dev.*], [0.23], [0.25], [0.21],
        [*Min*], [0.00], [0.00], [0.00],
        [*Max*], [1.46], [1.46], [1.53],
        [*Collisions*], [2.8], [11.9], [3.4],
      )
      v(6mm)
    },
    caption: [Mean, standard deviation, min, and max path deviation error for tracking factors disabled in the first column and enabled in the second and third. The last row contains the mean number of collisions. NT = No Tracking.]
  )<t.collaborative-stats>
]

#grid(
  columns: (1fr, 66mm),
  column-gutter: 1em,
  fig,
  v(1.65mm) + tab
)
