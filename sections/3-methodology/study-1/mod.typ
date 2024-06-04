#import "../../../lib/mod.typ": *
== #study.H-1.full.n <s.m.study-1>

// This section will cover the approach chosen for reproducing the software implementation in the gbpplanner paper@gbpplanner. Focus is put on arguing for places where the internal workings of the reimplementation differs. Why the difference is either deemed necessary due to inherent differences in the capabilities of the programming languages, or why they are seen as desireable/ an improvement. Where multiple different solutions are feasible to solve the same issue comparative arguments are presented to reason for the selected solution.

// #jonas[Do you think it is very important in these "Study" (or "Contribution" as Andryi might want us to call it) which Hypothesis it tries to answer, even though it is made clear earlier that Study 1 = Hypothesis 1]

// This sections outlines the methodology for the fourth study; #study.H-4.name. Firstly, @s.m.configuration describes how the simulation tool, environment, and robot spawning has been parameterized through several configuration files. Thereafter, @s.m.simulation-tool details the developed simulation tool itself, and how to interact with it.

// #jonas[The ordering of these subsections might be confusing as the merge has been done somewhat crudely. No need to read it all again, but it would be nice to get feedback on what order to do what in. The configuration and tooling/user experience aspects first or the reproduction aspects?]

// OLD
// The methodology for developing an extensive simulation tool is outlined in this section. It is described how this tool is made capable of replicating the software implementation described in the #gbpplanner paper@gbpplanner. The section details the differences in the reimplementation, justifying necessary deviations due to distinct capabilities or limitations of the programming language used as well as the chosen framework and libraries. For issues where multiple solutions are viable, comparative analyses are provided to justify the choice of the selected solution. As such _Research Objectives_ #boxed(color: theme.teal, [*O-1.1.1*]) through #boxed(color: theme.teal, [*O-1.6.1*])#note.j[make sure these are correct] are addressed in this section. The extensive usability and configurability improvements are described in sections #numref(<s.m.configuration>) and #numref(<s.m.simulation-tool>), respectively.

// Re-formulate with this order:
// Introduce things in this order:
// 1. talk about the simulation tool and its capabilities
// 2. talk about the configuration and how it is used to set up the simulation tool and integrated with it
// 3. talk about the mathematics of the reproduction
// 4. introduce the chosen language and why before talking about more code-heavy stuff
// 5. more code-heavy stuff -> architecture, data structures such as the graph representation and factor structure

// Re-formulation:
The methodology for developing the extensive simulation tool #acr("MAGICS"); with the goal of being capable of replicating the results of the #gbpplanner, is explained in this section. First, in sections #numref(<s.m.simulation-tool>) and #numref(<s.m.configuration>), the simulator, its internal and external design, and the configuration of it are described, providing closure for #boxed(color: theme.green, [*O-1.2.1*])-#boxed(color: theme.green, [*O-1.4.1*]). Then in @s.m.factor-graph, the mathematical methodology for the factor graph representation is detailed, thus answering #boxed(color: theme.green, [*O-1.1.2*]). Finally, @s.m.language introduces the chosen programming language, and presents arguments for the choice, completing #boxed(color: theme.green, [*O-1.1.1*]). After the language is introduced, some important implementation decision are detailed in #numref(<s.m.architecture>)-#numref(<s.m.factor-structure>). This part also details the differences in the reimplementation, justifying necessary deviations due to distinct capabilities or limitations of the programming language used as well as the chosen frameworks and libraries. For issues where multiple solutions are viable, comparative analyses are provided to justify the choice of the selected solution. Research objective #boxed(color: theme.green, [*O-1.1.3*]) depends on the results and will be answered in @s.r.study-1, and the corresponding discussion.

// As such _Research Objectives_ #boxed(color: theme.green, [*O-1.1.1*])#att[Maybe explain exactly which objectives are done by each subsection] through #boxed(color: theme.green, [*O-1.4.1*]) are addressed in this section.

#include "simulation.typ"
#include "configuration.typ"
#include "factors.typ"
#include "language.typ"
#include "architecture.typ"
#include "graph-representation.typ"
#include "factor-structure.typ"
#include "variable-structure.typ"
#include "algorithm.typ"
