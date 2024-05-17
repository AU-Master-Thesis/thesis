#set page(width: auto, height: auto, margin: 0pt)

#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../lib/vec2.typ"
#import "../lib/catppuccin.typ": catppuccin

#let theme = catppuccin.theme

#cetz.canvas({
  import cetz.draw: *

  // coordinate-grid(10, 10)

  let theta = -calc.pi / 6
  let rotation = vec2.rotate-z.with(theta: theta)
  let waypoints = ((0, 0), (4, 3), (3.5, 6)).map(rotation)

  for (a, b) in windows(waypoints, 2) {
    line(a, b, stroke: (paint: theme.green))
  }

  let travelled-path = (
    waypoints.first(),
    (0.15, 0.5),
    (0.3, 0.8),
    (0.5, 1.2),
    (0.75, 1.3),
    (1, 1.4),
    (1.2, 1.7),
    (1.5, 2.0),
    (1.8, 2.2),
    (2.1, 2.5),
    (2.4, 2.65),
    (2.7, 3.0),
    (2.8, 3.4),
    (3.0, 3.7),
    (3.0, 4.0),
    (3.2, 4.3),
    (3.3, 4.8),
    (3.35, 5.3),
    // waypoints.last(),
  ).map(rotation) + (waypoints.last(), )



  let lines = windows(waypoints, 2).map(pair => {
    let start = pair.at(0)
    let end = pair.at(1)
    vec2.line-from-line-segment(start, end)
  })

    for p in travelled-path {
    let (closest, _) = lines
      .map(l => vec2.projection-onto-line(p, l.a, l.b))
      .map(proj => (proj, vec2.distance(p, proj)))
      .sorted(key: it => it.at(1))
      .first()

      line(p, closest, stroke: (dash: "dashed", paint: gray))

    // for l in lines {
    //   let proj = vec2.projection-onto-line(p, l.a, l.b)

    //   line(p, proj, stroke: (paint: red))
    // }
  }

    for (a, b) in windows(travelled-path, 2) {
    circle(a, radius: 0.05, fill: theme.red, stroke: theme.red)
    line(a, b, stroke: (paint: theme.red))
  }

  for wp in waypoints {
    circle(wp, radius: 0.1, fill: green.lighten(50%), stroke: theme.green)
  }



  // let line-segment = (waypoints.at(0), waypoints.at(1))


})
