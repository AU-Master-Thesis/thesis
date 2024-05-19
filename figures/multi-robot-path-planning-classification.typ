#set page(width: auto, height: auto, margin: 1em)
// #set page(width: 140pt, height: 140pt, margin: 1em)

#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../lib/vec2.typ"
#import "../lib/catppuccin.typ": catppuccin

#let theme = catppuccin.theme
// #import "common.typ": *

#set align(center)

#let robot(pos) = {
    import cetz.draw: *
    let c = theme.blue
    circle(pos, radius: 0.1, fill: c.lighten(70%), stroke: c.lighten(20%))
}

#let coordinator(pos) = {
    import cetz.draw: *
    let c = theme.peach
    circle(pos, radius: 0.125, fill: c.lighten(70%), stroke: c.lighten(20%))
}

#let connection(from, to) = {
  import cetz.draw: *
  line(from, to, stroke: (dash: "dashed", paint: theme.overlay2))
  // circle(pos, radius: 0.15, fill: c.lighten(50%), stroke: c)
}

#let velocity(pos, dir) = {
  import cetz.draw: *
  // line(from, to, stroke: (dash: "dashed", paint: gray))
  // let c = olive.lighten(50%)
  let c = theme.maroon.lighten(30%)
  line(pos, vec2.add(pos, dir), stroke: (dash: "dotted", paint: c), mark: (end: "stealth", fill: c))
}

#let title(t) = text(size: 10pt, weight: "semibold", black.lighten(30%), t)

// = Centralized

// #title[Centralized]

#let centralized = cetz.canvas({
  import cetz.draw: *
  // coordinate-grid(10, 10)
  let robot-positions = (
    (1, 1),
    (-1, 1),
    (-0.5, -0.8),
    (0, 1.5),
    (0.2, -1.1),
    (0.5, -0.5),
    (1.2, 0.1),
    (-1.3, -0.1)
  )

  let coordinator-pos = (0, 0)

  velocity(robot-positions.at(0), (0.0 ,0.5))
  velocity(robot-positions.at(1), (0, 0.5))
  velocity(robot-positions.at(2), (0, 0.56))
  velocity(robot-positions.at(3), (0, 0.7))
  velocity(robot-positions.at(4), (-0.1, 0.5))
  velocity(robot-positions.at(5), (0.1, 0.55))
  velocity(robot-positions.at(6), (0, 0.5))
  velocity(robot-positions.at(7), (0, 0.55))
  // velocity(robot-positions.at(8), (0, 0.8))


  for pos in robot-positions {
    let pos = vec2.add(coordinator-pos, pos)
  connection(coordinator-pos, pos)
    robot(pos)
    // line(coordinator-pos, pos, stroke: (dash: "dashed", paint: gray))
  }
  coordinator(coordinator-pos)
})

// #pagebreak()
// = Decentralized

// #title[Decentralized]

// In the decentralized control strategy, each robot makes its own decisions based on its measurements.

#let decentralized = cetz.canvas({
  import cetz.draw: *
  // coordinate-grid(10, 10)
  let robot-positions = (
    (1, 1),
    (-1, 1),
    (-0.5, -0.8),
    (0, 1.5),
    (0.2, -1.1),
    (0.5, -0.5),
    (1.2, 0.1),
    (-1.3, -0.1),
    (0, 0)
  )

  let robot-velocities = (
    (0, 0.5),
    (0, 1),
    (0, 1),
    (0, 1),
    (0, 1),
    (0, 1),
    (0, 1),
    (0, 1),
    (0, 1),
  )


  velocity(robot-positions.at(0), (0.25, 0.5))
  velocity(robot-positions.at(1), (0, 0.5))
  velocity(robot-positions.at(2), (-0.15, 0.56))
  velocity(robot-positions.at(3), (0, 0.7))
  velocity(robot-positions.at(4), (0, 0.5))
  velocity(robot-positions.at(5), (0, 0.5))
  velocity(robot-positions.at(6), (-0.1, 0.5))
  velocity(robot-positions.at(7), (0.1, 0.55))
  velocity(robot-positions.at(8), (0, 0.8))

  for (pos, vel) in robot-positions.zip(robot-velocities) {

    // line(pos, vec2.add(pos, vel), stroke: (dash: "dotted", paint: aqua), mark: (end: ">", fill: aqua))
  }

  // let coordinator-pos = (0, 0)

  for pos in robot-positions {
    // let pos = vec2.add(coordinator-pos, pos)
    coordinator(pos)
    // line(coordinator-pos, pos, stroke: (dash: "dashed", paint: gray))
  }
  // catmull((0,0), (1,1), (2,-1), (3,0), tension: .4, stroke: purple.lighten(80%))
  // coordinator(coordinator-pos)

})

// #pagebreak()

// = `Distributed`

// #title[Distributed]

#let distributed = cetz.canvas({
  import cetz.draw: *
  // coordinate-grid(10, 10)
  let robot-positions = (
    (1, 1),
    (-1, 1),
    (-0.5, -0.8),
    (0, 1.5),
    (0.2, -1.1),
    (0.5, -0.5),
    (1.2, 0.1),
    (-1.3, -0.1),
    (0, 0)
  )

  let coordinator-pos = (0, 0)

  // for i in range(robot-positions.len()) {
  //   for j in range(robot-positions.len()) {
  //     if i == j {
  //       continue
  //     }

  //     let from = robot-positions.at(i)
  //     let to = robot-positions.at(j)

  //     line(from, to, stroke: (dash: "dashed", paint: gray))
  //   }
  // }

  velocity(robot-positions.at(0), (0.05, 0.6))
  velocity(robot-positions.at(1), (0, 0.5))
  velocity(robot-positions.at(2), (-0.15, 0.56))
  velocity(robot-positions.at(3), (0, 0.7))
  velocity(robot-positions.at(4), (0, 0.5))
  velocity(robot-positions.at(5), (0.6, -0.1))
  velocity(robot-positions.at(6), (-0.1, 0.5))
  velocity(robot-positions.at(7), (-0.1, 0.55))
  velocity(robot-positions.at(8), (0, 0.8))

  let connection-between(i, j) = {
    connection(
      robot-positions.at(i),
      robot-positions.at(j)
    )
  }

  connection-between(0, 3)
  connection-between(0, 5)
  connection-between(0, 6)
  connection-between(1, 3)
  connection-between(1, 7)
  connection-between(2, 5)
  connection-between(2, 7)
  connection-between(2, 4)
  connection-between(4, 5)
  connection-between(5, 6)
  connection-between(5, 8)
  connection-between(6, 8)
  connection-between(8, 2)


  for pos in robot-positions {
    // let pos = vec2.add(coordinator-pos, pos)
    coordinator(pos)
  }
})


// #pagebreak()

#figure(
  grid(
    columns: 3,
    column-gutter: 4em,
    row-gutter: 1em,
    rows: 2,
    title[Centralized],
    title[Decentralized],
    title[Distributed],

    centralized,
    decentralized,
    distributed
  )
)
