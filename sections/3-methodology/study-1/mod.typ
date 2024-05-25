#import "../../../lib/mod.typ": *
== #study.H-1.full.n <s.m.study-1>

// This section will cover the approach chosen for reproducing the software implementation in the gbpplanner paper@gbpplanner. Focus is put on arguing for places where the internal workings of the reimplementation differs. Why the difference is either deemed necessary due to inherent differences in the capabilities of the programming languages, or why they are seen as desireable/ an improvement. Where multiple different solutions are feasible to solve the same issue comparative arguments are presented to reason for the selected solution.

// #jonas[Do you think it is very important in these "Study" (or "Contribution" as Andryi might want us to call it) which Hypothesis it tries to answer, even though it is made clear earlier that Study 1 = Hypothesis 1]

// This sections outlines the methodology for the fourth study; #study.H-4.name. Firstly, @s.m.configuration describes how the simulation tool, environment, and robot spawning has been parameterised through several configuration files. Thereafter, @s.m.simulation-tool details the developed simulation tool itself, and how to interact with it.

#jonas[The ordering of these subsections might be confusing as the merge has been done somewhat crudely. No need to read it all again, but it would be nice to get feedback on what order to do what in. The configuration and tooling/user experience aspects first or the reproduction aspects?]

The methodology for developing an extensive simulation tool is outlined in this section. It is described how this tool is made capable of replicating the software implementation described in the gbpplanner paper@gbpplanner. The section details the differences in the reimplementation, justifying necessary deviations due to distinct capabilities or limitations of the programming language used as well as libraries, and explaining the improvements made. For issues where multiple solutions are viable, comparative analyses are provided to justify the choice of the selected solution. As such _Research Objectives_ #boxed(color: theme.teal, [*O-1.1.1*]) through #boxed(color: theme.teal, [*O-1.6.1*]) are addressed in this section. The extensive usability and configurability improvements are described in sections #numref(<s.m.configuration>) and #numref(<s.m.simulation-tool>), respectively.

#include "configuration.typ"
#include "simulation.typ"
#include "factors.typ"
#include "language.typ"
#include "architecture.typ"
#include "graph-representation.typ"

#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours,
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non-measurable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  List out all the configuration parameters both the algorithm exposes and the sim. Which one is identical to gbpplanner, and what values are sensible to use as defaults
]


maintains two sets of ids, one for any robot within communication radius, and one for any robot connected with.


=== Variable Structure <s.variable-structure>



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


// #kristoffer[
//   Explain the marginalization step/ algorithm
//   They do explain it at ALL in the paper so, we need another citation for it
//   Maybe make a figure, or some colorful equations to explain the step/slices
// ]


=== Factor Structure <s.factor-structure>

#listing([
```rust
trait Factor: std::fmt::Display {
  /// Number of neighbours this factor expects
  fn neighbours(&self) -> usize;
  /// Whether the factor is linear or non-linear
  fn linear(&self) -> bool;
  /// The delta for the jacobian first order derivative approximation calculation
  fn jacobian_delta(&self) -> f64;
  /// The jacobian of the factor
  fn jacobian(&self, state: &FactorState, lin_point: &Vector<f64>) -> Cow<'_, Matrix<f64>>;
  /// Measurement function
  fn measure(&self, state: &FactorState, lin_point: &Vector<f64>) -> Measurement;
  /// First order jacobian (provided method)
  fn first_order_jacobian(&self, state: &FactorState, lin_point: Vector<f64>) -> Matrix<f64> { ... }
}
```
],
caption: [Factor]
)

- No inheritance, use composition and traits instead

- #k[what is the purpose of the FactorState argument?]

- Used tagged union for static dispatch


#kristoffer[
  Explain how factors are abstracted using the `Factor` trait.
  How our implementation uses Composition instead of inheritance in C++
    - What pros/cons does this bring?
]


// #algorithm(
//   caption: [Rewiring],
//   [
//     #show regex("(MinCostConnection|Rewire|Sample|Nearest|Steer|ObstacleFree|Neighbourhood|Cost|Line|CollisionFree|Parent|WithinGoalTolerance)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
//     #set text(size: 0.85em)
//     #let ind() = h(2em)
//     *Input:* $V_"near", x_"new"$ \ \
//
//     *for* $x_"near" in V_"near"$ *do* \
//     #ind()$c_"near" #la "Cost"(x_"new") + c("Line"(x_"new", x_"near"))$ \
//     #ind()*if* $"CollisionFree"(x_"new", x_"near") and c_"near" < "Cost"(x_"near")$ *then* \
//     #ind()#ind()$x_"parent" #la "Parent"(x_"near")$ \
//     #ind()#ind()$E #la E \\ {[x_"parent", x_"near"]}$ \
//     #ind()#ind()$E #la E union {[x_"new", x_"near"]}$ \
//     #ind()*end* \
//     *end* \ \
//
//     *Output:* None
//   ]
// )<alg.rrt-star.rewire>
//
//
