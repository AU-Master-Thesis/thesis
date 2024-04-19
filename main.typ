#import "lib.typ": *
#import "text-case.typ": *


#show figure.where(kind: raw): set block(breakable: true)

#show raw.where(block: false): (it) => {
  set text(catppuccin.latte.text, font: "JetBrains Mono", size: 1em)
  box(
    fill: catppuccin.latte.base,
    inset: (x: 2pt),
    outset: (y: 2pt),
    radius: 3pt,
    stroke: none,
    it,
  )
}

// #show link: it => underline(text(accent)[#it])
#show link: it => text(accent)[#it]

#set list(marker: text(catppuccin.latte.lavender, sym.diamond.filled))
#set enum(full: true)

#show outline.entry.where() : it => {
  let t = it.body.fields().values().at(0)

  let size = 1em
  let color = black
  let weight = "medium"

  if it.level == 1 {
    v(1em)
    size = 1.2em
    color = accent
    weight = "black"
  }

  if type(t) == "array"  {
    v(-3em)
    // h(it.element.level * 2em)
    grid(
      column-gutter: 2pt,
      columns: ((it.element.level - 1) * 2em, auto, 1fr, auto),
      align: (center, left + bottom, center + bottom, right + bottom),
      [],
      text(color, size: size, weight: weight, [
        #it.body.fields().values().at(0).at(0)
        #h(0.85em)
        #it.body.fields().values().at(0).slice(2).join(" ")
        // #repr(it.fill)
      ]),
      block(
        fill: color,
        height: 0.5pt,
        width: 100%,
      ),
      text(color, size: 1em, weight: weight, it.page),
    )
  } else {
    v(-3em)
    // text(accent, size: 1.2em, weight: black, it)
    grid(
      column-gutter: 2pt,
      columns: (0em, auto, 1fr, auto),
      align: (center, left + bottom, center + bottom, right + bottom),
      [],
      text(color, size: size, weight: weight, it.body),
      block(
        fill: color,
        height: 0.5pt,
        width: 100%,
      ),
      text(color, size: 1em, weight: weight, it.page),
    )
  }
}

// OVERSKRIFTER
#show heading.where(numbering: "1.1") : it => [
  #v(1em)
  #block({
    box(
      width: 13mm,
      text(counter(heading).display(), weight: 600))
    text(it.body, weight: 600)
  })
  #v(1em)
]

#show heading.where(level: 1) : it => text(accent, size: 18pt)[
  #pagebreak(weak: true)
  #let subdued = theme.text.lighten(50%)
  #set text(font: "JetBrainsMono NF")

  #grid(
    columns: (1fr, 1fr),
    align: (left + bottom, right + top),
    text(it.body, size: 24pt, weight: "bold"),
      if it.numbering != none
    {
      text(subdued, weight: 200, size: 100pt)[#counter(heading).get().at(0)]
      v(1.5em)
    },
  )
  #v(-0.5em)
  // #hr
  #hline-with-gradient(cmap: (accent, subdued), height: 2pt)
  #v(1.5em)
]

#let project-name = "Multi-agent Collaborative Path Planning"

#let authors = (
  (
    name: "Kristoffer Plagborg Bak Sørensen",
    email: "201908140@post.au.dk",
    auid: "au649525",
  ),
  (
    name: "Jens Høigaard Jensen",
    email: "201907928@post.au.dk",
    auid: "au649507",
  ),
).map(
  author => {
    author + (
      department: [Department of Electrical and Computer Engineering],
      organization: [Aarhus University],
      location: [Aarhus, Denmark],
    )
  },
)

#show: paper.with(
  paper-size: "a4",
  title: project-name,
  subtitle: "Computer Engineering Master Thesis",
  title-page: true,
  title-page-extra: align(center, [
    Bloop
  ]),
  title-page-footer: align(
    center,
  )[
    #gridx(columns: (30%, 40%), align: center + horizon)
    #gridx(
      columns: 2, row-gutter: 0em, align: (x, y) => (right, left).at(x),
      [*Supervisor:*], [Andriy Sarabakha],
      [*Co-supervisor:*], [Jonas le-Fevre Sejersen],
    )
    #v(2mm, weak: true)
    \{andriy, jonas.le.fevre\}\@ece.au.dk
    #v(5mm, weak: true)
    #image("img/au-logo.svg", width: 30%)
  ],
  authors: authors,
  date: datetime.today().display("[day]-[month]-[year]"),
  // bibliography-file: "references.bib",
  print-toc: false,
  toc-depth: 2,
  accent: accent,
)

// #outline()
// #set-page-properties()

// This is important! Call it whenever your page is reconfigured.
#set-page-properties()

#if "release" in sys.inputs {
  set-margin-note-defaults(hidden: true)
} else {
  set-margin-note-defaults(hidden: false)
}


// Pre-introduction
#set heading(numbering: none)
// #set page(numbering: "i")
#include "sections/abstract.typ"
#include "sections/preface.typ"
#include "sections/nomenclature.typ"

// Table of Contents
#pagebreak(weak: true)
#heading([Contents], level: 1, numbering: none, outlined: false)

#v(5em)
#toc-printer(target: heading.where(numbering: none))

// #line(start: 0, end: 100%)

#let main-numbering = "1.1"
#v(2em)
#toc-printer(target: heading.where(numbering: main-numbering))

// Report
#set heading(numbering: main-numbering)
#set page(numbering: "1")
#counter(heading).update(0)
#counter(page).update(1)
#include "sections/introduction/mod.typ"
#include "sections/background/mod.typ"
#include "sections/methodology/mod.typ"
#include "sections/results/mod.typ"
#include "sections/discussion/mod.typ"
#include "sections/conclusion/mod.typ"
#include "sections/future-work.typ"

#bibliography("./references.yaml", style: "the-institution-of-engineering-and-technology")
