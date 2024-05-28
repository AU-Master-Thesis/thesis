#import "../../../lib/mod.typ": *
== #study.H-1.full.n <s.m.study-1>

// This section will cover the approach chosen for reproducing the software implementation in the gbpplanner paper@gbpplanner. Focus is put on arguing for places where the internal workings of the reimplementation differs. Why the difference is either deemed necessary due to inherent differences in the capabilities of the programming languages, or why they are seen as desireable/ an improvement. Where multiple different solutions are feasible to solve the same issue comparative arguments are presented to reason for the selected solution.

// #jonas[Do you think it is very important in these "Study" (or "Contribution" as Andryi might want us to call it) which Hypothesis it tries to answer, even though it is made clear earlier that Study 1 = Hypothesis 1]

// This sections outlines the methodology for the fourth study; #study.H-4.name. Firstly, @s.m.configuration describes how the simulation tool, environment, and robot spawning has been parameterised through several configuration files. Thereafter, @s.m.simulation-tool details the developed simulation tool itself, and how to interact with it.

#jonas[The ordering of these subsections might be confusing as the merge has been done somewhat crudely. No need to read it all again, but it would be nice to get feedback on what order to do what in. The configuration and tooling/user experience aspects first or the reproduction aspects?]

The methodology for developing an extensive simulation tool is outlined in this section. It is described how this tool is made capable of replicating the software implementation described in the #gbpplanner paper@gbpplanner. The section details the differences in the reimplementation, justifying necessary deviations due to distinct capabilities or limitations of the programming language used as well as libraries, and explaining the improvements made. For issues where multiple solutions are viable, comparative analyses are provided to justify the choice of the selected solution. As such _Research Objectives_ #boxed(color: theme.teal, [*O-1.1.1*]) through #boxed(color: theme.teal, [*O-1.6.1*]) are addressed in this section. The extensive usability and configurability improvements are described in sections #numref(<s.m.configuration>) and #numref(<s.m.simulation-tool>), respectively.

#todo[
  More comprehensive introduction, laying the different sections.
]

#include "configuration.typ"
#include "simulation.typ"
#include "factors.typ"
#include "language.typ"
#include "architecture.typ"
#include "graph-representation.typ"
#include "factor-structure.typ"

=== Variable Structure <s.variable-structure>

- Mention that the pose factor is a special case that is embedded in the variable structure, for simplicity

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
