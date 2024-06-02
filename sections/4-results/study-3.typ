#import "../../lib/mod.typ": *
== #study.H-3.full.n <s.r.study-3>

The results for the two scenarios; #scen.solo-gp.n and #scen.collaborative-gp.n, are presented in @s.r.study-3.solo-global and @s.r.study-3.collaborative-global respectively. These experiments belong to the third contribution of this thesis, which corresponds to the third hypothesis, #study.H-3.box.

=== Solo Global Planning <s.r.study-3.solo-global>
#jens[Global Planning without $f_t$ vs Global Planning with $f_t$]

#jens[Isolted waypoint tracking vs path tracking for a single robot. Will show how much the robot deviates from the path.]

The path adherence is shown in @f.solo-plot, and @f.solo-box, where we can see how the tracking factor has lowered the path-deviation error across the board.

#let fig-deviation = [
  #figure(
    block(
      clip: true,
      pad(
        y: -4mm,
        x: -4mm,
        image("../../figures/plots/solo-gp-deviation.svg"),
      ),
    ),
    caption: [Path deviation error.]
  )<f.solo-plot>
]

#let fig = [
  #figure(
    block(
      clip: true,
      pad(
        y: -4mm,
        x: -4mm,
        image("../../figures/plots/solo-gp.svg"),
      ),
    ),
    caption: [Path deviation error.]
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
    },
    caption: [Mean, standard deviation, minimum, and maximum path deviation error for tracking factors disabled in the first column and enabled in the second.]
  )<t.solo-stats>
]

#grid(
  columns: (1fr, 73mm),
  column-gutter: 1em,
  fig,
  tab,
  fig-deviation
)

=== Collaborative Global Planning <s.r.study-3.collaborative-global>
// #jens[Effect of tracking factor on ability to avoid each other]

// #jens[Waypoint tracking vs path tracking and their effects on collissions vs path adherence.]

The box plots in @f.collaborative-box show the path deviation error for the waypoint tracking approach explained in @s.m.planning.waypoint-tracking, and for the path tracking approach explained in @s.m.planning.path-tracking. For the path tracking approach, two different values for the certainty of the tracking factor are used, see @eq.sigma-t.

$ sigma_t = 0.15#h(1em)"and"#h(1em)sigma_t = 0.5 $<eq.sigma-t>.

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
          [Stat], [NT], [$sigma_t=0.15$], [$sigma_t=0.5$]
        ),
        [*Mean*], [1.00], [0.86], [0.99],
        [*Std. Dev.*], [0.23], [0.25], [0.21],
        [*Min*], [6.53e-8], [6.53e-8], [6.49e-8],
        [*Max*], [1.46], [1.46], [1.53]
      )
    },
    caption: [Mean, standard deviation, min, and max path deviation error for tracking factors disabled in the first column and enabled in the second. NT = No Tracking.]
  )<t.collaborative-stats>
]

#grid(
  columns: (1fr, 66mm),
  column-gutter: 1em,
  fig,
  tab
)
