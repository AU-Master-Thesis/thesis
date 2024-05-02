#import "../../lib.typ": *
= Methodology <methodology>

#include "language.typ"
#include "architecture.typ"
#include "global-planning.typ"
#include "graph-representation.typ"
#include "iteration-schedules.typ"


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


  use this to argue on a non-measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  List out all the configuration parameters both the algorithm exposes and the sim. Which one is identical to gbpplanner, and what values are sensible to use as defaults
]

Patwardhan _et al_.

#figure(
  image("../../figures/out/variable-timesteps.svg"),
  caption: [Variable timesteps, #kristoffer[explain figure, and review design, use same variable names as rest of document]]
) <f.variable-timesteps>


#kristoffer[
  Explain the marginalization step/ algorithm
  They do explain it at ALL in the paper so, we need another citation for it
  Maybe make a figure, or some colorful equations to explain the step/slices
]

#kristoffer[
  Explain how factors are abstracted using the `Factor` trait.
  How our implementation uses Composition instead of inheritance in C++
    - What pros/cons does this bring?
]

```rust
trait Factor {
  /// Name of the factor. Useful for debugging purposes
  fn name(&self) -> &'static str;
  /// Number of neighbours this factor expects
  fn neighbours(&self) -> usize;
  /// Whether the factor is linear or non-linear
  fn linear(&self) -> bool;
  /// The delta for the jacobian calculation
  fn jacobian_delta(&self) -> f64;
  /// The jacobian of the factor
  fn jacobian(&self, state: &FactorState, x: &Vector<f64>) -> Cow<'_, Matrix<f64>>;
  /// Measurement function
  fn measure(&self, state: &FactorState, x: &Vector<f64>) -> Vector<f64>;
  /// First order jacobian (provided method)
  fn first_order_jacobian(&self, state: &FactorState, x: Vector<f64>) -> Matrix<f64> { ... }
}
```


Scheduling, order in which we call internal and external iteration

#{
  let iterations = (
    internal: 10,
    external: 10,
  )

  let interleave-evenly(..times) = {
    let times = times.pos()
    assert(times > 0, message: "#times must be > 0")
    let max = times.max()
    let increments = times.map(x => max / x)
    let state = range(times.len()).map(_ => 0.0)

  }
}
