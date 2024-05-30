#import "../../lib/mod.typ": *
== #study.H-1.full.n <s.d.study-1>

// Hypothesis 1:
// Reimplementing the original GBP Planner in a modern, flexible multi-agent simulator framework using a modern programming language will enhance the software's scientific communication and extendibility. This redevelopment will not only ensure fidelity in reproducing established results but also improve user engagement and development through advanced tooling, thereby significantly upgrading the usability and functionality for multi-agent system simulations.

// 1. Something about the simulation framework, answering the first part of the hypothesis.
// 2. Something about the programming language, answering the second part of the hypothesis.
// 3. Something about the usability and functionality, answering the third part of the hypothesis.
// 4. Something about the scientific communication and extendibility, answering the fourth part of the hypothesis.
// 5. Something about the user engagement and development, answering the fifth part of the hypothesis.

// 6. Something about the reproducibility of established results, answering the sixth part of the hypothesis.
// 6.1. Talk about how the results of their paper seems magical, where the results obtainable by their release code is similar to that of ours, so either something has not been explained properly in the paper, or the results are not reproducible.


// 1, 2, 3:
=== On The Simulator MAGICS
First of all the simulation framework developed, #acr("MAGICS"), is very capable, and has extensive thought put into it in terms of usability and configurability. The Rust programming language was chosen for its performance and safety guarantees, along with modern approach to software development. Furthermore, Rust provides a flurishing ecosystem with a large repository of crate, such as the Bevy Engine@bevyengine framework. As mentioned eariler, the #acr("ECS") architecture is a core part of Bevy, and has shown to be very flexible and easily extendable. Furthermore, it allows for effortless parallelization of many parts of the simulation, which is a key feature for the #acr("GBP") inference process, as it is inherently parallelizable in context of asynchronous message passing. However, even with the parallelization, #acr("MAGICS") has been unable to reach much better performance than the original #gbpplanner@gbpplanner. However, #acr("MAGICS") excels in terms of usability and configurability, as an extensible user interface has been built, which both makes the process of tuning hyperparameters much smoother, but also much easier to understand each of their impacts. This is a significant improvement over the original #gbpplanner, which provides a simple simulator, that visualises the simulation, but does not allow for much interactability.

#acr("MAGICS") provides the following contributions over the original #gbpplanner:
#[
  #set par(first-line-indent: 0em)
  #let colors = (
    theme.lavender,
    theme.teal,
    theme.green,
    theme.yellow
  )
  // *Simulation:*
  #set enum(numbering: box-enum.with(prefix: "C-", color: colors.at(0)))
  + *Simulation:*
    + Ability to adjust parameters live during simulation.
    + Ability to on-the-fly load new scenarios, or reload the current one.
    + Ability to turn factors on and off, to see their individual impact.
    + A completely reproducible simulation, along with seedable #acr("PRNG").

  #set enum(numbering: box-enum.with(prefix: "C-", color: colors.at(1)), start: 2)
  + *Configuration:*
    + An environment declarative configuration format for simple scenario setup.
    + A highly flexible formation configuration format, to describe how to spawn robots, and supply their mission, in a concise and declarative way.
    + A more in-depth main configuration file, to initialise all the simulation parameters.

  #set enum(numbering: box-enum.with(prefix: "C-", color: colors.at(2)), start: 3)
  + *Planner Extension:*
    + Global planning layer, the results of which are discussed in @s.d.study-3.
    + And extension of the factor graph, to include a new tracking factor, $f_t$, the results of which are discussed in @s.d.study-3.

  #set enum(numbering: box-enum.with(prefix: "C-", color: colors.at(3)), start: 4)
  + *Gaphical User Interface:*
    + A modern, #acr("UI") and #acr("UX").
    + A more flexible and configurable simulation framework.
    + Visualisation of all aspects of the underlying #acr("GBP") process.
]


// closer to a modelling language
// better tool for setting up a large system
// leans closer to something like VDM, where logical constraints and system specifications can be written in a more formal way
Due to Rusts nature#note.k[focus on something about the purpose of rust], it is a language that emulates modelling languages to a certain estent, where code quickly becomes very imperative and messy, modelling languages like VDM, tend towards a declarative style of simply writing out system specifications in a rigorous and formal way. Although Rust is not a modelling languages, it has a very strong typing system, and many logical constraints can be imposed in a meta-programming kind of approach. These features come in very handy when developing a large system like #acr("MAGICS"), where many different parts of the system need to interact in a very specific way.

=== On The Reproducibility
