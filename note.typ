
#import "@preview/drafting:0.2.0": margin-note

#let krisoffer(note) = {
  let c = color.orange
  let note = [
    #text(c, "Kristoffer")
    #note
  ]

  // import "@preview/drafting:0.2.0": margin-note

  margin-note(side: left, stroke: c + 1pt, note)
}

#let jens(note) = {
  let c = color.aqua
  let note = [
    #text(c, "Jens")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)
}

#let jonas(note) = {
  let c = color.olive
  let note = [
    #text(c, "Jonas")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)

}

#let layout(note) = {
  let c = color.red
  let note = [
    #text(c, "Layout")
    #note
  ]

  margin-note(side: right, stroke: c + 1pt, note)

}
