#import "../../lib/mod.typ": *

== Research Hypothesis <intro-research-hypothesis>
#let h-amount = context int(hyp-counter.at(<marker.end-of-hypothesis>).first())
// This thesis poses the following #numbers.written(h-amount) hypothesis:
// This thesis poses the following #h-amount hypothesis:
This thesis poses the following four hypothesis:

// #repr(h-amount.get())
// #todo[Maybe this should multiple hypothesis, or maybe it should be more specific or rephrased.]


#set enum(numbering: h-enum)
// Jonas feedback:
// Reimplementing the original GBP Planner in a modern, flexible multi-agent simulator framework using an updated programming language will enhance the software’s scientific communication and extendibility. This redevelopment will not only ensure fidelity in reproducing established results but also improve user engagement and development through advanced tooling, thereby significantly upgrading the usability and functionality for multi-agent system simulations.

// Previous:
// + Reproducing the results of the original #acr("GBP") Planner, with thought to its architecture and design, and in a new programming language will improve the software's scientific communication and its extensibility.

// Updated with Jonas feedback
+ Reimplementing the original GBP Planner in a modern, flexible multi-agent simulator framework using a modern programming language will enhance the software's scientific communication and extendibility. This redevelopment will not only ensure fidelity in reproducing established results but also improve user engagement and development through advanced tooling, thereby significantly upgrading the usability and functionality for multi-agent system simulations.

// Jonas feedback:
// We assert that the original work can be enhanced through precise modifications without interfering with the original work. Specifically, we introduce and rigorously test various GBP iteration schedules, and to strategically enhance the system by advancing towards a more distributed approach. These targeted improvements are expected to optimize performance and flexibility of system.

// Previous:
// + The original work can be improved without transforming it. Specifically, these improvements include testing different #acr("GBP") iteration schedules, and taking minor steps towards a more distributed approach.

// Updated with Jonas feedback
+ The original work can enhacned through specific modifications without interfering with the original work's functionality. Specifically, we introduce and rigorously test various GBP iteration schedules, and to strategically enhance the system by advancing towards a more distributed approach. These targeted improvements are expected to optimize flexibility and move towards a closer-to-reality system.

+ Extending the original #acr("GBP") Planner software with a global planning layer will extend the actors' capability to move in complex environments, without degradation to the reproduced local cooperative collision avoidance, while maintaining a competitive level of performance. Furthermore, to this end, a new type of factor can be added to the #acr("GBP") factor graphs to aid in path-following.

// Previous fourth hypothesis, merged with the first one
// + Extensive tooling will create a great environment for others to understand the software and extend it further. Furthermore, such tooling will make it easier to reproduce and engage with the developed solution software.

From this point on, anything pertaining to the context of #H(1) will be referred to as #study.H-1.full.s, #H(2) will be #study.H-2.full.s, #H(3) will be be covered by both #study.H-3.full.s, and will be #study.H-4.full.s.
<marker.end-of-hypothesis>

== Research Questions <intro-research-questions>

// === Study 1
#study.H-1.prefix #sym.dash.em Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-1", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-1.", color: theme.teal))
+ Which programming language will be optimal for scientific communication and extensibility?
+ Is it possible to reproduce the results of the original #acr("GBP") Planner in the chosen programming language?
+ Which architecture and framework is suitable for such a task, and can it reproduce the original results?
+ What kind of tooling will be most beneficial for the software?
+ How can tooling help with future reproducibility and engagement with the software?
+ How can tooling help with understanding and extending the software?

// === Study 2
#study.H-2.prefix #sym.dash.em Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-2", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-2.", color: theme.teal))
+ Which possible ways can the #acr("GBP") iteration scheduling be improved?
+ How can such iteration schedules be tested, to ensure that they are an improvement?
+ Which possible avenues exist to advance towards a more distributed approach?
+ Are these targeted improvements able to enhance the original work without transforming it?

// === Study 3
#study.H-3.prefix #sym.dash.em Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-3", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-3.", color: theme.teal))
+ Will global planning improve the actors' capability to move in complex environments?
+ Will global planning degrade the existing local cooperative collision avoidance?
+ What impact will the global planning layer have on performance?

// === Study 4
#study.H-4.prefix #sym.dash.em Questions for hypothesis #boxed(color: theme.lavender, fill: theme.lavender.lighten(80%), "H-3", weight: 900):
#set enum(numbering: req-enum.with(prefix: "RQ-3.", color: theme.teal), start: 4)
+ Is it possible to introduce a new type of factor that can aid in path-following?
+ What impact will this factor have on the existing behaviour of the actors, importantly; will it degrade their ability to collaborate and avoid collisions - both with each other and the environment?
+ What will the impact of this factor be on the actors' capability to move in complex environments?


// #todo[1 hypothesis to many research question]

== Research Objectives <intro-research-objectives>
// #todo[1 research question to many research objectives]

// #let o-num() = req-enum.with(color: accent)
#{
  set enum(start: 1)
  [
    /// Study 1
    #(study.heading)(study.H-1.full.n)
    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.1", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.1.", color: theme.green))
    + Evaluate possible programming languages on #att[several metrics]#note.a[] for scientific communication and extensibility.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.2", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.2.", color: theme.green))
    + Reimplement the original GBP Planner in the chosen programming language.
    + Evaluate whether the reimplementation is faithful to the original GBP Planner by comparing the #att[four metrics: distance travelled, makespan, smoothness, and collision count.]#note.a[]

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.3", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.3.", color: theme.green))
    + Research possible architectures and frameworks for the reimplementation.
    + Choose one to use, and evaluate whether it can reproduce the original results.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.4", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.4.", color: theme.green))
    + Analyse and evaluate different kinds of tooling that can be beneficial for the software.
    + Pick the most beneficial tooling approach for the software.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.5", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.5.", color: theme.green))
    + Implement tooling to help with future reproducibility and engagement with the software.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-1.6", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-1.6.", color: theme.green))
    + Implement tooling to help with understanding and extending the software.

    /// Study 2
    #(study.heading)(study.H-2.full.n)
    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.1", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-2.1.", color: theme.green))
    + Identify how to implement different #acr("GBP") iteration schedules.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.2", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-2.2.", color: theme.green))
    + Evaulate the different possibilities for improving the #acr("GBP") iteration scheduling, and identify the best one.
    // + Implement the identified improvements without transforming#note.k[modifying the existing] the software.
    // + Evaluate whether the improvements are transformative by comparing the four metrics: distance travelled, makespan, smoothness, and collision count.

    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.3", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-2.3.", color: theme.green))
    + Identify ways to advance towards a more distributed approach.
    + Tie this into the chosen architecture and framework.

    *Objectives for _Research Questions_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-2.X", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-2.X.", color: theme.green))
    + Evaluate the enhanced system's performance and flexibility, and compare it to the original system.

    /// Study 3
    #(study.heading)(study.H-3.full.n)
    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-3.1", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-3.1.", color: theme.green))
    + Implement a global planning layer in the reimplemented GBP Planner.
    + Evaluate the actors' capability to move in complex environments by looking at the #att[four metrics: distance travelled, makespan, smoothness, and collision count]#note.a[], comparing against the reimplemented reproduction and the original GBP Planner.

    *Objectives for _Research Questions_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-3.2", weight: 900) and #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-3.3", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-3.2.", color: theme.green))
    + Compare the four metrics: distance travelled, makespan, smoothness, and collision count of the reimplemented reproduction with and without the global planning layer.

    /// Study 4
    #(study.heading)(study.H-4.full.n)
    *Objectives for _Research Question_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-4.1", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-4.1.", color: theme.green))
    + Implement a new type of factor that can aid in path-following.
    + Make the factor interact with the path given to the actors.
    + Design the factor's measurement function, jacobian.

    *Objectives for _Research Questions_ #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-4.2", weight: 900) and #boxed(color: theme.teal, fill: theme.teal.lighten(80%), "RQ-4.3", weight: 900):*
    #set enum(numbering: req-enum.with(prefix: "O-4.2.", color: theme.green))
    + Measure the impact on the #att[four metrics: distance travelled, makespan, smoothness, and collision count]#note.a[].
    + Evaluate the impact of the new factor on the actors' behaviour.
  ]
}

// #todo[Part of the argument for H-2: Furthermore, a language with that shares qualities#kristoffer[wording] with modelling languages will improve the software's ability to communicate scientific results.]
// #todo[argument for rust: Half way a modelling language, which is optimal for scientific communication and extensibility.]
#jens[make figure that shows the connection of all these, including outlining which parts are which study.]