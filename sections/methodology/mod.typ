#import "../../lib.typ": *
= Methodology <methodology>

#include "language.typ"
#include "architecture.typ"
#include "global-planning.typ"
#include "graph-representation.typ"


#kristoffer[talk about design of different config format design, especially `formation` and `environment`

show examples of them, and how they allow for flexibly and declaratively define new simulation scenarios

  ```yaml
  formations:
  - repeat-every:
      secs: 8
      nanos: 0
    delay:
      secs: 2
      nanos: 0
    robots: 1
    initial-position:
      shape: !line-segment
      - x: 0.45
        y: 0.0
      - x: 0.55
        y: 0.0
      placement-strategy: !random
        attempts: 1000
    waypoints:
    - shape: !line-segment
      - x: 0.45
        y: 1.25
      - x: 0.55
        y: 1.25
      projection-strategy: identity
  ```
]

#jens[
  === Asynchronous Message Passing <s.b.asynchronous-message-passing>
]




// #import "@preview/codelst:2.0.1": sourcecode
//
// #sourcecode[```typ
// #show "ArtosFlow": name => box[
//   #box(image(
//     "logo.svg",
//     height: 0.7em,
//   ))
//   #name
// ]
//
// This report is embedded in the
// ArtosFlow project. ArtosFlow is a
// project of the Artos Institute.
// ```]


#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  List out all the configuration parameters both the algorithm exposes and the sim. Which one is identical to gbpplanner, and what values are sensible to use as defaults
]


#let variable_timesteps(lookahead_multiple, lookahead_horizon) = {
  let n = 1 + (0.5 * (-1.0 + calc.sqrt(1.0 + 8.0 * lookahead_horizon / lookahead_multiple)))
  let n = calc.floor(n)

  let timesteps = ()

  for i in range(lookahead_multiple * (n + 1)) {
    let section = i / lookahead_multiple
    let f = (lookahead_multiple / 2.0) * section + (section * -lookahead_multiple + i) * (section + 1.0)

    if f >= lookahead_horizon {
      timesteps.push(lookahead_horizon)
  break
    }

    timesteps.push(f)


  }

  timesteps

}

#variable_timesteps(20, 3)

// #{
//   import "@preview/cetz:0.2.2": canvas, plot
//
//
// canvas(length: 1cm, {
//   plot.plot(size: (8, 6),
//     x-tick-step: none,
//     x-ticks: ((-calc.pi, $-pi$), (0, $0$), (calc.pi, $pi$)),
//     y-tick-step: 1,
//     {
//       plot.add(
//         style: style,
//         domain: (-calc.pi, calc.pi), calc.sin)
//       plot.add(
//         hypograph: true,
//         style: style,
//         domain: (-calc.pi, calc.pi), calc.cos)
//       plot.add(
//         hypograph: true,
//         style: style,
//         domain: (-calc.pi, calc.pi), x => calc.cos(x + calc.pi))
//     })
// })
//
// }
