#let kristoffer(what) = {
  let c = color.orange
  block(fill: c.lighten(50%), stroke: c, inset: 1em, radius: 1em, what)
}

= Journal

#outline()

// #set datetime.display()

#let day = datetime(day: 29, month: 01, year: 2024)

== #day.display()

#kristoffer[
  Read these papers:
  -
]

