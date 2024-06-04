// #set page(width: auto, height: auto)
#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../../../lib/vec2.typ"
#import "../../../lib/mod.typ": *

// = InterRobot Factor Lifecycle

// #pagebreak()

// #jens[bait for you, use it however you see fit]
#let sc = 50%
#let coordinate-grid(x, y) = {

  import cetz.draw: *

  let x-max = x
  let y-max = y
  let x-min = -x-max
  let y-min = -y-max
  grid((x-min, y-min), (x-max,y-max), stroke: gray)
  line((x-min, 0), (x-max, 0), stroke: red)
  line((0, y-min), (0, y-max), stroke: green)

}

#let points-relative-from(start, ..points) = {
  points.pos().fold((start, ), (acc, point) => {
    acc + (vec2.add(acc.last(), point),)
  })
}

#let points-relative-from-angle(start, ..points) = {
  // but where a point is (angle, distance)
  points.pos().fold((start, ), (acc, point) => {
    let (angle, distance) = point
    acc + (vec2.add(acc.last(), vec2.from-polar(distance, angle)),)
  })
}

// #points-relative-from((2, 2), (0, 1), (5, 0), (-1, 0))

#let timestep(t) = text(size: 1em, $#t$)
// #let timestep(t) = text(size: 22pt, math.equation($#t$))

#let variable = (
  radius: 0.125,
  color: red,
)

#let robot(name, pos, active: true, color: theme.peach) = {
  import cetz.draw: *
  let c = color
  let communication-radius = 3
  let paint = if active { theme.teal } else { theme.surface2 }
  circle(pos, radius: communication-radius, stroke: (dash: "loosely-dashed", paint: paint, thickness: 2pt, cap: "round"))

  circle(pos, radius: 0.5, fill: c.lighten(80%), stroke: c + 2pt,  name: name)

  content(pos, text(color, font: "JetBrainsMono NF", weight: "bold", name))
}

#let tn = [

#cetz.canvas({
  import cetz.draw: *
  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (2, -2), color: theme.mauve)
  )
  let extend = 1

  // B
  let variables = points-relative-from-angle(robots.A.pos, (-10deg, extend), (-20deg, extend), (-30deg, extend))

  for (va, vb) in windows(variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }
  robot("A", robots.A.pos, color: robots.A.color)

  for vp in variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: 2pt + robots.A.color)
  }

  // B
  let variables = points-relative-from-angle(robots.B.pos, (10deg, extend), (20deg, extend), (30deg, extend))

  for (va, vb) in windows(variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }
  robot("B", robots.B.pos, color: robots.B.color)

  for vp in variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: 2pt + robots.B.color)
  }
})
#place(bottom + center, [
  A: Timestep #timestep($t_n$)
])

]


#let tn-1 = [

#cetz.canvas({
  import cetz.draw: *
  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (1, -0.5), color: theme.mauve)
  )
  let extend = 1

  // variables
  let a-variables = points-relative-from-angle(robots.A.pos, (-15deg, extend), (-10deg, extend), (-5deg, extend))
  let b-variables = points-relative-from-angle(robots.B.pos, (5deg, extend), (10deg, extend), (15deg, extend))

  // interrobot

  for (va, vb) in a-variables.slice(1, a-variables.len()-1).zip(b-variables.slice(1, b-variables.len()-1)) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    let scale = 0.25
    let interrobot-color = theme.green
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color + 2pt
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color + 2pt
    )
  }

  // A
  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }

  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: robots.A.color + 2pt)
  }
  robot("A", robots.A.pos, color: robots.A.color)

  // B
  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }

  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: robots.B.color + 2pt)
  }
  robot("B", robots.B.pos, color: robots.B.color)
})
#place(bottom + center, [
  B: Timestep #timestep($t_(n+1)$)
])
]

// #pagebreak()

#let tn-3 = [

#cetz.canvas({
  import cetz.draw: *

  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (1.5, -0.5), color: theme.mauve)
  )
  let extend = 1

  let a-variables = points-relative-from-angle(robots.A.pos, (10deg, extend), (20deg, extend), (30deg, extend))
  let b-variables = points-relative-from-angle(robots.B.pos, (5deg, extend), (10deg, extend), (15deg, extend))

  for (va, vb) in a-variables.slice(1, a-variables.len()-1).zip(b-variables.slice(1, b-variables.len()-1)) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    let scale = 0.25
    let interrobot-color = theme.green
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color + 2pt
    )

    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: theme.maroon + 2pt
    )
  }

  // A
  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: robots.A.color + 2pt)
  }
  robot("A", robots.A.pos, active: false, color: robots.A.color)

  // B
  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: robots.B.color + 2pt)
  }

  robot("B", robots.B.pos, color: robots.B.color)
})
#place(bottom + center, [
  C: Timestep #timestep($t_(n + 2)$)
])
]

// #pagebreak()

#let tn-4 = [
// #timestep($t_(n + 4)$)

#cetz.canvas({
  import cetz.draw: *

  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (1.5, -0.5), color: theme.mauve)
  )
  let extend = 1

  let a-variables = points-relative-from-angle(robots.A.pos, (10deg, extend), (20deg, extend), (30deg, extend))
  let b-variables = points-relative-from-angle(robots.B.pos, (5deg, extend), (10deg, extend), (15deg, extend))

  for (va, vb) in a-variables.slice(1, a-variables.len()-1).zip(b-variables.slice(1, b-variables.len()-1)) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    let scale = 0.25
    let interrobot-color = theme.green
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: theme.maroon + 2pt
    )

    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color + 2pt
    )
  }

  // A
  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: robots.A.color + 2pt)
  }
  robot("A", robots.A.pos, active: true, color: robots.A.color)

  // B
  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: robots.B.color + 2pt)
  }

  robot("B", robots.B.pos, active: false, color: robots.B.color)
})
#place(bottom + center, [
  D: Timestep #timestep($t_(n + 3)$)
])
]

// #pagebreak()

#let tn-5 = [

#cetz.canvas({
  import cetz.draw: *

  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (1.5, -0.5), color: theme.mauve)
  )
  let extend = 1

  let a-variables = points-relative-from-angle(robots.A.pos, (10deg, extend), (20deg, extend), (30deg, extend))
  let b-variables = points-relative-from-angle(robots.B.pos, (5deg, extend), (10deg, extend), (15deg, extend))

  for (va, vb) in a-variables.slice(1, a-variables.len()-1).zip(b-variables.slice(1, b-variables.len()-1)) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    let scale = 0.25
    let interrobot-color = theme.green
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: theme.maroon + 2pt
    )

    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: theme.maroon + 2pt
    )
  }

  // A
  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: robots.A.color + 2pt)
  }
  robot("A", robots.A.pos, active: false, color: robots.A.color)

  // B
  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: robots.B.color + 2pt)
  }

  robot("B", robots.B.pos, active: false, color: robots.B.color)
})
// #timestep($t_(n + 5)$)
#place(bottom + center, [
  E: Timestep #timestep($t_(n + 4)$)
])
]

// #pagebreak()

#let tn-k = [

#cetz.canvas({
  import cetz.draw: *

  scale(x: sc, y: sc)

  let robots = (
    A: (pos: (0, 2), color: theme.lavender),
    B: (pos: (1.8, -1.3), color: theme.mauve)
  )

  let extend = 1


  let a-variables = points-relative-from-angle(robots.A.pos, (20deg, extend), (35deg, extend), (50deg, extend))
  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: robots.A.color + 2pt)
  }
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.A.color, stroke: robots.A.color + 2pt)
  }

  robot("A", robots.A.pos, color: robots.A.color)

  let b-variables = points-relative-from-angle(robots.B.pos, (0deg, extend), (-10deg, extend), (-20deg, extend))
  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: robots.B.color + 2pt)
  }
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: robots.B.color, stroke: robots.B.color + 2pt)
  }

  robot("B", robots.B.pos, color: robots.B.color)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )
  }
})
#place(bottom + center, [
  F: Timestep #timestep($t_(n + k)$)
])
]

#{
  set align(center)
  set text(theme.text)
  grid(
    columns: (1fr, 1fr, 1fr),
    rows: 3,
    ..(
      tn,
      tn-1,
      tn-3,
      tn-4,
      tn-5,
      tn-k
    ).map(it => std-block(breakable: false, height: 66mm, v(1em) + it))
  )
}
