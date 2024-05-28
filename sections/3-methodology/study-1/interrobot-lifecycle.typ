// #set page(width: auto, height: auto)
#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../../../lib/vec2.typ"
#import "../../../lib/mod.typ": *

// = InterRobot Factor Lifecycle

#pagebreak()

#jens[bait for you, use it however you see fit]

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
    // assert(type(point) == array)
    // assert(type(acc) == array)
    acc + (vec2.add(acc.last(), point),)
  })
}

// #points-relative-from((2, 2), (0, 1), (5, 0), (-1, 0))

#let timestep(t) = text(size: 22pt, $ #t $)
#let timestep(t) = text(size: 22pt, math.equation($ #t $))

#let variable = (
  radius: 0.3,
  color: red,
)

#let robot(name, pos, active: true) = {
  import cetz.draw: *
  let c = orange
  let communication-radius = 5
  let paint = if active { green } else { gray }
  circle(pos, radius: communication-radius, stroke: (dash: "dashed", paint: paint),
  // fill: gray.lighten(90%)
)

  circle(pos, radius: 0.5, fill: c.lighten(50%), stroke: c,  name: name)

  content(pos, name)
}

#let tn = [

#timestep($t_n$)

#cetz.canvas({
  import cetz.draw: *
  // coordinate-grid(10, 10)


  let robots = (
    A: (pos: (0, 2)),
    B: (pos: (2, -4))
  )


  let variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0), (1, 0.25))
  for vp in variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos)

  let variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 1))
  for vp in variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos)
})
]

// #pagebreak()

#let tn-1 = [
#timestep($t_(n + 1)$)

#cetz.canvas({
  import cetz.draw: *
  // coordinate-grid(10, 10)

  let robots = (
    A: (pos: (0, 2)),
    B: (pos: (2, -1))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0.2), (1, -0.1))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos)

  let b-variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 0.5))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    // line(va, vec2.add(va, normal.clockwise))
    // line(va, vec2.add(va, normal.counter-clockwise))

    // line(vb, vec2.add(vb, normal.clockwise))
    // line(vb, vec2.add(vb, normal.counter-clockwise))

    let scale = 0.25
    let interrobot-color = olive
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )


    // line(va, vb)
  }

  // let (a, b, c) = ((0, 0), (1, 1), (2, -1))
  // line(a, b, c, stroke: gray)
  // bezier-through(a, b, c, name: "b")
})

]

// #pagebreak()


#let tn-2 = [
#timestep($t_(n + 2)$)

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

   let robots = (
    A: (pos: (0, 2)),
    B: (pos: (3.2, -1))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0.5), (1, 1))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos)

  let b-variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 0.8))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    // line(va, vec2.add(va, normal.clockwise))
    // line(va, vec2.add(va, normal.counter-clockwise))

    // line(vb, vec2.add(vb, normal.clockwise))
    // line(vb, vec2.add(vb, normal.counter-clockwise))

    let scale = 0.25
    let interrobot-color = olive
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )


    // line(va, vb)
  }

  // let (a, b, c) = ((0, 0), (1, 1), (2, -1))
  // line(a, b, c, stroke: gray)
  // bezier-through(a, b, c, name: "b")
})

]

// #pagebreak()

#let tn-3 = [

#timestep($t_(n + 3)$)

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

   let robots = (
    A: (pos: (0, 2)),
    B: (pos: (3.2, -1))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0.5), (1, 1))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos, active: false)

  let b-variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 0.8))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    // line(va, vec2.add(va, normal.clockwise))
    // line(va, vec2.add(va, normal.counter-clockwise))

    // line(vb, vec2.add(vb, normal.clockwise))
    // line(vb, vec2.add(vb, normal.counter-clockwise))

    let scale = 0.25
    let interrobot-color = olive
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: gray
    )
  }
})

]

// #pagebreak()

#let tn-4 = [
#timestep($t_(n + 4)$)

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

   let robots = (
    A: (pos: (0, 2)),
    B: (pos: (3.2, -1))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0.5), (1, 1))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos, active: true)

  let b-variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 0.8))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos, active: false)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    // line(va, vec2.add(va, normal.clockwise))
    // line(va, vec2.add(va, normal.counter-clockwise))

    // line(vb, vec2.add(vb, normal.clockwise))
    // line(vb, vec2.add(vb, normal.counter-clockwise))

    let scale = 0.25
    let interrobot-color = olive
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: gray
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: interrobot-color
    )
  }
})

]

// #pagebreak()

#let tn-5 = [
#timestep($t_(n + 5)$)

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

   let robots = (
    A: (pos: (0, 2)),
    B: (pos: (3.2, -1))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.0), (1, 0.5), (1, 1))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos, active: false)

  let b-variables = points-relative-from(robots.B.pos, (0.95, 0.25), (1, 0.5), (1, 0.8))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos, active: false)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )

    // line(va, vec2.add(va, normal.clockwise))
    // line(va, vec2.add(va, normal.counter-clockwise))

    // line(vb, vec2.add(vb, normal.clockwise))
    // line(vb, vec2.add(vb, normal.counter-clockwise))

    let scale = 0.25
    let interrobot-color = olive
    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: gray
    )


    let control-point = vec2.add(vec2.add(va, vec2.scale(length / 2, dir)), vec2.scale(scale, normal.counter-clockwise))
    bezier-through(
      va,
      control-point,
      vb,
      stroke: gray
    )
  }
})
]

// #pagebreak()

#let tn-k = [
#timestep($t_(n + k)$)

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

   let robots = (
    A: (pos: (0, 4)),
    B: (pos: (3.9, -0.5))
  )


  let a-variables = points-relative-from(robots.A.pos, (1, 0.5), (1, 0.5), (1, 0.5))
  for vp in a-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(a-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("A", robots.A.pos)

  let b-variables = points-relative-from(robots.B.pos, (1, 0.25), (1, 0.5), (1, 0.2))
  for vp in b-variables.slice(1) {
    circle(vp, radius: variable.radius, fill: variable.color.lighten(50%), stroke: variable.color)
  }

  for (va, vb) in windows(b-variables, 2) {
    line(va, vb, stroke: gray)
  }
  robot("B", robots.B.pos)

  for (va, vb) in a-variables.zip(b-variables) {
    let dir = vec2.direction(va, vb)
    let length = vec2.distance(va, vb)

    let normal = (
      clockwise: (-dir.at(1), dir.at(0)),
      counter-clockwise: (dir.at(1), -dir.at(0)),
    )
  }
})

]

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: 3,
  stroke: gray,
  // inset: 2em,
  // gutter: 0.2em,
  ..(tn,
  tn-1,
  tn-2,
  tn-3,
  tn-4,
  tn-5,
  tn-k).map(it => block(it))
)
