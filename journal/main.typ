#let datetime-display-format = "[weekday] (week [week_number padding:space]) [day]-[month]-[year]"

#let hr = line(length: 100%)
#let day(dt) = [
  == #dt.display(datetime-display-format)
  #hr
]

#let journal-entry(what, c: none, author: none) = {
  block(
    fill: c.lighten(50%),
    stroke: c,
    inset: 1em,
    outset: 0pt,
    radius: 5pt,
    width: 100%,
    [
      *#author* \
      #what
    ],
  )
}

#let jens = journal-entry.with(author: [Jens], c: color.blue)
#let kristoffer = journal-entry.with(author: [Kristoffer], c: color.orange)

#let gbpplanner = (
  code: link("https://github.com/aalpatya/gbpplanner"),
  website: link("https://aalok.uk/gbpplanner/"),
  paper: [Distributing Collaborative Multi-Robot Planning With Gaussian Belief Propagation],
)

#let gbp-visual-introduction = (
  notebook: link(
    "https://colab.research.google.com/drive/1-nrE95X4UC9FBLR0-cTnsIP_XhA_PZKW?usp=sharing#scrollTo=NzotHENoaY6g",
  ),
  paper: [A visual introduction to Gaussian Belief Propagation],
  website: link("https://gaussianbp.github.io/"),
)

#let gbp = [Gaussian Belief Propagation]

#show link: it => underline(text(blue, it))
#set page(numbering: "1 / 1")

= Journal

#outline()

#day(datetime(day: 29, month: 01, year: 2024))

#kristoffer[
  - At Beumer
  - Started project
  - Had meeting with Jonas discussing what to start with the first 2 weeks
  - Read these papers:
    - #gbp-visual-introduction.paper @gbp-visual-introduction
    - #gbpplanner.paper @gbpplanner

  - Tried compiling examples from #gbpplanner.code but faced issues with missing X11
    headers, even though they were installed on my system.
]

#day(datetime(day: 30, month: 01, year: 2024))

#kristoffer[
  - Worked from home.
  - Created GitHub repository #link("https://github.com/AU-Master-Thesis/gbp-rs") as
    we want to rewrite the #gbpplanner.code in Rust.
  - Looked at different Rust simulation/visualization tools to use.
    - #link("https://macroquad.rs/")
    - #link("https://nannou.cc/")
    - #link("https://bevyengine.org/")
  - Decided to go with *bevy* as it has a lot of community support/solutions and we
    thought its ECS system is really cool!.
  - We read through the introduction book for bevy, to learn the core concepts
    behind the ECS paradigm and how applications are structured in bevy.
]

#day(datetime(day: 31, month: 01, year: 2024))

#kristoffer[
- At OrbitLab
- Continued to have issues compiling the code for #gbpplanner.code.
- We both decided to re-flash our OS with NixOS.
- Spent some getting acquainted with the terminology and methodology of how to do
  things in NixOS
- Create a `flake.nix` for both our Rust port and `gbpplanner` to create a
  reproducible environment, where we can compile and run the code without issue.
]

#day(datetime(day: 1, month: 02, year: 2024))

#kristoffer[
  - At OrbitLab
  - Continued learning about NixOS and setting up our development environment, with
    the tools we like to use.
  - Spent some time trying to port the code from #gbp-visual-introduction.notebook to
    our Rust implementation.
]

#day(datetime(day: 2, month: 02, year: 2024))

#kristoffer[
  - Worked from home.
  - Continued our attempt to port the code from #gbp-visual-introduction.notebook to
    our Rust codebase.
    - Jens wrote the code, while we both discussed how to port the Python code to
      Rust.
]

#day(datetime(day: 5, month: 02, year: 2024))
#kristoffer[
  - At Beumer
  - Read recent survey paper from 2023 @multi-robot-path-planning-review.
    - No mention of any paper/approach using #gbp.
    - Many newer paper use AI methodologies.
      - Neural Network based
      - Genetic Algorithms
        - Ant Colony
        - artificial bee colony algorithm
    - Lin–Kernighan–Helsgaun heuristic algorithm (dunno, names sounds interesting #emoji.face.think)
    - Dynamic Particle Swarm Optimization (PSO) [ref: 126,128]
]

#bibliography(
  "../references.yaml",
  style: "institute-of-electrical-and-electronics-engineers",
)

