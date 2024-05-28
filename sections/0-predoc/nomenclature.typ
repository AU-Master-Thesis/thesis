#import "../../lib/mod.typ": *
= Nomenclature <nomenclature>


#par(first-line-indent: 0pt)[Some terminology and type setting used in this thesis may not be familiar to the reader, and are explained here for clarity.]

#term-table(
  [*crate*], [
  A crate is a compilation unit in Rust. It contains the modules, types and functions that together makes up a logical grouping of source code. For the purpose of this thesis it can interchaintably be substituted with the notion of a _library_ found in many other programming languages.
],
  [`monospace`], [Monospace text is used for inline code snippets and direct reference to files.],
  [`T`], [Any monospaced text starting with a capital letter refers to a Rust type. A type in Rust is either a struct, a tagged enum or a union.],
  [`Container<'a, T>`], [A type `Container` which is generic over a lifetime `'a` and a type `T` with no constraints. A lifetime is a concept unique to Rust that describes a constraint on how long a reference to a value must at least be available for.

],
  [`<file>`], [A reference to a specific source file e.g. `config.toml`],
  [`<file>:<int>`], [A reference to a specific source file and line number e.g. `config.toml:5`],
  [`<file>:<int>-<int>`], [A reference to a specific source file and line number range e.g. `config.toml:5-10`],
  // [#source-link("https://www.youtube.com/watch?v=dQw4w9WgXcQ", "<file>")], [],
  [#source-link("https://github.com/AU-Master-Thesis/gbp-rs", "<file>")], [A hyperlink reference to a specific source file or repository.],
  // [*Inline Figures* #h(0.5em)  #sr], []
)

// https://au-master-thesis.github.io/gbp-rs/

#let acronyms = yaml("../../acronyms.yaml")

#let acrostiche-acronyms = merge(..acronyms.map(it => {
  let v = (it.definition,)
  if "plural" in it {
    v.push(it.plural)
  }

  (it.acronym: v)
}))


#init-acronyms(acrostiche-acronyms)
// == Acronym Index
// #v(1em)
// #todo[Make acronym table break, so it starts on this page]
// #print-index(title: "", delimiter: "")


#let print-acronyms(level: 1, outlined: false, sorted:"", title:"Acronyms Index", delimiter:":") = {
  //Print an index of all the acronyms and their definitions.
  // Args:
  //   level: level of the heading. Default to 1.
  //   outlined: make the index section outlined. Default to false
  //   sorted: define if and how to sort the acronyms: "up" for alphabetical order, "down" for reverse alphabetical order, "" for no sort (print in the order they are defined). If anything else, sort as "up". Default to ""
  //   title: set the title of the heading. Default to "Acronyms Index". Passing an empty string will result in removing the heading.
  //   delimiter: String to place after the acronym in the list. Defaults to ":"

  // assert on input values to avoid cryptic error messages
  assert(sorted in ("","up","down"), message:"Sorted must be a string either \"\", \"up\" or \"down\"")

  if title != ""{
    heading(level: level, outlined: outlined)[#title]
  }


  let cells = ()


  state("acronyms",none).display(acronyms=>{

    // Build acronym list
    let acr-list = acronyms.keys()

    // order list depending on the sorted argument
    if sorted!="down"{
      acr-list = acr-list.sorted()
    }else{
      acr-list = acr-list.sorted().rev()
    }

    // print the acronyms
    let cells = ()

    for acr in acr-list {
      let acr-long = acronyms.at(acr)
      let acr-long = if type(acr-long) == array {
        acr-long.at(0)
      } else {
        acr-long
      }

      cells.push(acr)
      cells.push(acr-long)
    }

    assert(calc.rem(cells.len(), 2) == 0)

    let split = 50
    // let split = int(cells.len() / 2)
    let first-half = cells.slice(0, split)
    let last-half = cells.slice(split)

    show table.cell.where(x: 0): strong

    let t(cells) = tablec(
      columns: 2,
      align: (right, left),
      header: table.header([Acronym], [Definition]),
      ..cells
    )

    grid(
      columns: 2,
      t(first-half),
      t(last-half),
    )
})
}

#print-acronyms(level: 1, outlined: true)
