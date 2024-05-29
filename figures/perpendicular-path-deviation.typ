#set page(width: auto, height: auto, margin: 0pt)

#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../lib/vec2.typ"
#import "../lib/catppuccin.typ": catppuccin

#let theme = catppuccin.theme

#let drawing = cetz.canvas({
  import cetz.draw: *

  let theta = -calc.pi / 6
  let rotation = vec2.rotate-z.with(theta: theta)
  let waypoints = ((0, 0), (4, 3), (3.5, 6)).map(rotation)

  let s = 0.6
  let travelled-path = vec2.points-relative-from(
    waypoints.first(),
    (20deg, s),
    (8deg, s),
    (-5deg, s),
    (-12deg, s),
    (-5deg, s),
    (12deg, s),
    (23deg, s),
    (40deg, s),
    (55deg, s),
    (62deg, s),
    (62deg, s),
    (62deg, s),
  ) + (waypoints.last(), )

  let lines = windows(waypoints, 2).map(pair => {
    let start = pair.at(0)
    let end = pair.at(1)
    vec2.line-from-line-segment(start, end)
  })

  // draw perpendicular lines
  for p in travelled-path {
    let (closest, _) = lines
      .map(l => vec2.projection-onto-line(p, l.a, l.b))
      .map(proj => (proj, vec2.distance(p, proj)))
      .sorted(key: it => it.at(1))
      .first()

      line(p, closest, stroke: (dash: "dotted", paint: catppuccin.latte.overlay2, cap: "round"))
  }

  // draw green lines
  for (a, b) in windows(waypoints, 2) {
    line(a, b, stroke: (paint: theme.green))
  }

  // draw driven path in red
  for (a, b) in windows(travelled-path, 2) {
    circle(a, radius: 0.05, fill: theme.red, stroke: theme.red)
    line(a, b, stroke: (paint: theme.red))
  }

  // draw green waypoints
  for wp in waypoints {
    circle(wp, radius: 0.1, fill: theme.green.lighten(50%), stroke: theme.green)
  }
})

#pad(
  x: 1pt,
  y: 1pt,
  drawing
)
