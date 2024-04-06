#import "../../lib.typ": *
= Theory <methodology>

== Factor Graphs
=== Message Passing

#canvas(
  length: 1cm, {
    import draw: *

    let scale = 1.5
    let s = (x: 2.0, y: -2.0, a: 0.15)
    let pos = (
      V1: (0.0, 0.0),
      F1: (s.x, 0.0),
      F2: (0.0, s.y),
      F3: (s.x, s.y),
      V2: (s.x, s.y * 2),
    )

    let vec2_add(a, b) = {
      // assert that both a and b are arrays of floats, and same length
      assert(type(a) == "array" and type(b) == "array")
      assert(b.len() == a.len())

      a.zip(b).map(x => x.at(0) + x.at(1))
    }

    let vec2_angle(a, b) = {
      // assert that both a and b are arrays of floats, and same length
      assert(type(a) == "array" and type(b) == "array")
      assert(b.len() == 2 and a.len() == 2)
      
      let diff = vec2_add(b, a.map(x => -x))
      calc.atan2(diff.at(1), diff.at(0))
    }

    let vec2_normal_angle(a, b) = {
      // assert that both a and b are arrays of floats, and same length
      assert(type(a) == "array" and type(b) == "array")
      assert(b.len() == 2 and a.len() == 2)
      
      let angle = vec2_angle(a, b)
      angle - 90deg
    }

    set-style(
      content: (padding: .2), fill: gray.lighten(70%), stroke: gray.lighten(70%),
    )

    let square(center, side_length: 1, radius: 0%, name: "square") = {
      let upper_left = (center.at(0) - side_length / 2, center.at(1) + side_length / 2)
      let lower_right = (center.at(0) + side_length / 2, center.at(1) - side_length / 2)
      rect(upper_left, lower_right, radius: radius, name: name)
    }

    let factor(position, name: "factor") = {
      set-style(
        fill: catppuccin.latte.lavender, stroke: none,
      )
      square(position, side_length: 0.4 * scale, radius: 10%, name: name)
    }

    let variable(position, name: "variable") = {
      set-style(
        fill: catppuccin.latte.maroon, stroke: none,
      )
      circle(position, radius: 0.25 * scale, name: name)
    }

    intersections("i", {
      variable(pos.V1, name: "V1")
      factor(pos.F1, name: "F1")
      factor(pos.F2, name: "F2")
      factor(pos.F3, name: "F3")
      variable(pos.V2, name: "V2")

      hide(line("V1.center", "F1.center"))
      hide(line("V1.center", "F2.center"))
      hide(line("V1.center", "F3.center"))
      hide(line("V2.center", "F3.center"))
      hide(line("V2.center", "F2.center"))
    })

    set-style(stroke: catppuccin.latte.text)
    line("i.0", "i.3", name: "V1-F1")
    line("i.1", "i.4", name: "V1-F2")
    line("i.2", "i.7", name: "V1-F3")
    line("i.5", "i.11", name: "V2-F2")
    line("i.8", "i.10", name: "V2-F3")
    // line("i.2", "i.6", name: "V1-F3")
    // line("i.5", "i.9", name: "V2-F2")
    // line("i.7", "i.8", name: "V2-F3")

    intersections("l1", {
      set-style(mark: (end: none), stroke: catppuccin.latte.text)
      hide(line("V1-F1.start", (rel: (0.0, 0.5))))
      hide(line("V1-F1.end", (rel: (0.0, 0.5))))

      hide(line(vec2_add(pos.V1, (0.0, s.a)), vec2_add(pos.F1, (0.0, s.a))))
    })

    set-style(mark: (end: "straight"), stroke: catppuccin.latte.maroon)
    line("l1.0", "l1.1", name: "V1-F1-msg")

    intersections("l2", {
      set-style(mark: (end: none), stroke: catppuccin.latte.text)
      hide(line("V1-F2.start", (rel: (0.5, 0.0))))
      hide(line("V1-F2.end", (rel: (0.5, 0.0))))

      hide(line(vec2_add(pos.V1, (s.a, 0.0)), vec2_add(pos.F2, (s.a, 0.0))))
    })

    set-style(mark: (end: "straight"), stroke: catppuccin.latte.maroon)
    line("l2.0", "l2.1", name: "V1-F2-msg")

    intersections("l3", {
      set-style(mark: (end: none), stroke: catppuccin.latte.text)
      let a = vec2_normal_angle(pos.V1, pos.F3)
      let k = calc.cos(a) * s.a
      let k_over = calc.sin(a) * s.a * 2

      hide(line("V1-F3.start", (rel: (k_over, k_over))))
      hide(line("V1-F3.end", (rel: (k_over, k_over))))

      hide(line(vec2_add(pos.V1, (k, k)), vec2_add(pos.F3, (k, k))))
    })

    set-style(mark: (end: "straight"), stroke: catppuccin.latte.maroon)
    line("l3.0", "l3.1", name: "V1-F3-msg")

    intersections("l4", {
      set-style(mark: (end: none), stroke: catppuccin.latte.text)
      let a = vec2_normal_angle(pos.V2, pos.F2)
      let k = -calc.cos(a) * s.a
      let k_over = -calc.sin(a) * s.a * 2

      hide(line("V2-F2.start", (rel: (k_over, k_over))))
      hide(line("V2-F2.end", (rel: (k_over, k_over))))

      hide(line(vec2_add(pos.V2, (k, k)), vec2_add(pos.F2, (k, k))))
    })

    set-style(mark: (start: "straight"), stroke: catppuccin.latte.maroon)
    line("l4.0", "l4.1", name: "V2-F2-msg")

    intersections("l5", {
      set-style(mark: (start: none), stroke: catppuccin.latte.text)

      hide(line("V2-F3.start", (rel: (0.5, 0.0))))
      hide(line("V2-F3.end", (rel: (0.5, 0.0))))

      hide(line(vec2_add(pos.V2, (s.a, 0.0)), vec2_add(pos.F3, (s.a, 0.0))))
    })

    set-style(mark: (start: "straight"), stroke: catppuccin.latte.maroon)
    line("l5.0", "l5.1", name: "V2-F3-msg")
  },
)

== Gaussian Belief Propagation
