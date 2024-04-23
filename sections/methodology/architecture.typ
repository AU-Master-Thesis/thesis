#import "../../lib.typ": *
== Architecture <s.m.architecture>

//! This is a guided introduction to Bevy's "Entity Component System" (ECS)
//! All Bevy app logic is built using the ECS pattern, so definitely pay attention!
//!
//! Why ECS?
//! * Data oriented: Functionality is driven by data
//! * Clean Architecture: Loose coupling of functionality / prevents deeply nested inheritance
//! * High Performance: Massively parallel and cache friendly
//!
//! ECS Definitions:
//!
//! Component: just a normal Rust data type. Generally scoped to a single piece of functionality
//!     Examples: position, velocity, health, color, name
//!
//! Entity: a collection of components with a unique id
//!     Examples: Entity1 { Name("Alice"), Position(0, 0) },
//!               Entity2 { Name("Bill"), Position(10, 5) }
//!
//! Resource: a shared global piece of data
//!     Examples: asset storage, events, system state
//!
//! System: runs logic on entities, components, and resources
//!     Examples: move system, damage system
//!
//! Now that you know a little bit about ECS, lets look at some Bevy code!
//! We will now make a simple "game" to illustrate what Bevy's ECS looks like in practice.


// #note.kristoffer[talk about how ECS changes traditional design]

// #note.kristoffer[create figure explaining why ECS is cache friendly]


$ 2 + 2 $ <equ>

// #ref(<s.m.architecture>)
