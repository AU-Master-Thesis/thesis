#set page(width: auto, height: auto)

#import "@preview/cetz:0.2.2"
#import "@preview/funarray:0.4.0": windows
#import "../lib/vec2.typ"
#import "../lib/catppuccin.typ": catppuccin

#let theme = catppuccin.theme

// #import "common.typ": *
#let coordinate-grid(x, y) = {
  import cetz.draw: *

  let x-max = x
  let y-max = y
  let x-min = -x-max
  let y-min = -y-max
  grid((x-min, y-min), (x-max,y-max), stroke: gray.lighten(50%))
  line((x-min, 0), (x-max, 0), stroke: red)
  line((0, y-min), (0, y-max), stroke: green)
}

#cetz.canvas({
  import cetz.draw: *

  coordinate-grid(5, 5)

})
