#import "../../../lib/mod.typ": *
=== Implementation Language

#jonas[No need to read this section still. However how do we talk about choosing a specific language when we haven't performed rigorous tests on which one would be best for the implementation?]

This subsection describes the choice of implementation programming language used in both the simulation and the reimplementation of the gbpplanner paper. Motivations for why the language was chosen is laid out and argued for.

Both the simulator and the gbplanner reimplementation are written in the Rust programming language. Rust is a popular modern systems programming language with a lot of powerful capabilities to model and manage complex software systems.


==== Why was Rust chosen?

The software for #gbpplanner is implemented in the C++ programming language@gbpplanner-code. A common choice used in robotics and simulation developments due to its capabilities to compile to very efficient machine code. High level programming structures such as templates and generic programming can be utilized with little to no performance cost. A property referred to as zero cost abstractions@tour-of-cpp. Manual memory management is used instead garbage collection which allows one to ensure predictable latency which in many real time algorithms is a hard requirement. To better understand the algorithm and to validate that the it works across different programming languages and are not dependant on features exclusive to C++ the Rust programming language was used instead. Rust is able to achieve many of the same performance qualities as C++, allowing in to operate in the same domains:

- Deterministic deallocation of resources using the #acr("RAII") pattern, equivalent to C++'s use of destructors@tour-of-cpp@the-rust-book.
- High level abstractions such as generic programming and traits that gets compiled to efficient machine code@the-rust-book.
- No garbage collection
- Zero cost abstractions, such as composable iterators, usually found in pure functional programming languages@the-rust-book.
- Low level control over hardware and operating system resources.


Rusts most prominent feature is that is able to have automatic memory management while not using garbage collection through an advanced static analysis system built into the language called the ownership model. The rules of this system is explained in more detail below in @s.graph-representation. With this system the compiler is able to prove that a common suite of serious bugs can not happen at run time. Bugs such as use after free, null-pointer dereferences, buffer overflows and memory leaks. All of which are issues that a programmer has to prevent manually in other low level languages such as C and C++. These issues can if not prevented lead to security vulnerabilities and potentioally dangerous crashes for real-time embedded systems@sharma2023rust. Multiple institutions and organizations such as NIST@nist-use-rust, NSA@nsa-use-rust and even the United States Government@white-house-rust has published reports that documents that the aforementioned account for large percentage of the software vulnerabilities colloguially known as #acrpl("CVE") found in todays critical software that a lot society depend on. A conclusion echoed across these reports is that new critical software should be developed in _memory safe_ languages that are capable of preventing these issues statically. Listing Rust as one of the candidate languages that they recommend that new systems level applications should be written in. While the developed code for this thesis is not going to be run in a context were such issues would be severe at all, ...

As such

focus on modulariy and consistent tooling across the entire language stack

it is the authors of this thesis belief that

NIST @nist-use-rust

NSA @nsa-use-rust


- rust for embedded development @sharma2023rust

A belief that Rust will grow and gain ground in robotic software stacks, as robotic systems continue to become more


#line(length: 100%, stroke: 10pt + red)

// - Explore newer alternatives that matches C++ in terms of performance, but allows for other qualities.

// - to validate that the algorithm works across different programming languages and are not dependant on features exclusive to C++.

- exhaustive pattern matching is useful for any future factors that needs to added to the implementation as the compiler would require that all uses of it are handled explicitly.

- Secondly the implementation have no hard dependencies on C++ or C only frameworks such as ROS2 that are popular in the robotics community and industry.

- See a lot of popularity and want the to contribute to robotics related research and experimentation in the language to prove its usefullness/applicability in multiple domains.

- white house paper that urges developers to move away from C++ and focus on memory safe languages like Rust. Also cite Google CVE papers about vulnabilities that Rust can prevent alone by the compiler. @white-house-rust


- The most beloved language in by software developers many years in a row, Stack Overflow

- allows for more easily describe software contracts i.e. pre and postconditions through the type system.

- the domain of numeric quantities

- Finally a non-technical reason the authors were curious about the touted benefits of the language and wanted to
- well positioned to have significant influence on software development now and even more so in the future.

==== Other Languages Considered

Beyond Rust four other programming languages were considered.  @tbl.other-languages-considered lists them in a table together with reasons why they were not selected.

#figure(
  tablec(
    columns: 2,
    align: (center, left),
    header: table.header([Language], [Reason for not choosing it]),
    [Zig], [],
    [Odin], [],
    [Julia], [],
    [Python], [Too slow, and lack of a strong (enforced) type system seen as a disadvantage for managing the size and complexity of the developed system.],
  ),
  caption: []
) <tbl.other-languages-considered>

// #todo[
//   Explain some of the unique benefits of Rust.
//   - borrow checker
//   - ownership
//   - memory safety
//   - concurrency
//   - Performance
//   - Rich type system
//   - Rich library ecosystem
//   - Helpful error message
//   - Error handling, errors as values, no exceptions
//   - Exceptional tooling,
// ]


// - `cargo`

// - `gbpplanner` is implemented in C++. We are both familiar with C++, but have in
  // previous projects spent a lot of time fighting its idiosyncrasies.

// A desire to learn the technology is one of the reasons why Rust was chosen. A lot of new systems are developed using Rust, and a lot of prominent authorities have publicly urged that new software project not be developed in unsafe languages such as C++.
