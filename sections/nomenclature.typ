#import "../lib.typ": *
= Nomenclature <nomenclature>

- Interior Mutability

- `Test<T>` denotes a type `Test` which is generic over any type T

- Every capital letter in `monospace` is some type. A type in rust is either a
  struct, a tagged enum or a union.

#let acronyms = yaml("../acronyms.yaml")

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
#print-index(title: "", delimiter: "")
