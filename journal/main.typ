#let important-datetimes = (project: (
  start: datetime(day: 29, month: 01, year: 2024),
  end: datetime(day: 04, month: 06, year: 2024),
))

#let locations = (beumer: [Beumer], au: [AU 5124 139], home: [From Home])

#let datetime-display-format = "[weekday] (week [week_number padding:space]) [day]-[month]-[year]"

#let project-week-number(date) = {
  let dur = date - important-datetimes.project.start
  calc.ceil(dur.weeks())
}

#let datetime-display-format = "[weekday] (week [week_number padding:space]) [day]-[month]-[year]"

#let hr = line(length: 100%)
#let day(dt) = {
  let weekday = dt.display("[weekday]")
  let date = dt.display("[day]-[month]-[year]")
  [
    == #weekday #date (project week #project-week-number(dt))
    #hr
  ]
}

#let deadline-countdown() = {
  let today = datetime.today()

  let dur = important-datetimes.project.end - today
  let floor = calc.floor
  let weeks = floor(dur.weeks())
  let days = floor(dur.days()) - weeks * 7
  // let hours = floor(dur.hours()) - weeks * 7 * 24 - days * 24

  let weeks-postfix = if weeks == 1 {
    "week"
  } else {
    "weeks"
  }

  let days-postfix = if days == 1 {
    "day"
  } else {
    "days"
  }

  set align(center)
  set text(size: 18pt)
  if 0 < weeks {
    [#text(color.red, [#weeks]) #weeks-postfix ]
  }
  if 0 < days {
    [#text(color.red, [#days]) #days-postfix ]
  }

  let emojies = (
    emoji.face.goofy,
    emoji.face.devil,
    emoji.face.explode,
    emoji.face.cry,
    emoji.face.frust,
    emoji.face.grin,
    emoji.face.angry,
  )
  assert(emojies.len() == 7)

  let daily-emoji = emojies.at(calc.rem(floor(dur.days()), emojies.len()))

  [left to hand-in deadline #daily-emoji]
}

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

// #include "../acronyms.typ": *
// #import "../acronyms.typ": *

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
#jens[
  At Beumer \
  - Starting with a meeting all three (Kristoffer, Jens, Jonas)
  - Read papers:
    - #gbp-visual-introduction.paper @gbp-visual-introduction
    - #gbpplanner.paper @gbpplanner

  - Successful compilation and run of examples from #gbpplanner.code.
    - Successfully created custom environment to attempt to highlight weaknesses of
      the current implementation.
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
#jens[
  From home \
  - Set up Rust project structure
  - Looked at the visualisation tools with Kristoffer, discussing which to go with.
  - Learned Bevy and ran some examples
    - Wrote some of the examples out and mix-matched some of it to learn how it all
      fit together.
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
#jens[
  At OrbitLab \
  - Re-flash OS to NixOS
    - Learn NixOS and contemplated using hyprland
  -
]

#day(datetime(day: 1, month: 02, year: 2024))

#kristoffer[
  - At OrbitLab
  - Continued learning about NixOS and setting up our development environment, with
    the tools we like to use.
  - Spent some time trying to port the code from #gbp-visual-introduction.notebook to
    our Rust implementation.
]
#jens[
  At OrbitLab \
  - Setting up NixOS and hyprland
  - Migrating gbpplanner to Rust
]

#day(datetime(day: 2, month: 02, year: 2024))

#kristoffer[
  - Worked from home.
  - Continued our attempt to port the code from #gbp-visual-introduction.notebook to
    our Rust codebase.
    - Jens wrote the code, while we both discussed how to port the Python code to
      Rust.
]
#jens[
  From home
  - Rust migration
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

#jens[
  At Beumer \
  - Struggling to set up hyprland with displaylink
  - Ended the struggle, and joined Kristoffer in continuing the Rust migration.
]

#day(datetime(day: 6, month: 02, year: 2024))
#jens[
  From home \
  - Collaborative coding to migrate to Rust
    - Fixed a lot of compiler errors
]

#day(datetime(day: 7, month: 02, year: 2024))
#jens[
  At 5124-139 \
  - Attempted to continue for a while with the generic factor-graph gbp library we
    have been attempting to make, however, it had become too much of a headache so:
    - Started over, in a much simpler fashion
    - Supported with chatGPT
    - Supported as sparring partner, and made sure to understand things more precisely
    - Also added journal entries for all my previous weeks
]

#day(datetime(day: 8, month: 02, year: 2024))

#kristoffer[
  At 5124-139 \
  - Continued working on the rewrite of gbpplanner in rust.
  - Spent some time playning around with the C++ Eigen library, to confirm how
    variaous matrix operations and matrix slicing work, to correctly port them to
    rust.
  - Reread parts of the methodology section, to better understand some of the math.
]

#jens[
  At 5124-139 \
  - Working with Kristoffer to continue translation to Rust.
  - Decided to split the work load.
    - I looked at Bevy, and learned further how to work it.
    - Implemented an input-manager, such that the user can press keys on the keyboard
      or gamepad to interact with the simulation.
    - Applied some keybinds like movement, boost to change movement speed, and
      toggling of a dynamic unknown object in the simulation.
      - The toggling is currently only done by setting alpha to 0/1, which should later
        also disable/enable the actor's hitbox.
]

#day(datetime(day: 9, month: 02, year: 2024))
#jens[
  At home \
  - Decomposed input and objects in the Bevy ECS architecture.
  - Watches episodes 1, 2, and 3 of the Bevy tutorial series.
  - Decomposed the system even further to have movement handled by itself.
    - This introduced a bug where movement of objects don't stop.
  - Reworked the project with a 3D scene and 3D camera.
  - Created and asset loader, to handle the loading of the 3D models.
  - Changed the moveable object to be a 3D model.
]

#kristoffer[
From home \
- Found a similar paper to the @gbpplanner called Robot Web @robotweb, that had
some interesting demo videos on their #link("https://rmurai.co.uk/projects/RobotWeb/", [website]).
- My intention is to read it over the weekend or next week, to see how it differs
  from @gbpplanner.
- Continued working on the port to Rust.
  - Abstracted the robot radius into a trait `BoundingBox`, where i am right now
    creating a impl for a `BoundingBox2d`
  - Created an abstraction for the `CommunicationMedia`
  - Tried using Julia to verify some of the math, but had issues getting the
    `Distributions` package to compile on `NixOS`
- Still need to figure out how Messages are exchanged between robots, in a way
  that it is decoupled from running the simulation in a single thread with the
  same address space to a multiprocess system.

]

#day(datetime(day: 10, month: 02, year: 2024))
#jens[
From home \
- Fixed the movement bug from yesterday, such that velocity is reset when the
  movement stops.
- Extended the `MovementPlugin` to handle rotation as well in a similar fashion to
  the movement.
  - Consider decomposing the rotation into its own plugin.
- Changed the moveable object to a box instead of the roomba.
]

#day(datetime(day: 12, month: 02, year: 2024))

#kristoffer[
From Home \
- Continued working on porting gbpplanner factorgraph to Rust.
- Spend some time figuring out how to map Eigen operations to Rust nalgebra crate.
- Unsure about current design with every Variable have `Vec<Rc<Factor>>` and
  Factors having `Vec<Rc<Variable>>` makes the abstraction kinda akward.
  - Thinking about restructuring and using a proper graph structure.
  - For this I think we can use the `petgraph` library.
- Also considered ways to abstract the connection with other robots/factorgraphs
  such that the library can be used in both simulation and real world setup.
]

#jens[
  From Home \
  - Finished initial camera controls.
  - Set up an infite grid to visualize the environment.
]

#day(datetime(day: 13, month: 02, year: 2024))

#kristoffer[
  At 5124-139

  - Meeting with Andriy and Jonas.
    - Showcased and discussed what we had been doing for the first two weeks.
    - Talked about some of the shortcomings we had identified with gbpplanner, and
      which were relevant to pursue.
      - Try and incorporate a global planner with the GBP algorithm.
      - Use a scheme to only communicate with the robots most uncertain about, to reduce
        number of messages being communicated in areas with a lot of robots. Avoid $O(n^2)$ complexity
    - Focus on first making a rewrite that reproduces the results of @gbpplanner,
      before applying the software design decisions that we think would be better.
    - Focus on not only record what we do in text (in this journal), but also take
      pictures and video recordings of when things work and don't. Because they might
      be difficult to recreate later.

  - Read "A Robot Web for Distributed Many-Device Localisation" @robotweb.
    - Very similar to @gbpplanner, I think some of the authors are the same.
    - They exchange messages using HTTP. Where each robot host a web server that the
      other robots can send POST requests to.
    - Similar results and findings as @gbpplanner.
      - Some of their conclusions
        - "While increasing the communication radius improves the performance, 30m
          onwards, the difference is negligible."
        - "Retain low ATE up to 50% message loss"
        - "Demonstrates its resilience to large initialisation errors up to (0.2m, 0.2m,
          0.2rad) after which it explodes"
    // - Robust factors
]

#jens[
  At 5124-139 \
  - Meeting with Andriy and Jonas.
  - Added zoom functionality to the camera with button bindings.
  - Fixed object not visible from the beginning. Due to normilization of
    zero-vector.
  - Same problem with moving the camera, everything would vanish after a while
    because of normilization of zero-vector.
  - Read half of "A Robot Web for Distributed Many-Device Localisation" @robotweb.
]

#day(datetime(day: 14, month: 02, year: 2024))
#jens[
  At 5124-139 \
  - Set up mouse/touchpad keybindings for camera movement in simulation.
]

#kristoffer[
  #locations.au

  - Finished reading paper @robotweb.
  - Worked on porting @gbpplanner C++ code to our Rust version.
]

#day(datetime(day: 15, month: 02, year: 2024))
#jens[
At 5124-139 \
- Made a system to add follow cameras to each robot tagged with `FollowCameraMe`.
- Made the follow camera work quite reliably and almost not laggy.
]

#kristoffer[
#locations.au

- Ported most of `Robot`, `FactorGraph` and `Variable` class to Rust.
]

#day(datetime(day: 16, month: 02, year: 2024))
#kristoffer[
#locations.home

- Continued port of `gbpplanner` to Rust.
]

#deadline-countdown()

#bibliography(
  "../references.yaml",
  style: "institute-of-electrical-and-electronics-engineers",
)
