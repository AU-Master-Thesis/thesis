#import "../../lib/mod.typ": *
== #study.H-2.full.n <s.r.study-2>

#todo[talk about this section not as enhancement but as ablation study]

// #k[
//   Construct experiment that test the effect of varying the number of variables.
//   Especially for sharp corners like 90 degree turns in the junction.
// ]

=== Schedules


#line(length: 100%, stroke: 1em + red)

// interleave evenly
// soon as possible
// late as possible
// half at beginning, half at end
// centered

#let handles = (
  (
    label: [*Centered*],
    color: theme.mauve,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [*Half Start, Half End*],
    color: theme.maroon,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [*Interleave Evenly*],
    color: theme.yellow,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [*Late as Possible*],
    color: theme.teal,
    alpha: 0%,
    space: 1em,
  ),
  (
    label: [*Soon as Possible*],
    color: theme.lavender,
    alpha: 0%,
    space: 0em,
  ),
)

#let schedules-legend = legend(
  handles,
  direction: ttb,
  fill: theme.base
)

#figure(
  grid(
    columns: 2,
    align: horizon,
    block(
      clip: true,
      pad(
        x: -3mm,
        y: -3mm,
        image("../../figures/plots/schedules-experiment-ldj.svg"),
      ),
    ),
    schedules-legend
  ),
  caption: [ldj]
)


#figure(
  // image("../../figures/plots/schedules-experiment-makespan.svg"),
  grid(
    columns: 2,
    align: horizon,
    block(
      clip: true,
      pad(
        x: -3mm,
        y: -3mm,
        image("../../figures/plots/schedules-experiment-makespan.svg"),
      ),
    ),
    schedules-legend
  ),
  caption: [makespan]
)

#figure(
  // image("../../figures/plots/schedules-experiment-distance-travelled.svg"),
  grid(
    columns: 2,
    align: horizon,
    block(
      clip: true,
      pad(
        x: -3mm,
        y: -3mm,
        image("../../figures/plots/schedules-experiment-distance-travelled.svg"),
      ),
    ),
    schedules-legend
  ),
  caption: [distance travelled]
)



=== Iteration Amount

#line(length: 100%, stroke: 1em + red)

// #let cropping = -4mm
#let cropping = 0mm
#figure(
  grid(
    columns: 2,
    align: center + horizon,
    row-gutter: -2em,
    block(
      clip: true,
      pad(
        x: cropping,
        y: cropping,
        image("../../figures/plots/iteration-amount-average-ldj.svg"),
      ),
    ),
    block(
      clip: true,
      pad(
        x: cropping,
        y: cropping,
        image("../../figures/plots/iteration-amount-average-makespan.svg"),
      ),
    ),
    block(
      clip: true,
      pad(
        x: cropping,
        y: cropping,
        image("../../figures/plots/iteration-amount-average-distance-travelled.svg"),
      ),
    ),
    block(
      clip: true,
      pad(
        x: cropping,
        y: cropping,
        image("../../figures/plots/iteration-amount-largest-time-differense.svg"),
      ),
    ),
  ),
  caption: [ldj, makespand, distance travelled, finished $Delta t$]
)


// #figure(
//   [],
//   caption: []
// )<s.r.study-2>

// #kristoffer[
// - Expect Soon as Possible and Late as Possible to be the same, as they are identical, only different in their offset/phase
// - Same for Centered and Half at the beginning, Half at the end, as they exhibit the same symmetry
//
// - Expect Interleave Evenly to perform the best, as the computation is the most evenly distributed in time
// ]
