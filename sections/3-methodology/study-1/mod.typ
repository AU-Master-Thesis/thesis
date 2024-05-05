#import "../../../lib.typ": *
== #study.H-1.full.n <s.r.study-1>

#include "language.typ"
#include "architecture.typ"
#include "graph-representation.typ"



#jens[
  === Asynchronous Message Passing <s.b.asynchronous-message-passing>
]


#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non-measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  List out all the configuration parameters both the algorithm exposes and the sim. Which one is identical to gbpplanner, and what values are sensible to use as defaults
]

#figure(
  image("../../../figures/out/variable-timesteps.svg"),
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
