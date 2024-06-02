#import "../../../lib/mod.typ": *
=== Architecture <s.m.architecture>

This section presents the architectural and software design patterns used in the design of the simulation. Areas where the design differs from the original work are argued for and motivations for why a different choice was mode is laid and reasoned about.


// First by presenting the major architectural paradigm used, the ECS paradigm. What it is, how it works and why it was chosen. Second how it results in changes compared to the original implementation of the gbplanner algorithm.


// ==== Entity Component System

// #k[
//   write about how we use bevy and ECS. What components are central, and how is the algorithm composed using systums and run schedules.
// ]


// #jonas[This section about ECS has been moved to the background section.]

// #todo[There should be new content here, describing why this architecture was chosen, and which others were considered.
//
//   - Their approach is very "imperative"
//
//   - Maybe there are papers that discuss various approaches to design scientific simulations.
//
//   - Mention that attempts have been made to decouple dependencies between modules, (although not really), to make the design modular.
// ]
