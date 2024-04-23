#import "@preview/drafting:0.2.0": margin-note
#import "catppuccin.typ": *

#let note-gen(note, c: color.red, scope: "") = {
  let note = [
    #text(c, scope)
    #note
  ]

  margin-note(side: left, stroke: c + 1pt, note)
}

#let kristoffer = note-gen.with(c: catppuccin.latte.yellow, scope: "Kristoffer")
#let jens = note-gen.with(c: catppuccin.latte.mauve, scope: "Jens")
#let jonas = note-gen.with(c: catppuccin.latte.blue, scope: "Jonas")
#let layout = note-gen.with(c: catppuccin.latte.maroon, scope: "Layout")
#let wording = note-gen.with(c: catppuccin.latte.teal, scope: "Wordings")

// #let krisoffer(note) = {
//   let c = catppuccin.latte.yellow
//   let note = [
//     #text(c, "Kristoffer")
//     #note
//   ]
//
//   margin-note(side: left, stroke: c + 1pt, note)
// }

// #let jens(note) = {
//   let c = catppuccin.latte.mauve
//   let note = [
//     #text(c, "Jens")
//     #note
//   ]
//
//   margin-note(side: right, stroke: c + 1pt, note)
// }
//
// #let jonas(note) = {
//   let c = catppuccin.latte.blue
//   let note = [
//     #text(c, "Jonas")
//     #note
//   ]
//
//   margin-note(side: right, stroke: c + 1pt, note)
// }
//
// #let layout(note) = {
//   let c = catppuccin.latte.maroon
//   let note = [
//     #text(c, "Layout")
//     #note
//   ]
//
//   margin-note(side: right, stroke: c + 1pt, note)
// }
//
// #let wording(note) = {
//   let c = catppuccin.latte.teal
//   let note = [
//     #text(c, "Layout")
//     #note
//   ]
//
//   margin-note(side: right, stroke: c + 1pt, note)
// }
