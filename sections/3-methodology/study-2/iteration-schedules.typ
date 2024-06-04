#import "../../../lib/mod.typ": *

=== Message Passing Iteration Schedules <s.iteration-schedules>

// Scheduling, order in which we call internal and external iteration

One of the appreciative properties of the #acr("GBP") algorithm is the relaxed constraints on the order in which variable and factor messages are processed within the joint factorgraph. In the presence of events normally detrimental to peer-to-peer distributed systems without synchronization mechanisms, such as

- Messages arriving out of _order_.
- Messages being temporarily _dropped_.


global convergence can still be achieved. This quality is especially important in multi robotics systems where robots use wireless communication and can only achieve intermittent radio contact. Each robot "hosts" its own factorgraph, and then use interrobot factors to partake in a joint factorgraph with other robots. From the perspective of the #acr("GBP") algorithm there is no functional distintion between messages sent across edges internal to the robots factorgraph, and messages sent along edges between two robots' factorgraph. But in the real-world case these two cases; _internal_ and _external_ message passing involves different steps to perform and different guarantees about latency:

- *Internal* message passes are cheap to compute in relation to external message passing, as the messages only have to copied between structures within the virtual memory of the process running the #acr("GBP") algorithm on the robot.
- *External* message passes are more expensive to perform. Messages has to be serialized and be transmitted over a wireless connection to then be received and deserialized into its in-memory representation.


// - As it is desirable to run execute more internal message passes than external.

To accomedate this discrepancy the gbpplanner algorithm can be configured to run a different amount of internal and external message passing iterations per $Delta_t$, through the parameters $M_I$ and $M_E$ respectively. The effect of varying $M_I$ and $M_E$ are not experimented with in @gbpplanner. All the provided experimental scenarios use $M_I = 50$ and $M_E = 10$. Furthermore it is not explained in which order internal and external message passing are scheduled relative to each other, in cases where $M_I != M_E$. The accompanying source code@gbpplanner-code does not answer this question either, and does in fact not implement a way to handle when $M_I != M_E$ as seen here #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/src/Simulator.cpp#L82-L87", "gbpplanner/src/Simulatior.cpp:82-87"). Contrary to what they report in their paper.



// #k[insert github link to where this can be seen]

// These variations are not experimented with in the paper@gbpplanner. They only present scenarios where $M_I = 50$ and $M_E = 10$. And make no remark on the how they schedule the different iterations. Likewise their published code ...

// - dichotemy of messages being sent across _internal_ and _external_ edges. This split is parameterized through the variables $M_I$, and $M_E$ that expresses how many times per $Delta_t$

To test what effect the ordering of $M_I$ and $M_E$ has on the global convergence of the algorithm,  the reimplementation is extended to incorporate the concept of an _iteration schedule_. A schedule which describes how to lay out the ordering of internal and external message passing relative to each other per simulated timestep $Delta_t$. More formally a schedule is defined to be a higher order function $S$ parameterized by $M_I, M_E$, as shown in @equ.iteration-schedule.

$ S(M_I, M_E) = (S_I_(M_I, M_E)(n), S_R_(M_I, M_E)(n)) $ <equ.iteration-schedule>

It evaluates to a tuple of two _partial_ functions $S_I_(M_I, M_E)(n)$ and $S_R_(M_I, M_E)(n)$ defined over the range $n in [0, max(M_I, M_E)]$. That when evaluated with a iteration count $n$ returns $top$ if a message passing should be executed, and $bot$ otherwise.

To make it effortless to test different schedules and add new ones in the future, dependency injection is used. The interface is modelled through a Rust trait called `GbpSchedule` as seen in @l.gbp-schedule-trait. With the current implementation every robot entity is equipped with the same schedule, but this could be a point for experimentation in possible future work, where robots are modelled with possibly different schedules.

#listing(
```rust
pub trait GbpSchedule {
    fn schedule(params: GbpScheduleParams) -> impl GbpScheduleIterator;
}

pub trait GbpScheduleIterator: std::iter::Iterator<Item = GbpScheduleAtIteration> {}
```,
  caption: [
  #acr("GBP") message passing schedules modelled through the trait `GbpSchedule`. For a listing of all the custom types in the code snippet seet @appendix.iteration-schedules.
]
) <l.gbp-schedule-trait>

Five different iteration schedules are experimented with. Each schedule is listed in @f.iteration-schedules accompanied with a diagram explaining visually how the schedules are laid out relative to each other. The name of each schedule together with its diagram should make its behaviour be self explanatory.

// is that global convergence can be achieved with an ad-hoc communication schedule, as would often be the case in real scenarios when for instance robots only achieve intermittent radio contact.

#let every(array, n, skip-first: false) = {
  // let n = n + if skip-first { 0 } else { 0 }
  let begin-at = if skip-first {1} else {0}
  for (i, it) in array.slice(begin-at).enumerate() {
    if calc.rem(i, n) == 0 {
      (it,)
    }
  }
}


// #let iterations = (
//   internal: 10,
//   external: 20,
//   foo: 5,
//   ahh: 12,
//   max: 35
// )

#let interleave-evenly(..times) = {
  let times = times.pos()
  let N = times.len()
  assert(N > 0, message: "#times must be > 0")
  let max = calc.max(..times)
  let increments = times.map(x => max / x)
  let state = range(times.len()).map(_ => 0.0)

  for k in range(1, max + 1) {
    (for i in range(N) {
      if state.at(i) < k {
        state.at(i) += increments.at(i)
        (true,)
      } else {
        (false,)
      }
    },)
  }
}

#let schedule-soon-as-possible(..times) = {
  let times = times.pos()
  let N = times.len()
  assert(N > 0, message: "#times must be > 0")
  let max = calc.max(..times)

  let schedule = for t in times {
    (range(t).map(_ => true) + range(max - t).map(_ => false),)
  }

  transpose(schedule)
}


#let schedule-late-as-possible(..times) = {
  let times = times.pos()
  let N = times.len()
  assert(N > 0, message: "#times must be > 0")
  let max = calc.max(..times)

  let schedule = for t in times {
    if t == max {
      (range(t).map(_ => true),)
    } else {
      (range(max - t).map(_ => false) + range(t).map(_ => true),)
    }
  }

  transpose(schedule)
}

#let schedule-half-at-the-end-half-at-the-beginning(..times) = {
  let times = times.pos()
  let N = times.len()
  assert(N > 0, message: "#times must be > 0")
  let max = calc.max(..times)

  let schedule = for t in times {
    if t == max {
      (range(t).map(_ => true),)
    } else {
      let lower = calc.floor(t / 2)
      // let lower = calc.max(1, calc.floor(t / 2))
      let upper = calc.ceil(t / 2)
      let middle = calc.ceil(max - t)

      (
        range(lower).map(_ => true)
      + range(middle).map(_ => false)
      + range(upper).map(_ => true)
      ,
      )
    }
  }

  // schedule
  transpose(schedule)
}

// #schedule-half-at-the-end-half-at-the-beginning(1, 4, 10, 17)


#let schedule-centered(..times) = {
  // schedule-half-at-the-end-half-at-the-beginning(..times)
  //   .map(iteration => iteration.map(b => not b))

  let times = times.pos()
  let N = times.len()
  assert(N > 0, message: "#times must be > 0")
  let max = calc.max(..times)

  let schedule = for t in times {
    if t == max {
      (range(t).map(_ => true),)
    } else {


      let lower = calc.floor((max - t) / 2)
      // let lower = calc.max(1, calc.floor(t / 2))
      let upper = calc.ceil((max - t) / 2)
      let middle = calc.ceil(t)

      (
        range(lower).map(_ => false)
      + range(middle).map(_ => true)
      + range(upper).map(_ => false)
      ,
      )
    }
  }

  // schedule
  transpose(schedule)
}

#let show-schedule(times, schedule-gen, cmap: color.map.rainbow, inactive-color: gray, title: none, show-xticks: true, headers: none) = {
  let N = times.len()
  let max = calc.max(..times)
  // let schedules = interleave-evenly(..times)
  let schedules = schedule-gen(..times)
  let schedules_transposed = transpose(schedules)

  // let on = table.cell.with(fill: green.lighten(50%))
  // let off = table.cell.with(fill: red.lighten(50%))

  let cell = table.cell.with(x: 1em, y: 2em)
  let colors = {
    if cmap.len() < N {
      panic("cmap does not contain enough colors")
    } else if cmap.len() == N {
      cmap
    } else {
      every(cmap, 50).slice(0, N)
    }
  }

  // let colors = every(cmap, 50).slice(0, N)
  // let on-colors = colors.map(c => table.cell(fill: c, []))

  // max
  set align(center)
  if title != none {
    text(size: 12pt, [*#title*])
  }


  // let xticks = if show-xticks {
  //   let k = 9
  //   (table.hline(stroke: 1pt + gray), ) + if max <= k {
  //     range(max).map(i => i + 1).map(i => [#i])
  //   }  else {
  //     let rest = max - k
  //     let empty = rest - 2
  //     let lower = calc.floor(empty / 2)
  //     let upper = calc.ceil(empty / 2)
  //     range(k).map(i => i + 1).map(i => [#i]) + range(lower).map(_ => []) + ($...$,) + range(upper).map(_ => []) + ([#max],)
  //   }
  // } else {
  //   ()
  // }


  let xticks = if show-xticks {
    let k = 9
    if max <= k {
      range(max).map(i => i + 1).map(i => [#i])
    }  else {
      let rest = max - k
      let empty = rest - 2
      let lower = calc.floor(empty / 2)
      let upper = calc.ceil(empty / 2)
      range(k).map(i => i + 1).map(i => [#i]) + range(lower).map(_ => []) + ($dots.c$,) + range(upper).map(_ => []) + ([#max],)
    }
  }

  grid(
    gutter: 0.1em,
    stroke: none,
    columns: range(max).map(_ => 1fr),
    rows: range(N).map(_ => 2.85mm),
    ..schedules_transposed.zip(colors).map(pair => {
      let schedule = pair.at(0)
      let color = pair.at(1)

      schedule.map(
        activate => {
          let col = if activate { color } else { inactive-color }
          box(
            fill: col,
            radius: 2pt,
            height: 100%,
            width: 100%,
          )
        }
      )
    }).flatten(),
  )

  if show-xticks {
    set text(theme.text)
    v(-0.5em)
    line(stroke: (thickness: 1pt, paint: gray, cap: "round"), length: 100%)
    v(-0.5em)
    grid(
      gutter: 0.1em,
      stroke: none,
      columns: rep(1fr, max),
      ..xticks
    )
  }
}

#let iterations = (
  internal: 50,
  external: 10,
)


// #let cmap = (red.lighten(20%), blue.lighten(20%))
// #let cmap = (internal: theme.maroon.lighten(30%), external: theme.blue.lighten(30%))
#let cmap = (
  // internal: theme.teal.lighten(25%),
  // external: theme.maroon.lighten(25%),
  internal: theme.sky,
  external: theme.maroon,
  // inactive: gray
)

#let inactive-color = theme.overlay0.lighten(50%)
// #text(size: 18pt, cmap.at(0), [Internal #iterations.internal])
// #text(size: 18pt, cmap.at(1), [Internal #iterations.external])


// #let cell(fill) = box(rect(fill: fill, width: 0.9em, height: 0.9em), baseline: 15%)
#let cell(fill) = box(fill: fill, height: 0.55em, width: 0.75em, radius: 2pt, inset: (x: 0pt), outset: (y: 1pt))

#figure(
{
  show-schedule(iterations.values(), interleave-evenly, cmap: cmap.values(), inactive-color: inactive-color, title: [Interleave Evenly], show-xticks: false)
  show-schedule(iterations.values(), schedule-soon-as-possible, cmap: cmap.values(), inactive-color: inactive-color, title: [Soon as Possible], show-xticks: false)
  show-schedule(iterations.values(), schedule-late-as-possible, cmap: cmap.values(), inactive-color: inactive-color, title: [Late as Possible], show-xticks: false)
  show-schedule(iterations.values(), schedule-half-at-the-end-half-at-the-beginning, cmap: cmap.values(), inactive-color: inactive-color,  title: [Half Start, Half End], show-xticks: false)
  show-schedule(iterations.values(), schedule-centered, cmap: cmap.values(), inactive-color: inactive-color, title: [Centered])
},
  caption: [
  Visual representation of each schedule for $M_I = 50$, $M_E = 10$. Teal cells #cell(cmap.internal) indicate internal message passing at that iteration. Red #cell(cmap.external) represent external message passing and gray #cell(inactive-color) cells indicate no message passing.
]
) <f.iteration-schedules>


The effect of each schedule is experimented with and compared in @s.r.study-2. To make experimentation easy and discoverable the UI settings panel of the simulator has a dedicated section to control $M_I, M_E$ and the chosen schedule live as the simulation is running. A screenshot of the section is shown in @f.ui-schedule-settings.


// ```toml
// [gbp.iteration-schedule]
// internal = 10
// external = 10
// schedule = "interleave-evenly"
// ```
//
// #k[mention where it can be configured]


#let inline-schedule-example = {
  // let r = color.rgb("#D68A90")
  // let c = color.rgb("#82C1CC")
  // let g = color.rgb("#63677F").lighten(80%)
  let g = theme.overlay2.lighten(25%)
  let ni = 12
  let ne = 4

  let schedules = interleave-evenly(ni, ne)
  let schedules_transposed = transpose(schedules)
  let internal = schedules_transposed.at(0)
  let external = schedules_transposed.at(1)

  let internal-active = line(length: 4pt, stroke: cmap.internal)
  let external-active = line(length: 4pt, stroke: cmap.external)
  let external-inactive = line(length: 4pt, stroke: g)

  // schedules_transposed
  box(
    {
      grid(
        columns: ni,
        row-gutter: 4pt,
        column-gutter: 1pt,
        ..internal.map(active => if active { internal-active } else { [] }),
        ..external.map(active => if active { external-active } else { external-inactive }),
      )
      v(1pt)
    },
    inset: (x: 2pt),
    outset: (y: 2pt)
  )
}

// #inline-schedule-example

#figure(
  std-block(width: 60%, height: auto, image("../../../figures/img/gbp-schedules-preview-2.png")),
  caption: [
    Screenshot of the subsection of the simulator's settings panel which displays the current schedule. Both $M_i$ and $M_r$ can be changed dynamically while the simulation runs. The active schedule is displayed aswell and can be changed through a combobox list. The active schedule is displayed with the #inline-schedule-example component. Similar to how its displayed in @f.iteration-schedules.
]
) <f.ui-schedule-settings>

// #82C1CC

// #D68A90

// #k[mention strategy pattern / dependency injection]


#{
  set par(first-line-indent: 0em)
  [
    *Expectation:* For the algorithm to be robust and converge the relative order in which external messages are used to update the joint factorgraph should matter very little. The following three outcomes are expected:
      - No difference between _Late as Possible_ and _Soon as Possible_ as they are identical expect for $min(M_I, M_E)$ being offset in phase by $max(M_I, M_E) - min(M_I, M_E)$.
      - No difference between _Half at the Beginning_ and _Half at the End_. Similar to the above except with $min(M_I, M_E)$ being offset by $min(M_I, M_E)$ in phase.
      - _Interleave Evenly_ should be the best schedule of the five, as the updates from external robots are spaced more evenly in time. Distributing the amount of information evenly between iterations ensures variables are updated evenly in time, leading to a more even distribution of information. This even spacing makes the system less volatile and increases the likelihood of robust convergence, as even time distribution equates to even information density.

// notes:
//
// distribute the amount of information evenly between iterations
//
// with a more even distribution of information
//
// not volatile because evenly spaced information
//
// ensure variable are updated evenly in time
//
// expect even time distribution to equate to even information density
  ]
}
