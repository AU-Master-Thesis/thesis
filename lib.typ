#import "template.typ": *
#import "catppuccin.typ": *
#import "@preview/codelst:1.0.0": sourcecode, codelst, sourcefile
#import "@preview/tablex:0.0.6": *
#import "@preview/drafting:0.2.0": *
#import "@preview/cetz:0.2.2": *

#let theme = catppuccin.latte
#let accent = theme.lavender

#let hr = line(length: 100%)

#let std-block = block.with(
  fill: catppuccin.latte.base, radius: 1em, inset: 0.75em, stroke: none, width: 100%, breakable: true,
)

#let sourcecode = sourcecode.with(
  frame: std-block, numbers-style: (lno) => move(
    dy: 1pt, text(
      font: "JetBrains Mono", size: 0.75em, catppuccin.latte.overlay0.lighten(50%), lno,
    ),
  ),
)

#let sourcefile = sourcefile.with(
  frame: std-block, numbers-style: (lno) => move(
    dy: 1pt, text(
      font: "JetBrains Mono", size: 0.75em, catppuccin.latte.overlay0.lighten(50%), lno,
    ),
  ),
)

#let snippet = sourcecode.with(numbering: none, frame: std-block.with(inset: 2pt, radius: 3pt))

#let tablex = tablex.with(stroke: 0.25pt, auto-lines: false, inset: 0.5em)

#let rule = hlinex(stroke: 0.25pt)
#let thick-rule = hlinex(stroke: 0.75pt)
#let double-rule(cols) = (hlinex(), colspanx(cols)[#v(-0.75em)], hlinex(),)

#let boxed(content, color: accent.lighten(0%), fill: none, weight: 400) = {
  if (fill == none) {
    fill = color.lighten(80%)
  }
  box(
    fill: fill, radius: 3pt, inset: (x: 2pt), outset: (y: 2pt), text(color, weight: weight, content),
  )
}

// #let list-box(title, content) = {
//   gridx(
//     columns: (1em, 1fr),
//     column-gap: 1pt,
//     [], [#boxed(title) #content],
//   )
//   // v(-3.25em)
// }

#let no-indent(content) = {
  set par(first-line-indent: 0pt)
  content
}

#let todo(txt) = boxed(
  color: theme.maroon.lighten(0%), fill: theme.maroon.lighten(80%), [*Todo:* #txt],
)

#let jens(txt) = boxed(
  color: theme.teal.lighten(0%), fill: theme.teal.lighten(80%), [*Jens:* #txt],
)

#let kristoffer(txt) = boxed(
  color: theme.green.lighten(0%), fill: theme.green.lighten(80%), [*Kristoffer:* #txt],
)

#let pernille(txt) = boxed(
  color: theme.mauve.lighten(0%), fill: theme.mauve.lighten(80%), [*Pernille:* #txt],
)

#let bastian(txt) = boxed(
  color: theme.blue.lighten(0%), fill: theme.blue.lighten(80%), [*Bastian:* #txt],
)

#let emil(txt) = boxed(
  color: theme.pink.lighten(0%), fill: theme.pink.lighten(80%), [*Emil:* #txt],
)

#let magnus(txt) = boxed(
  color: theme.peach.lighten(0%), fill: theme.peach.lighten(80%), [*Magnus:* #txt],
)

#let daniel(txt) = boxed(
  color: theme.yellow.lighten(0%), fill: theme.yellow.lighten(80%), [*Daniel:* #txt],
)

#let boxed-enum(
  prefix: "", suffix: "", color: accent.lighten(0%), fill: accent.lighten(80%), ..numbers,
) = boxed(
  color: color, fill: fill, prefix + numbers.pos().map(str).join(".") + "." + suffix, weight: 900,
)

#let req-enum(prefix: "R-", ..numbers) = boxed(
  color: accent.lighten(0%), fill: accent.lighten(80%), text(weight: 900, prefix + numbers.pos().map(n => {
    if n < 10 {
      "0" + str(n)
    } else {
      str(n)
    }
  }).join(".")),
)

#let vdmpp(text) = raw(text, block: false, lang: "vdmpp")

#let requirement-heading(content) = heading(
  level: 2, supplement: "Requirement", numbering: none, outlined: false, content,
)
#let req(content) = {
  boxed(weight: 900)[R-#content]
  h(0.5em)
}

#let abstraction-counter = counter("abstraction-counter")

#let abstraction-id = {
  abstraction-counter.step()
  boxed("A" + abstraction-counter.display(), weight: 900)
}

#let cy(content) = text(catppuccin.latte.yellow, content)
#let cr(content) = text(catppuccin.latte.maroon, content)
#let cg(content) = text(catppuccin.latte.green, content)
#let cb(content) = text(catppuccin.latte.lavender, content)
#let cp(content) = text(catppuccin.latte.mauve, content)

#let ra = sym.arrow.r

#let swatch(color, content: none, s: 6pt) = {
  if content != none {
    content
    // h(0.1em)
  }
  h(1pt, weak: true)
  box(
    height: s, width: s, fill: color,
    // stroke: 1pt + color,
    radius: s / 2, baseline: (s - 0.5em) / 2,
  )
}

#let sy = swatch(catppuccin.latte.yellow)
#let sr = swatch(catppuccin.latte.maroon)
#let sg = swatch(catppuccin.latte.green)
#let sb = swatch(catppuccin.latte.blue)
#let sp = swatch(catppuccin.latte.mauve)
#let sgr = swatch(catppuccin.latte.surface0)
#let sl = swatch(catppuccin.latte.lavender)

#let nameref(label, name, supplement: none) = {
  show link : it => text(accent, it)
  link(label, [#ref(label, supplement: supplement). #name])
}

#let numref(label) = ref(label, supplement: none)

#let scen(content) = boxed(color: catppuccin.latte.yellow, content)

#let toc-printer(target: none) = {
  set par(first-line-indent: 0em)
  outline(
    indent: 2em,
    // fill: repeat("_"),
    fill: grid(
      // column-gutter: 
      columns: 1,
      block(
        fill: black,
        height: 0.5pt,
        width: 100%,
      ),
    ),
    depth: 2,
    target: target,
    title: none,
  )
}

#let hline-with-gradient(cmap: color.map.inferno, height: 2pt) = rect(width: 100%, height: height, fill: gradient.linear(..cmap))
