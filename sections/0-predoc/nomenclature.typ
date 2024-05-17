#import "../../lib/mod.typ": *
= Nomenclature <nomenclature>

#jonas[This section is very WIP, no need to think about this.]

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
== Acronym Index
#v(1em)
#todo[Make acronym table break, so it starts on this page]
#print-index(title: "", delimiter: "")
