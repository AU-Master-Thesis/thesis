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
#show outline.entry.where(level: 1) : it => text(size: 1em, weight: "bold", it)

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
  paper-size: "a4", title: project-name, subtitle: "Computer Engineering Master Thesis", title-page: true, title-page-footer: align(
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

#outline()
#set-page-properties()

#include "sections/abstract.typ"
#include "sections/preface.typ"
#include "sections/nomenclature.typ"
#include "sections/introduction/mod.typ"
#include "sections/theory/mod.typ"
#include "sections/methodology/mod.typ"
