#import "../../lib/mod.typ": *
= Nomenclature <nomenclature>

#jonas[This section is very WIP, no need to think about this.]

#todo[Something about the Rust ecosystem like what is a crate?]

- Interior Mutability

- `Test<T>` denotes a type `Test` which is generic over any type T

- Every capital letter in `monospace` is some type. A type in rust is either a
  struct, a tagged enum or a union.

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
