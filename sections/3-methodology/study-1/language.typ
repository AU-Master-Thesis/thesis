#import "../../../lib/mod.typ": *
=== Implementation Language

#jonas[No need to read this section still. However how do we talk about choosing a specific language when we haven't performed rigorous tests on which one would be best for the implementation?]

This subsection describes the choice of implementation programming language used in both the simulation and the reimplementation of the gbpplanner paper. Motivations for why the language was chosen is laid out and argued for.

Both the simulator and the gbplanner reimplementation are written in the Rust programming language. Rust is a popular modern systems programming language with a lot of powerful capabilities to model and manage complex software systems.


==== Why was Rust chosen?

The software for `gbpplanner` is implemented in the C++ programming language@gbpplanner-code. A common choice used in robotics and simulation developments due to its capabilities to compile to very efficient machine code. High level programming structures such as templates and generic programming can be utilized with little to no performance cost. A property referred to as zero cost abstractions@tour-of-cpp. Manual memory management is used instead garbage collection which allows one to ensure predictable latency which in many real time algorithms is a hard requirement. To better understand the algorithm and to validate that the it works across different programming languages and are not dependant on features exclusive to C++ the Rust programming language was used instead. Rust is able to achieve many of the same performance qualities as C++, allowing in to operate in the same domains:

- Deterministic deallocation of resources using the #acr("RAII") pattern, equivalent to C++'s use of destructors@tour-of-cpp@the-rust-book.
- High level abstractions such as generic programming and traits that gets compiled to efficent machine code@the-rust-book.
- No garbage collection
- Zero cost abstractions, such as composable iterators, usually found in pure functional programming languages@the-rust-book.
- Low level control over hardware and operating system resources.






#line(length: 100%, stroke: 10pt + red)

// - Explore newer alternatives that matches C++ in terms of performance, but allows for other qualities.

// - to validate that the algorithm works across different programming languages and are not dependant on features exclusive to C++.

- exhaustive pattern matching is useful for any future factors that needs to added to the implementation as the compiler would require that all uses of it are handled explicitly.

- Secondly the implementation have no hard dependencies on C++ or C only frameworks such as ROS2 that are popular in the robotics community and industry.

- See a lot of popularity and want the to contribute to robotics related research and experimentation in the language to prove its usefullness/applicability in multiple domains.

- white house paper that urges developers to move away from C++ and focus on memory safe languages like Rust. Also cite Google CVE papers about vulnabilities that Rust can prevent alone by the compiler.

- The most beloved language in by software developers many years in a row, Stack Overflow


- the domain of numeric quantities




#todo[
  What other alternatives were available?
  C++
  Zig
  Odin

  Julia
  Python, too slow, and lack of a strong (enforced) type system had us worried about managing the implementation as the project codebase would grow.
]



#todo[
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


- `cargo`

- `gbpplanner` is implemented in C++. We are both familiar with C++, but have in
  previous projects spent a lot of time fighting its idiosyncrasies.


A desire to learn the technology is one of the reasons why Rust was chosen. A lot of new systems are developed using Rust, and a lot of prominent authorities have publicly urged that new software project not be developed in unsafe languages such as C++.

- Finally a non-technical reason the authors were curious about the touted benefits of the language and wanted to 

- well positioned to have significant influence on software development now and even more so in the future.
