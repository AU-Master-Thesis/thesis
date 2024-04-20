
#import "@preview/drafting:0.2.0": margin-note
#import "catppuccin.typ": *

#let krisoffer(note) = {
  let c = catppuccin.latte.yellow
  let note = [
    #text(c, "Kristoffer")
    #note
  ]

  // import "@preview/drafting:0.2.0": margin-note

  margin-note(side: left, stroke: c + 1pt, note)
}

#let jens(note) = {
  let c = catppuccin.latte.mauve
  let note = [
    #text(c, "Jens")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)
}

#let jonas(note) = {
  let c = catppuccin.latte.blue
  let note = [
    #text(c, "Jonas")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)

}

#let layout(note) = {
  let c = catppuccin.latte.maroon
  let note = [
    #text(c, "Layout")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)

}
