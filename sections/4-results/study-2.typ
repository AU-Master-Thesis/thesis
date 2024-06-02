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
  caption: [#acr("LDJ")]
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
  caption: [Makespan]
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
  caption: [Distance travelled]
)


#pagebreak()

=== Iteration Amount

@f.iteration-amount-plots shows the results of the experiment, across four different metrics. A clear pattern shared across all four is that internal iteration $M_I = 1$ and external iteration $M_R = 1$, is not enough to properly solve for the optimum across the factorgraphs. Another general trend is that as both $M_I$ and $M_R$ the quality of each metric improves. With both the #acr("LDJ") and Makespan metric the 2D gradient is clear to see, with both a high $M_I$ and $M_R$ needed to reach the optimum. For the "Distance Travelled" metric only a couple of iterations are needed to reach the optimum plateou. "Finished at Difference" shows a more noisy histogram, with values fluctuating a lot more for $M_I < 10 and M_R < 10$.\
All four metrics clearly shows that a large $M_R$ when $M_I in [1,2]$ is severely detrimental.

// - exponentially more
//
// performs significantly poorer than any of the other combinations. As both $M_I$ and $M_R$ increase each metric quickly converges toward an optimum plateau, from which no further increase appears to result in an improvement. Across all metrics performance is generally suboptimal when $M_I = 1 and M_R > 1$ or $M_I > 1 and M_R$. Although for $M_I in  {5, 13, 21} and M_R = 1 or M_I = 1 and M_R = {5, 13, 21}$ no drawback appears. \
// Both the distance travelled metric and finished at difference contains noticeable outliers at $M_I = 8 and M_R = 1$ and $M_I = 3 and M_R = 1$ respectively. Contrary to both the #acr("LDJ") and makespan 
//
// Although for the #acr("LDJ"), makespan and finished at difference, $5, 13, 21$ 
//
// #line(length: 100%, stroke: 1em + red)
//
// - that multiple iterative steps are required
//
// - repeating pattern of ... slightly worse results
//
// // best performance is achieved if both $M_I$ and $M_R$ a
//
//
// Across all metrics, lower values of external iterations ($M_R$) consistently lead to poorer performance.
// Increasing internal iterations ($M_I$) generally enhances performance, but optimal results are achieved with a combination of higher values for both $M_I$ and $M_R$.
//
// A first observation is that the 



#let cell(c) = box(rect(height: 0.7em, width: 0.7em, stroke: c, fill: c), baseline: 0.05em)

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
  caption: [
    Results of varying internal iteration $M_I$ and external $M_R$ split across four metrics: #acr("LDJ"), makespan, distance travelled, and largest time difference. Each metric is plotted as a 2D histogram with the $x$ and $y$-axis being $M_I$ and $M_R$ respectively. The gradient colors are chosen such that the peach colored end of the spectrum are cells #cell(theme.peach) which performed poorly for that metric. While lavender #cell(theme.lavender) indicates cells with good metric values.
  ]
) <f.iteration-amount-plots>

