#import "../../../lib/mod.typ": *

=== Iteration Schedules <s.iteration-schedules>

Scheduling, order in which we call internal and external iteration

// #{
//   let iterations = (
//     internal: 10,
//     external: 10,
//   )

//   let interleave-evenly(..times) = {
//     let times = times.pos()
//     assert(times > 0, message: "#times must be > 0")
//     let max = times.max()
//     let increments = times.map(x => max / x)
//     let state = range(times.len()).map(_ => 0.0)

//   }
// }

#let every(array, n, skip-first: false) = {
  // let n = n + if skip-first { 0 } else { 0 }
  let begin-at = if skip-first {1} else {0}
  for (i, it) in array.slice(begin-at).enumerate() {
    if calc.rem(i, n) == 0 {
      (it,)
    }
  }
}


#let iterations = (
  internal: 10,
  external: 20,
  foo: 5,
  ahh: 12,
  max: 35
)

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
      (range(t).map(_ => false) + range(max - t).map(_ => true),)
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
      let lower = calc.floor(t / 2)
      // let lower = calc.max(1, calc.floor(t / 2))
      let upper = calc.ceil(t / 2)
      let middle = calc.ceil(max - t)

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


// #m

// transposed

// #transpose(m)

// #{
//   let N = iterations.len()
//   let max = calc.max(..iterations.values())
//   let schedules = interleave-evenly(..iterations.values())
//   let schedules_transposed = transpose(schedules)

//   // let on = table.cell.with(fill: green.lighten(50%))
//   // let off = table.cell.with(fill: red.lighten(50%))

//   let colors = every(color.map.rainbow, 50).slice(0, N)
//   let on-colors = colors.map(c => table.cell(fill: c, []))

//   // max
//   table(
//     columns: max,
//     ..schedules_transposed.zip(on-colors).map(pair => {
//       let schedule = pair.at(0)
//       let color = pair.at(1)
//       schedule.map(activate => if activate { color } else { [] })
//     }).flatten(),

//     ..range(max).map(i => [#i])
//   )
// }

#let show-schedule(times, schedule-gen, cmap: color.map.rainbow, title: none) = {
  let N = times.len()
  let max = calc.max(..times)
  // let schedules = interleave-evenly(..times)
  let schedules = schedule-gen(..times)
  let schedules_transposed = transpose(schedules)

  // let on = table.cell.with(fill: green.lighten(50%))
  // let off = table.cell.with(fill: red.lighten(50%))

  let cell = table.cell.with(x: 1em, y: 1em)
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
  let on-colors = colors.map(c => table.cell(fill: c, []))

  // max
  set align(center)
  if title != none {
    text(size: 12pt, [*#title*])
  }
  table(
    gutter: 0.1em,
    stroke: none,
    columns: range(max).map(_ => 1fr),
    rows: range(N).map(_ => 1.5em),
    ..schedules_transposed.zip(on-colors).map(pair => {
      let schedule = pair.at(0)
      let color = pair.at(1)
      schedule.map(activate => if activate { color } else { [] })
    }).flatten(),

    table.hline(stroke: 1pt + gray),
    ..range(max).map(i => i + 1).map(i => [#i])
  )
}

#let iterations = (
  internal: 30,
  external: 10,
)

#kristoffer[
  Talk about how the paper make a distuinguishon about that internal and external iteration can be varied in amount per algorithm step. But does not mention how they are ordered relative to each other i.e. what schedule they use.
]

// #let cmap = (red.lighten(20%), blue.lighten(20%))
#let cmap = (theme.maroon.lighten(30%), theme.blue.lighten(30%))
// #text(size: 18pt, cmap.at(0), [Internal #iterations.internal])
// #text(size: 18pt, cmap.at(1), [Internal #iterations.external])

#show-schedule(iterations.values(), interleave-evenly, cmap: cmap, title: [Interleave Evenly])
#show-schedule(iterations.values(), schedule-soon-as-possible, cmap: cmap, title: [Soon as Possible])
#show-schedule(iterations.values(), schedule-late-as-possible, cmap: cmap, title: [Late as Possible])
#show-schedule(iterations.values(), schedule-half-at-the-end-half-at-the-beginning, cmap: cmap, title: [Half at the beginning, Half at the end])
#show-schedule(iterations.values(), schedule-centered, cmap: cmap, title: [Centered])
