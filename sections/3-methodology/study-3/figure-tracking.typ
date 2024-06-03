#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../../../lib/vec2.typ"
#import "../../../lib/mod.typ": *

#{
  let sc = 55%

  let color-counter = 0
  let settings = (
    variable: (
      radius: 0.2,
      spacing: 1.5
    ),
    robot: (
      radius: 0.5,
    ),
    rrt: (
      step-length: 2,
    ),
    path: (
      color: theme.overlay0,
      waypoint: (
        radius: 0.2
      )
    ),
    tracking: (
      color: theme.peach,
      area: theme.green,
    )
  )

  let draw-robot(name, position, color: theme.lavender) = {
    import cetz.draw: *

    // let color = settings.robot.colors.at(color-counter)
    // color-counter = calc.rem(color-counter + 1, settings.robot.colors.len())

    circle(position, radius: settings.robot.radius, fill: color.lighten(80%), stroke: color + 2pt, name: name)
    content(position, text(color, font: "JetBrainsMono NF", weight: "bold", name))
  }

  let draw-variable(position, color: theme.lavender) = {
    import cetz.draw: *
    circle(position, radius: settings.variable.radius, fill: color, stroke: color + 2pt)
  }

  let robot(name, center, variables: none, color: theme.lavender) = {
    import cetz.draw: *
    // make sure the denter is a 2D vector
    assert(center.len() == 2)
    for i in range(2) {
      let t = type(center.at(i))
      assert(t == float or t == int)
    }

    // make sure that variables is an array of angles
    for variable in variables {
      assert(type(variable) == "angle")
    }

    let cx = center.at(0)
    let cy = center.at(1)


    if variables != none {
      let variable_points = vec2.points-relative-from(center, ..variables.map(it => (it, settings.variable.spacing)))
      for (v1, v2) in windows(variable_points, 2) {
        line(v1, v2, stroke: color + 2pt)
        draw-variable(v2, color: color)
      }
    }

    draw-robot(name, center, color: color)
  }


  let drawing-1 =cetz.canvas({
    import cetz.draw: *
    scale(x: sc, y: sc)

    let robots = (
      (
        name: "A",
        color: theme.lavender,
        position: (0.5, 2),
        variables: (
          (10deg),
          (0deg),
          (-5deg),
          (-5deg),
          (5deg),
          (15deg),
          (30deg),
          (25deg),
          (5deg),
          (-20deg),
          (-35deg),
          (-55deg),
        )
      ),
    )

    // Path
    let first-waypoint = (0, 0)
    let sl = settings.rrt.step-length
    let waypoints = vec2.points-relative-from(
      first-waypoint,
      (15, 5),
      (3, -5),
    )

    // draw corner attachment range
    let l1 = vec2.normalize(vec2.sub(waypoints.at(1), waypoints.at(0)))
    let l2 = vec2.normalize(vec2.sub(waypoints.at(2), waypoints.at(1)))
    let n1 = vec2.normals(l1)
    let n2 = vec2.normals(l2)

    let ns = 2.5
    let ns2 = -2
    let ns3 = 2.5
    let ns4 = 2.5

    let s1 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(2, vec2.sub((0, 0), l1))), vec2.scale(ns3, n1.counter))

    let s2-1 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(2, vec2.sub((0, 0), l1))), vec2.scale(ns, n1.clockwise))
    let s2-2 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(2, l2)), vec2.scale(ns, n2.clockwise))

    let s2-3 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(ns2, vec2.sub((0, 0), l1))), vec2.scale(ns3, n1.counter))
    let s2-4 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(ns2, l2)), vec2.scale(ns4, n2.counter))


    let s3 = vec2.add(vec2.add(waypoints.at(1), vec2.scale(2, l2)), vec2.scale(ns4, n2.counter))

    let c = settings.tracking.area.lighten(60%)
    circle(s1, radius: 0.1, fill: c, stroke: none)

    circle(s2-1, radius: 0.1, fill: c, stroke: none)
    circle(s2-2, radius: 0.1, fill: c, stroke: none)

    circle(s2-3, radius: 0.1, fill: c, stroke: none)
    circle(s2-4, radius: 0.1, fill: c, stroke: none)

    circle(s3, radius: 0.1, fill: c, stroke: none)

    line(s1, s2-1, s3, s2-3, close: true, fill: c.lighten(70%), stroke: (paint: c, thickness: 2pt, cap: "round", dash: "dashed"))


    let r = settings.path.waypoint.radius
    let c = settings.path.color
    circle(first-waypoint, radius: r, fill: c, stroke: none)
    content(vec2.add(first-waypoint, (0, 1)), text(c, size: 15pt, $w_0$))
    for (i, (p1, p2)) in windows(waypoints, 2).enumerate() {
      circle(p2, radius: r, fill: c, stroke: none)
      line(p1, p2, stroke: c + 2pt)
      content(vec2.add(p2, (0.8, 0.8)), text(c, size: 15pt, $w_#{i + 1}$))
    }

    for r in robots {
      let variable-positions = vec2.points-relative-from(r.position, ..r.variables.map(it => (it, settings.variable.spacing)))
      variable-positions = variable-positions.slice(1, variable-positions.len())

      // project onto line segment 1
      let (a, b) = vec2.line-from-line-segment(..waypoints.slice(0, 2))
      let variables1 = variable-positions.slice(0, 8)
      let proj1 = variables1.map(v => {
        let dir = vec2.normalize(vec2.sub(waypoints.at(1), waypoints.at(0)))
        let proj = vec2.add(vec2.projection-onto-line(v, a, b), vec2.scale(0.75, dir))
        proj
      })

      // project onto line segment 2
      let (a, b) = vec2.line-from-line-segment(..waypoints.slice(1, 3))
      let variables2 = variable-positions.slice(10, 12)
      let proj2 = variables2.map(v => {
        let dir = vec2.normalize(vec2.sub(waypoints.at(2), waypoints.at(1)))
        let proj = vec2.add(vec2.projection-onto-line(v, a, b), vec2.scale(0.75, dir))
        proj
      })

      // draw tracking points
      let c = settings.tracking.color
      let tracking-points = proj1 + (waypoints.at(1), waypoints.at(1)) + proj2
      for (proj, v) in tracking-points.zip(variable-positions) {
        line(proj, v, stroke: (paint: c, thickness: 2pt, cap: "round"))
        circle(proj, radius: 0.1, fill: c, stroke: c)
      }

      // draw variables
      for v in variable-positions {
        circle(v, radius: settings.variable.radius, fill: r.color, stroke: r.color + 2pt)
      }
    }
  })

  let drawing-2 = cetz.canvas({
    import cetz.draw: *
    scale(x: sc, y: sc)
    rotate(-90deg)

    let robots = (
      (
        name: "R",
        color: theme.lavender,
        position: (0.5, -1.5),
        variables: (
          (-80deg + 90deg),
          (-70deg + 90deg),
          (-70deg + 90deg),
          (-75deg + 90deg),
          (-90deg + 90deg),
          (-95deg + 90deg),
        )
      ),
    )

    let waypoints = (
      (0, 0),
      (10, 0),
    )

    // draw path
    let r = settings.path.waypoint.radius
    let c = settings.path.color
    circle(waypoints.first(), radius: r, fill: c, stroke: none)
    for (p1, p2) in windows(waypoints, 2) {
      circle(p2, radius: r, fill: c, stroke: none)
      line(p1, p2, stroke: c + 2pt)
    }

    let variable-positions = vec2.points-relative-from(robots.at(0).position, ..robots.at(0).variables.map(it => (it, settings.variable.spacing)))

    let projs = variable-positions.map(v => {
      let (a, b) = vec2.line-from-line-segment(..waypoints)
      let dir = vec2.normalize(vec2.sub(waypoints.at(1), waypoints.at(0)))
      let proj = vec2.add(vec2.projection-onto-line(v, a, b), vec2.scale(0.75, dir))
      proj
    })

    for (proj, v) in projs.zip(variable-positions) {
      line(proj, v, stroke: (paint: settings.tracking.color, thickness: 2pt, cap: "round"))
      circle(proj, radius: 0.1, fill: settings.tracking.color, stroke: settings.tracking.color)
    }

    for r in robots {
      robot(r.name, r.position, variables: r.variables, color: r.color)
    }

    content(vec2.add(waypoints.first(), (0, 1)), text(c, size: 15pt, $w_0$))
    content(vec2.add(waypoints.last(), (0, 1)), text(c, size: 15pt, $w_1$))
  })

  set text(theme.text)
  set align(center)
  grid(
    columns: (3fr, 1fr),
    std-block(height: 70mm, [#drawing-1 #place(bottom + center, [A: Tracking Along Path])]),
    std-block(height: 70mm, [#drawing-2 #place(bottom + center, [B: Exemplification])]),
  )
}
