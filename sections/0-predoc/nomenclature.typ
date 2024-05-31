#import "../../lib/mod.typ": *
= Nomenclature <nomenclature>
#jonas[Check this out]

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
  [#source-link("https://github.com/AU-Master-Thesis/gbp-rs", "<file>")], [A hyperlink reference to a specific source file or repository. Can be clicked on in a PDF viewer to access the URL.],
  // [*Inline Figures* #h(0.5em)  #sr], []
)
