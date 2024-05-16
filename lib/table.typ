#import "blocks.typ": *

#let tablec(title: none, columns: none, header: none, alignment: auto, stroke: none, ..content) = {
  let column-amount = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    1
  }

  let header-rows = range(int(header.children.len() / column-amount))

  show table.cell : it => {
    if it.y in header-rows {
      set text(catppuccin.latte.text)
      strong(it)
    } else if calc.even(it.y) {
      set text(catppuccin.latte.text)
      it
    } else {
      set text(catppuccin.latte.text)
      it
    }
  }

  set align(center)
  set par(justify: false)
  set table.vline(stroke: white)

  cut-block(
    table(
      columns: columns,
      align: alignment,
      stroke: stroke,
      header,
      fill: (x, y) => if y in header-rows {
        catppuccin.latte.lavender.lighten(50%)
      } else if calc.even(y) { catppuccin.latte.crust } else { catppuccin.latte.mantle },
      gutter: -1pt,
      ..content
    )
  )
}
