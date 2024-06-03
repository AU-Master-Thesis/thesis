#import "../../../lib/mod.typ": *

=== Factor Structure <s.m.factor-structure>
// #jonas[I don't remember if you have seen this?]

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
  Found in the #gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/mod.rs#L60", "src/factorgraph/factor/mod.rs:60")
]
) <listing.factor-trait>

- `neighbours()`: How many neighbouring variables the factor is connected to. `NonZeroU32` is a standard library type representing the interval $[1, 2^(32-1)]$, to prevent implementors from  returning $0$, which would represent an invalid state, since a factorgraph cannot be disconnected.

- `skip()`: Whether the factor should be skipped during factor iteration. This is used by factors for which it might not make sense to be active all the time. The interrobot factors uses it to skip participation when estimated positions of the two variables it is connected with are further apart than $d_r$ as explained in @s.m.factors.interrobot-factor. Tracking factors uses it to deactivate while the global planner asynchronously tries to find a path, see @s.m.global-planning.

- `measure()`: The measurement function $h(#m.Xb _k)$ used in the factor potential update step as described in @s.b.gbp.factor-update.

- `jacobian()`: The Jacobian of the factor. Used in the factor potential update step as described in @s.b.gbp.factor-update. To minimize repeated heap allocation of matrices #acr("CoW") semantics are used by wrapping the returned matrix in the `Cow<'_, _>` container@the-rust-book. With this implementors can opt to return a reference to an already allocated matrix they own, instead of a new copy of it. The dynamics factor makes use of this optimization as its Jacobian is precomputed once at initialization, and does not depend on the input linearization point #footnote([Found in the #gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/dynamic.rs#L67-L70", "src/factorgraph/factor/dynamic.rs:67-70")]).


- `jacobian_delta()`: The $delta$ used in the Jacobian first order finite difference approximation. `StrictlyPositiveFinite<f64>` is used to enforce that the returned value lies in the $RR_+ \\ {0, infinity}$ interval representable by the IEEE 754 double precision encoding. To ensure the perturbation is non-zero, and no invalid values such as $infinity$ and NaN is given.


- `first_order_jacobian()`: The first order Jacobian of the factor. This method comes with a default implementation that used the `jacobian()` and `jacobian_delta()` implementation using the finite difference method as defined in @s.m.factors.jacobian-first-order.


The `Display` trait is added as a requirement for the `Factor` trait to enforce the introspection abilities built into the simulator for when a variable is clicked on with the mouse cursor. See @s.m.introspection-tools for this.

The `&FactorState` argument passed by reference to `jacobian()`, `measure()`, and `first_order_jacobian()` is a structure containing common data associated with all factors such as its measurement precision matrix $Lambda_M$ and the factors initial measurement $h(#m.Xb _0)$, see @s.b.gbp.factor-update. This is necessary as traits only makes it possible to be generic over behaviour and not state as can be done with inheritance. While it moves the responsibility of tracking this state to the caller, it was deemed preferable over having each implementor copy the same fields manually.
All factor implementations are grouped together in a tagged union called `FactorKind`#footnote[Found in the
#gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/mod.rs#L481-L495", "src/factorgraph/factor/mod.rs:481-495")
] to enable static dispatch when the code is compiled instead of dynamic dispatch. Using static dispatch is less flexible in terms of extensibility as all implementors has to be known by the library at compile time. But allows for better performance as the compiler can better optimise and possibly inline method calls@the-rust-book. Which is important as these methods has to run in the hot code path of the simulation.

\
#par(first-line-indent: 0pt)[
  To better understand the effect of different factor variants, on the joint optimization each kind of factor can be enabled or disabled. When a factor is disabled it will not contribute or consume messages during message passing steps effectively removing it temporarily. The Settings Panel provide a section of toggles; one for each variant that can be used to toggle it. Likewise these preferences can be read from the scenarios `config.toml` to easily test scenarios where a specific factor variant is not relevant.
]
