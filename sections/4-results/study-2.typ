#import "../../lib/mod.typ": *
== #study.H-2.full.n <s.r.study-2>

#todo[talk about this section not as enhancement but as ablation study]

// #k[
//   Construct experiment that test the effect of varying the number of variables.
//   Especially for sharp corners like 90 degree turns in the junction.
// ]

=== Schedules

#figure(
  image("../../figures/plots/schedules-experiment-ldj.svg"),
  caption: [ldj]
)


#figure(
  image("../../figures/plots/schedules-experiment-makespan.svg"),
  caption: [makespan]
)

#figure(
  image("../../figures/plots/schedules-experiment-distance-travelled.svg"),
  caption: [distance travelled]
)



=== Iteration Amount

#figure(
  image("../../figures/plots/iteration-amount-average-ldj.svg"),
  caption: [ldj]
)


#figure(
  image("../../figures/plots/iteration-amount-average-makespan.svg"),
  caption: [makespan]
)


#figure(
  image("../../figures/plots/iteration-amount-average-distance-travelled.svg"),
  caption: [distance travelled]
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
