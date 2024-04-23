#import "../../lib.typ": *
== Architecture <s.m.architecture>

This section presents the architectural patterns used in the design of the simulation. First by presenting the major architectural paradigm used, the ECS paradigm. What it is, how it works and why it was chosen. Second how it results in changes compared to the original implementation of the gbplanner algorithm.


=== Entity Component System

#acr("ECS") is an architectual software design pattern specifically designed for data oriented programming #note.kristoffer[explain what is meant by data oriented programing]. At the heart of it are three complementary concepts, from which its name comes from: entities, components and systems:

/ Entity: A collection of components with a unique id.  Every object in the #acr("ECS") world is an entity. Most often the id a single unsigned integer.
/ Component: Data scoped to a single piece of functionality. For example position, velocity, rigid body, a timer etc.
/ System: Functions that operate on the data by querying the #acr("ECS") world for entities and components and updating them.

It if different from traditional #acr("OOP") based ways of modelling

At first glance this representation/organisazation


that is designed to fully utilize modern computer hardware


memory hierarchies

Cache Locality


#kristoffer[
  point out how it is different compared to traditional game engines/simulators like Unity, Unreal, autodesk Isaac Sim
]


// it is a structural pattern


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

#kristoffer[create figure explaining why ECS is cache friendly]
// #ref(<s.m.architecture>)


#kristoffer[Make a remark about the similarities with relational databases and query synteax like SQL. Also point out how the data is stored differently, to handle concern about cache friendlyness]

data oriented design vs object oriented design


The #acr("ECS") architecture is not limited to game engines and simulations.

is versatile

// https://dl.acm.org/doi/10.1145/3286689.3286703

// #acr("AOS") vs #acr("SOA")
//
//
// ```rust
// struct Point3d {
//   position: Vec2,
//   velocity: Vec2,
// }
//
// type Robots = Vec<Robot>;
// ```


#kristoffer[what are its drawbacks?]
#kristoffer[cite ecs papers]
#kristoffer[create figure explaining ECS data store]

entity similar to a primary key in a relational database


#kristoffer[clarify that the data representation used by bevy is not one to one of the table example]

#{
  let cm = emoji.checkmark
  show raw: it => it
  let gray = catppuccin.theme.subtext0

  set align(center)
  set table(stroke: gray)

  let header = ([`Entity` (*ID*)], [`Transform`], [`Robot`], [`Camera`], [`Velocity2d`], [`Obstacle`], [...])
  let columns = header.map(it => 1fr)
  // let columns = header.map(it => 1fr).remove(header.len())
  let columns = (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 0.33fr)

  let table-stroke = gray
  let table-fill-with-header = (x, y) => {
    if y == 0 {
      gray.lighten(60%)
    } else if x == 0 {
      gray.lighten(80%)
    }
  }

  figure(
    {
  table(columns: columns, stroke: table-stroke, fill: table-fill-with-header,

    table.header(..header),
    table.hline(stroke: 1pt),
    [$a$], [#cm], [], [#cm], [#cm $[0.0, 1.0]$], [], [],
    [$a+1$], [#cm], [#cm], [], [#cm $[0.2, 0.8]$], [], [],
    [$a+2$], [#cm], [#cm], [], [#cm $[-0.5, 0.0 ]$], [], [],
    [$a+3$], [#cm], [], [], [], [#cm], [],
    [$a+4$], [#cm], [], [], [], [#cm], []
  )

  v(-1em)
  text(size: 18pt, [...])
  v(-0.25em)

  table(columns: columns, stroke: gray, fill: (x, y) => if x == 0 { gray.lighten(80%) },
  [$a+n$], [#cm], [#cm], [], [#cm $[1.0, 0.0]$], [], []

)
  }, caption: [Structural layout of an #acr("ECS") data store. Conceptually it is analagous to a table in relational database. #cm in a component column denotes that the entity has an instance of that component type e.g. entity $a + 2$ has components: ${$ `Transform`, `Robot`, `Velocity2d` $}$]
) //  <f.ecs-entity-component-table>


In Bevy systems are ordinary functions


// sourcecode[
```rust
fn move_robots(mut query: Query<(&mut Transform, &Velocity2d), With<Robot>>) {
  for (mut transform, velocity) in &mut query {
    ...
  }
}
```
// ]

  // let q-match-data = table.cell.with(fill: green.lighten(75%))
  let q-match-data = table.cell.with(fill: catppuccin.theme.green.lighten(75%))
  // let q-match-filter = table.cell.with(fill: blue.lighten(75%))
  let q-match-filter = table.cell.with(fill: catppuccin.theme.blue.lighten(75%))


  table(columns: columns, fill: table-fill-with-header,

  ..header
  ,

  [$a$], [#cm], [], [#cm], [#cm $[0.0, 1.0]$], [], [],
  q-match-data[$a+1$], q-match-data[#cm], q-match-filter[#cm], [], q-match-data[#cm $[0.2, 0.8]$], [], [],
  q-match-data[$a+2$], q-match-data[#cm], q-match-filter[#cm], [], q-match-data[#cm $[-0.5, 0.0]$], [], [],
  [$a+3$], [#cm], [], [], [], [#cm], [],
  [$a+4$], [#cm], [], [], [], [#cm], [],
  )
  v(-1em)
  text(size: 18pt, [...])
  v(-0.25em)
  table(columns: columns,
  q-match-data[$a+n$], q-match-data[#cm], q-match-filter[#cm], [], q-match-data[#cm $[1.0, 0.0]$], [], []

)

}

The `With<Robot>` is a

where
