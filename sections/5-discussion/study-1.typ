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

#todo[intro to the seubsections]


// 1, 2, 3:
=== On The Simulator MAGICS

#jonas[I have tried writing about the simulator pbjectively here. Does it work?]

First of all the simulation framework developed, #acr("MAGICS"), is very capable, and has extensive thought put into it in terms of usability and configurability. The Rust programming language was chosen for its performance and safety guarantees, along with modern approach to software development. Furthermore, Rust provides a flurishing ecosystem with a large repository of crate, such as the Bevy Engine@bevyengine framework. As mentioned eariler, the #acr("ECS") architecture is a core part of Bevy, and has shown to be very flexible and easily extendable. Furthermore, it allows for effortless parallelization of many parts of the simulation, which is a key feature for the #acr("GBP") inference process, as it is inherently parallelizable in context of asynchronous message passing. However, even with the parallelization, #acr("MAGICS") has been unable to reach much better performance than the original #gbpplanner@gbpplanner. Nonetheless, #acr("MAGICS") excels in terms of usability and configurability, as an extensible user interface has been built, which both makes the process of tuning hyperparameters much smoother, but also much easier to understand each of their impacts. This is a significant improvement over the original #gbpplanner, which provides a simple simulator, that visualises the simulation, but does not allow for much interactability.

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

#jonas[Read this, however, all the results it is talking about are not yet visualised, and the some of the orange sections here with an Attention#note.a[] box are a bit unsure, but should hopefully hold. Do let us know whether these arguments are too harsh, or seem butthurt, cause even though we are, we don't want that reflected in the report.]

As has been presented in the results sections #numref(<s.r.results.circle>) and #numref(<s.r.results.obstacles>) the results of #acr("MAGICS"), the original paper@gbpplanner, and the code provided thereby@gbpplanner-code, are shown in comparative tables; #numref(<t.network-experiment>)-#numref(<t.comms-failure-experiment>). However, the plotted values do not contain the direct numbers from @gbpplanner as these where not available, see figures; #numref(<f.circle-experiment-ldj>)-#numref(<f.qin-vs-qout>).

// On the LDJ metric
Looking at the *#acr("LDJ")* metric, see @f.circle-experiment-ldj, it becomes evident that #acr("MAGICS") is unable to reproduce the results that are presented in @gbpplanner with the same parameters of #lm3-th13.s, however lowering the lookahead horizon $t_(K-1)$ to five seconds, #lm3-th5.s, the results of #acr("MAGICS") come much closer, however still with a higher variance, and a very similar trend slowly downwards as $N_R$ is increased, although, with an offset of $tilde.op 2$ from the very first experiment with $N_R=5$. #att[Looking at this metric for the `gbpplanner` code#sp, it is possible to argue that #acr("MAGICS") performs similarly to `gbpplanner`, and the results of the paper are not reproducible with the `gbpplanner` either.]

// On the Distance Travelled metric & Makespan
The *Distance Travelled* metric, see @f.circle-experiment-distance-travelled, a somewhat similar discrepency in results when comparing #acr("MAGICS") to the original paper, however, the #acr("MAGICS"), even with #lm3-th5.s does not come close to the results of the original paper. #acr("MAGICS") achieves a much higher variance, and faster increasing trend upwards as $N_R$ is increased. One similarity between the two, is that *Distance Travelled* seems to increase linearly proportional to $N_R$. #att[Again, we see that the `gbpplanner` code achieves very similar results to #acr("MAGICS").] The *Makespan* metric reinforces this observation, see @f.obstacle-experiment-makespan.

// On the Makespan metric
// The *Makespan* metric, see @f.obstacle-experiment-makespan, mimics the results of the *Distance Travelled* as expected, since one is a function of the other. Once again, #acr("MAGICS") pe

// On the Varying Network Connectivity experiment
#att[merge this with *Communications Failure* experiment if resutls are sim]

// On the Communications Failure experiment
In the *Communications Failure* scenario, the communications radius $r_C$, was tested for values ${20, 40, 60, 80}$. Here this thesis provides these results for #lm3-th13.s and #lm3-th5.s for #acr("MAGICS"), and #lm3-th13.s for the original `gbpplanner` code. This is the experiment that makes it clear how unattainable the results of @gbpplanner are, as #acr("MAGICS") fails to come anywhere close in all both *Makespan*, and *Mean number of collisions* metrics, see @t.comms-failure-experiment. This is the case for both #lm3-th13.s and #lm3-th5.s, where we have previously seen that #lm3-th5.s get somewhat close to @gbpplanner, this is not the case for the *Varying Network Connectivity* scenario. Though, it is once again possible to verify #acr("MAGICS") against the `gbpplanner` code, which achieves nearly the same results.

// f.circle-experiment-ldj
// f.circle-experiment-distance-travelled

// f.obstacle-experiment-makespan

// t.network-experiment

// f.qin-vs-qout
// t.qin-vs-qout

// t.comms-failure-experiment


Concluding on the reproducibility capabilities of #acr("MAGICS"); the results of the #gbpplanner paper@gbpplanner, are not reproducible neither by #acr("MAGICS") nor by the provided `gbpplanner` software@gbpplanner-code. However, the results of #acr("MAGICS") can be validated against `gbpplanner`, achieving strikingly similar results. Thus is can be concluded that it seems the simulator used to obtain the results in the #gbpplanner paper, which differs from `gbpplanner` significantly, while not being described well enough in the paper to be reproducible.
#jonas[this conclusion #sym.arrow.t came from your note, am I saying the correct thing even though I have changed the wording?: "conclusion: It seems the GBP planner paper is doing some work on their own provided simulator that is not well describe in the paper, and therefor nearly impossible to reproduce. "]
