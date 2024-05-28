#import "../../lib/mod.typ": *

== Entity Component System

#acr("ECS") is an architectural software design pattern specifically tailored for #acr("DOP"). #acr("DOP") is a design paradigm that focuses on organizing and processing data efficiently, by structuring the layout of data to play well with the caching mechanisms built into modern CPU's. Instead of organizing repeated structures as #acr("AOS") structures are instead decoupled into its constituent components grouped into separate in-memory continous arrays called #acr("SOA"). This approach is characterized by the separation of data storage from behavior and logic at the programming level. ECS architecture is commonly employed in computer games and intensive data analytics to enhance performance. Additionally, it has been utilized in robotic simulation projects such as the Potato simulator, which models large-scale heterogeneous swarm robotics@li2023potato.

// At the programming level this is visible by the separation of data storage from behaviour and logic. This architecture is commonly used in computer games and intensive data analytics computations to achieve higher performance. It has also been used in other robotic simulations projects such as @li2023potato, that uses it simulate large scale heterogeneous swarm robotics.

At the heart of #acrpl("ECS") are three complementary concepts, from which its name comes from: _entities_, _components_ and _systems_:

#term-table(
  [*Entity*], [A collection of components with a unique id.  Every object in the #acr("ECS") world is an entity. Most often the id a single unsigned integer. An entity could be a robot, a camera or a cylinder.],
  [*Component*], [Data scoped to a single piece of functionality. For example position, velocity, rigid body, a timer etc.],
  [*System*], [Functions that operate on the data by querying the #acr("ECS") world for entities and components and updating them.]
)

// #table(
//   columns: (auto, auto, 1fr),
//   stroke: none,
//   row-gutter: 0.25em,
//   // gutter: none,
//   [*Entity*], marker.arrow.single, [A collection of components with a unique id.  Every object in the #acr("ECS") world is an entity. Most often the id a single unsigned integer. An entity could be a robot, a camera or a cylinder.],
//   [*Component*], marker.arrow.single, [Data scoped to a single piece of functionality. For example position, velocity, rigid body, a timer etc.],
//   [*System*], marker.arrow.single, [Functions that operate on the data by querying the #acr("ECS") world for entities and components and updating them.]

// )

// / Entity: A collection of components with a unique id.  Every object in the #acr("ECS") world is an entity. Most often the id a single unsigned integer. An entity could be a robot, a camera or a cylinder.
// / Component: Data scoped to a sitable.vline(stroke: (paint: accent, thickness: 0.75pt, cap: "round"))ngle piece of functionality. For example position, velocity, rigid body, a timer etc.
// / System: Functions that operate on the data by querying the #acr("ECS") world for entities and components and updating them.

It leads to a different approach to software design in comparison to more traditional #acr("OOP") based ways of modelling simulated environments. Instead of using object hierarchies facilitated by inheritance all components are logically laid out in a flat hierarchy, managed by a single instance of some "data store" structure. This data store is then queried and mutated by systems. All of this leads to a conceptual model which is close to relational database models. In this perspective entities are equivalent to primary keys. Components to table columns and systems to SQL queries@papagiannakis2023project. @f.ecs-entity-component-table shows an example of how the data store structures components into one large table indexed by entity ids.



// memory hierarchies / Cache Locality



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

// #ref(<s.m.architecture>)



// node hierarchies

// The #acr("ECS") architecture is not limited to game engines and simulations.

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





// entity similar to a primary key in a relational database






#let header = ([`Entity` (*ID*)], [`Transform`], [`Robot`], [`Camera`], [`Velocity2d`], [`Obstacle`], [...])
#let columns = header.map(it => 1fr)
  // let columns = header.map(it => 1fr).remove(header.len())
#let columns = (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 0.33fr)

#let gray = catppuccin.theme.subtext0
#let table-stroke = gray
#let table-fill-with-header = (x, y) => {
    if y == 0 {
      gray.lighten(60%)
    } else if x == 0 {
      gray.lighten(80%)
    }
  }

#let cm = emoji.checkmark

#set table(stroke: gray)
#show raw: it => it

#figure(
    {
  table(columns: columns,
    stroke: gray,

    // stroke: table-stroke,
    fill: table-fill-with-header,

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
  }, caption: [Structural layout of an #acr("ECS") data store. Conceptually it is analogous to a table in relational database. #cm in a component column denotes that the entity has an instance of that component type e.g. entity $a + 2$ has components: ${$ `Transform`, `Robot`, `Velocity2d` $}$]
)   <f.ecs-entity-component-table>


// In Bevy systems are ordinary functions

For this thesis the Bevy game engine is used, as the underline framework for both rendering and #acr("ECS") implementation@bevyengine. Its #acr("ECS") implementation utilizes Rusts powerful type system, to encode queries as variadic generic types that are verified at compile time. To get a sense for how queries are expressed using the type system, have a look at @l.example-ecs-query. It showcases how the three concepts of #acr("ECS") blends well together with the Rust language. Systems are ordinary functions, with `Query<...>` arguments. Components are structs and enums implementing the `Component` trait. And entities are simply type aliases for unsigned integers.



// ```sql
// select Transform, Velocity2d, Robot as _ from world
// ```


#listing(
  [
```rust
fn move_robots(mut query: Query<(&mut Transform, &Velocity2d), With<Robot>>) {
  for (mut transform, velocity) in &mut query {
    ...
  }
}
```
],

  line-numbering: none,
caption: [An example of how bevy uses the Rust type system to implement #acr("ECS") queries with a high level of expressitivity. The constructed type can be read as. "Give me a mutable reference to a `Transform` component, and immutable reference to a `Velocity2d` component. But only for the entities with a `Robot` marker component."]
) <l.example-ecs-query>



Executing the system in @l.example-ecs-query against the data store in @f.ecs-entity-component-table would result in an tuple iterator over the cells colored green#swatch(catppuccin.latte.green.lighten(75%)) as shown in @f.ecs-query.


  // let q-match-data = table.cell.with(fill: green.lighten(75%))
#let q-match-data = table.cell.with(fill: catppuccin.theme.green.lighten(75%))
//   // let q-match-filter = table.cell.with(fill: blue.lighten(75%))
#let q-match-filter = table.cell.with(fill: catppuccin.theme.blue.lighten(75%))

#figure({
  table(columns: columns, fill: table-fill-with-header,
  ..header,

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

)},
  caption: [
  Result of executing the query `Query<(&mut Transform, &Velocity2d), With<Robot>>` against the data store in @f.ecs-entity-component-table. Cells colored green#swatch(catppuccin.latte.green.lighten(75%)) are selected by the query. The cells colored blue #swatch(catppuccin.latte.blue.lighten(75%)) show how the `With<Robot>` constraint limits the query to only select the components on entities ${a + 1, a + 2, a +n}$.
]

) <f.ecs-query>

// A powerful feature of the Bevy game engine is that it will automatically schedule systems in parallel across available CPU cores, if it can guarantee that no data races will occur between systems accessing the same components. i.e. no two queries request a `&mut` mutable reference to a component column, that overlaps give any predicate clauses. This analysis is performed based on the query signatures given in systems.

A powerful feature of the Bevy game engine is that it automatically schedules systems in parallel across available CPU cores if it can guarantee that no data races will occur between systems accessing the same components. This means no two queries can request a `&mut` mutable reference to a component column that overlaps with any predicate clauses. This analysis is performed based on the query types provided in the system signatures.
