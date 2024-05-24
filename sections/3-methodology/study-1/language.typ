#import "../../../lib/mod.typ": *
=== Implementation Language

#jonas[No need to read this section still. However how do we talk about choosing a specific language when we haven't performed rigorous tests on which one would be best for the implementation?]

This subsection describes the choice of implementation programming language used in both the simulation and the reimplementation of the gbpplanner paper. Motivations for why the language was chosen is laid out and argued for.

Both the simulator and the gbplanner reimplementation are written in the Rust programming language. Rust is a popular modern systems programming language with a lot of powerful capabilities to handle and manage complex software systems.


==== Why was Rust chosen?

The software

- `gbpplanner` is implemented in C++. We are both familiar with C++, but have in
  previous projects spent a lot
of time fighting its idiosyncrasies


#kristoffer[
  What other alternatives were available?
  C++
  Zig
  Odin

  Julia
  Python, too slow, and lack of a strong (enforced) type system had us worried about managing the implementation as the project codebase would grow.
]


A desire to learn the technology is one of the reasons why Rust was chosen. A lot of new systems are developed using Rust, and a lot of prominent authorities have publicly urged that new software project not be developed in unsafe languages such as C++.

#kristoffer[
  Explain some of the unique benefits of Rust.
  - borrow checker
  - ownership
  - memory safety
  - concurrency
  - Performance
  - Rich type system
  - Rich library ecosystem
  - Helpful error message
  - Error handling, errors as values, no exceptions
  - Exceptional tooling,
]

#kristoffer[
  Explain some of the drawbacks of Rust.
  - Complexity, can be hard to learn
  - Some design pattern/implementations are not trivial to implement. Especially self referential/recursive structures like graphs.
  - Slow compilation
  - Not as many very established libraries, like C++ which has been around for a lot longer
]

=== Signed Distance Field
