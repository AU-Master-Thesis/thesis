#import "../../../lib/mod.typ": *
== #study.H-1.full.n <s.m.study-1>

// This section will cover the approach chosen for reproducing the software implementation in the gbpplanner paper@gbpplanner. Focus is put on arguing for places where the internal workings of the reimplementation differs. Why the difference is either deemed necessary due to inherent differences in the capabilities of the programming languages, or why they are seen as desireable/ an improvement. Where multiple different solutions are feasible to solve the same issue comparative arguments are presented to reason for the selected solution.

// #jonas[Do you think it is very important in these "Study" (or "Contribution" as Andryi might want us to call it) which Hypothesis it tries to answer, even though it is made clear earlier that Study 1 = Hypothesis 1]

// This sections outlines the methodology for the fourth study; #study.H-4.name. Firstly, @s.m.configuration describes how the simulation tool, environment, and robot spawning has been parameterised through several configuration files. Thereafter, @s.m.simulation-tool details the developed simulation tool itself, and how to interact with it.

#jonas[The ordering of these subsections might be confusing as the merge has been done somewhat crudely. No need to read it all again, but it would be nice to get feedback on what order to do what in. The configuration and tooling/user experience aspects first or the reproduction aspects?]

The methodology for developing an extensive simulation tool is outlined in this section. It is described how this tool is made capable of replicating the software implementation described in the gbpplanner paper@gbpplanner. The section details the differences in the reimplementation, justifying necessary deviations due to distinct capabilities or limitations of the programming language used as well as libraries, and explaining the improvements made. For issues where multiple solutions are viable, comparative analyses are provided to justify the choice of the selected solution. As such _Research Objectives_ #boxed(color: theme.teal, [*O-1.1.1*]) through #boxed(color: theme.teal, [*O-1.6.1*]) are addressed in this section. The extensive usability and configurability improvements are described in sections #numref(<s.m.configuration>) and #numref(<s.m.simulation-tool>), respectively.

#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non-measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  List out all the configuration parameters both the algorithm exposes and the sim. Which one is identical to gbpplanner, and what values are sensible to use as defaults
]

#include "configuration.typ"
#include "simulation.typ"
#include "factors.typ"
#include "language.typ"
#include "architecture.typ"
#include "graph-representation.typ"


=== Variable Structure <s.variable-structure>




- maintains two sets of ids, one for any robot within communication radius, and one for any robot connected with.





- Fixed number of variable settings
- Trait



Variable Timesteps






#figure(
  image("../../../figures/out/variable-timesteps.svg"),
  caption: [Variable timesteps, #kristoffer[explain figure, and review design, use same variable names as rest of document]]
) <f.variable-timesteps>

#kristoffer[
  Explain how we have added a setting to decouple the number of variables from the velocity and time horizon of the robot.
]


=== Factor Structure <s.factor-structure>

In #gbpplanner, the different factor variants are implemented as separate classes that inherit from a `Factor` base class. Rust does not support inheritance as found in #acr("OOP") based languages like C++. Instead composition and traits are used for subtyping@the-rust-book. The `Factor` trait, as seen in @listing.factor-trait is designed to group all requirements expected of any factor variant used in the factorgraph.

#listing([
```rust
trait Factor: std::fmt::Display {
  fn neighbours(&self) -> NonZeroU32;
  fn skip(&self, state: &FactorState) -> bool;
  fn measure(&self, state: &FactorState, lin_point: &Vector<f64>) -> Measurement;
  fn jacobian(&self, state: &FactorState, lin_point: &Vector<f64>) -> Cow<'_, Matrix<f64>>;
  fn jacobian_delta(&self) -> StrictlyPositiveFinite<f64>;
  fn first_order_jacobian(&self, state: &FactorState, lin_point: Vector<f64>) -> Matrix<f64> { ... }
}
```
],
caption: [
  The `Factor` trait, used by the factor graph to abstract the different types of factors.
  Found in #gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/mod.rs#L60", "src/factorgraph/factor/mod.rs:60")
]
) <listing.factor-trait>

- `neighbours()`: How many neighbouring variables the factor is connected to. `NonZeroU32` is a standard library type representing the interval $[1, 2^(32-1)]$, to prevent implementors from  returning $0$, which would represent an invalid state, since a factorgraph cannot be disconnected.

- `skip()`: Whether the factor should be skipped during factor iteration. This is used by factors for which it might not make sense to be active all the time. The interrobot factors uses it to skip participation when estimated positions of the two variables it is connected with are further apart than $d_r$ as explained in @s.m.factors.interrobot-factor. Tracking factors uses it to deactivate while the global planner asynchronously tries to find a path #todo[ref].

- `measure()`: The measurement function $m(X_k)$ used in the factor potential update step as described in @s.b.gbp.factor-update.

- `jacobian()`: The Jacobian of the factor. Used in the factor potential update step as described in @s.b.gbp.factor-update. To minimize repeated heap allocation of matrices #acr("CoW") semantics are used by wrapping the returned matrix in the `Cow<'_, _>` container@the-rust-book. With this implementors can opt to return a reference to an already allocated matrix they own, instead of a new copy of it. The dynamics factor makes use of this optimization as its Jacobian is precomputed once at initialization, and does not depend on the input linearization point #footnote([Found in the #gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/dynamic.rs#L67-L70", "src/factorgraph/factor/dynamic.rs:67-70")]).


- `jacobian_delta()`: The $delta$ used in the Jacobian first order derivative approximation calculation. `StrictlyPositiveFinite<f64>` is used to enforce that the returned value lies in the $RR_+ \\ {0, infinity}$ interval representable by the IEEE 754 double precision encoding. To prevent floating point errors from dividing by $0.0$ or $infinity$#jens[right argument?].

- `first_order_jacobian()`: The first order Jacobian of the factor. This method comes with a default implementation that used the `jacobian()` and `jacobian_delta()` implementation using the finite difference method as defined in @s.m.factors.jacobian-first-order.


The `Display` trait is added as a requirement for the `Factor` trait to enforce the introspection abilities built into the simulator for when a variable is clicked on with the mouse cursor. See @s.m.s4.debugging-tools for this.

The `&FactorState` argument passed by reference to `jacobian()`, `measure()`, and `first_order_jacobian()` is a structure containing common data associated with all factors such as its measurement precision matrix $Lambda_M$ and the factors initial measurement $m(X_0)$, see @s.b.gbp.factor-update. This is necessary as traits only makes it possible to be generic over behaviour and not state as can be done with inheritance. While it moves the responsibility of tracking this state to the caller, it was deemed preferable over having each implementor copy the same fields manually.
All factor implementations are grouped together in a tagged union called `FactorKind`#footnote[Found in the
#gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/mod.rs#L481-L495", "src/factorgraph/factor/mod.rs:481-495")
] to enable static dispatch when the code is compiled instead of dynamic dispatch. Using static dispatch is less flexible in terms of extensibility as all implementors has to be known by the library at compile time. But allows for better performance as the compiler can better optimise and possibly inline method calls@the-rust-book. Which is important as these methods has to run in the hot code path of the simulation.

// - Explain the `Cow<>` return type. Performance improve for factors that has a static Jacobian like the dynamic factor


// #kristoffer[
//   Explain how factors are abstracted using the `Factor` trait.
//   How our implementation uses Composition instead of inheritance in C++
//     - What pros/cons does this bring?
// ]
