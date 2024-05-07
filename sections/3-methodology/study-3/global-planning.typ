#import "../../../lib/mod.typ": *
=== Global Planning
// RRT

Global planning has been made as an extension to the original GBP Planner software developed by #todo[cite]. The original algorithm works very well on a local level, and lacks a global overview of how to get from A#sg to B#sb. In order to solve this problem; the optimal #acr("RRT*") path planning algorithm has been utilised. The theory behind #acr("RRT*")@sampling-based-survey@erc-rrt-star can be found in @s.b.rrt-star, which builds on the original #acr("RRT")@original-rrt algorithm in @s.b.rrt. The global planning extension goes as follows: \ \

#[
  #set par(first-line-indent: 0em)

  #grid(
    columns: (2fr, 3fr),
    // [*Setup:*], [*Steps:*],
    // [
    //   - A robot $A$ needs to get from point $A$ to point $B$.
    //   - The path from $A$ to $B$ is convoluted, and includes more than simple obstacles to go around.
    // ],
    // [
    //   #set enum(numbering: box-enum.with(prefix: "Step "))
    //   + The #acr("RRT*") algorithm is used to find a path from $A$ to $B$.
    //   + The result of #acr("RRT*") is a series of points that can now be leveraged to navigate through the environment.
    //   + The GBP local planning will still be in effect, in order to avoid local obstacles and other robots.
    // ]
    blocked(
      title: [*Setup*]
    )[
      - A robot $A$ needs to get from point $A$ to point $B$.
      - The path from $A$ to $B$ is convoluted, and includes more than simple obstacles to go around.
    ],
    blocked(
      title: [*Steps*]
    )[
      #set enum(numbering: box-enum.with(prefix: "Step "))
      + The #acr("RRT*") algorithm is used to find a path from $A$ to $B$.
      + The result of #acr("RRT*") is a series of points that can now be leveraged to navigate through the environment.
      + The GBP local planning will still be in effect, in order to avoid local obstacles and other robots.
    ]
  )
]

// as seen in @f-m-rrt-colliders.

// An example of the RRT algorithm in action can be seen in @f-m-rrt-colliders. #note.jens[more about the collider, and the environment representation.]

==== Environment Integration <s.m.planning.environment-integration>

#figure(
  {
    // set text(font: "JetBrainsMono NF", size: 0.85em)
    grid(
      columns: (30%, 30%),
      std-block(
        breakable: false,
      )[
        #image("../../../figures/out/rrt-colliders.svg")
        #v(0.5em)
        #text(theme.text, [A: Small Collision Radius])
      ],
      std-block(
        breakable: false,
      )[
        #image("../../../figures/out/rrt-colliders-expand.svg")
        #v(0.5em)
        #text(theme.text, [B: Large Collision Radius])
      ],
    )
  },
  caption: [RRT algorithm and environment avoidance integration. Left image shows a small collision radius, which results in a path that tends to get closer to the obstacles. Right image shows a collision radius, equal to the step length; $r_C = s$, which results in a path that tends towards the middle of the free space, staying far from the environment.],
)<f-m-rrt-colliders>

==== Path Adherence <s.m.planning.path-adherence>

#jens[Approach 1: Simply perform RRT\*, and use the resulting points as waypoints.]

#jens[Approach 2: Use the RRT\* algorithm to generate a path, then track the robots along it with _pose factors_ (traction factors).]

#figure(
  {
    // set text(font: "JetBrainsMono NF", size: 0.85em)
    grid(
      columns: (30%, 30%),
      std-block(
        breakable: false,
      )[
        #image("../../../figures/out/rrt-optimisation-no-env.svg")
        #v(0.5em)
        #text(theme.text, [A: Path Optimisation])
      ],
      std-block(
        breakable: false,
      )[
        #image("../../../figures/out/rrt-path-tracking.svg")
        #v(0.5em)
        #text(theme.text, [B: Path Tracking])
      ],
    )
  },
  caption: [Path tracking on the pseudo-optimal path found with #acr("RRT*").],
)
