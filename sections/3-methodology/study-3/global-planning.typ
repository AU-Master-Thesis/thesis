#import "../../../lib/mod.typ": *
=== Global Planning <s.m.global-planning>

Global planning has been made as an extension to the original GBP Planner software developed by #todo[cite]. The original algorithm works very well on a local level, and lacks a global overview of how to get from A#sg to B#sb. In order to solve this problem; the optimal #acr("RRT*") path planning algorithm has been utilised. The theory behind #acr("RRT*")@sampling-based-survey@erc-rrt-star can be found in @s.b.rrt-star, which builds on the original #acr("RRT")@original-rrt algorithm in @s.b.rrt. The global planning extension goes as follows: \


#[
  #let gp = (
    robot: text(accent, $bold(R)$),
    A: text(theme.green, $bold(A)$),
    B: text(theme.maroon, $bold(B)$),
  )
  #set par(first-line-indent: 0em)
  #grid(
    columns: (2fr, 3fr),
    blocked(
      title: [*Setup*]
    )[
      - A robot #gp.robot needs to get from point #gp.A to point #gp.B.
      - The path from #gp.A to #gp.B is convoluted, and includes more than simple obstacles to go around.

        An exemplification of such an environment could be a maze-like structure, see @f.m.maze-env.
    ],
    blocked(
      title: [*Steps*]
    )[
      #set enum(numbering: box-enum.with(prefix: "Step "))
      + The #acr("RRT*") algorithm is used to find a path from #gp.A to #gp.B.
      + The result of #acr("RRT*") is a series of points that can now be leveraged to navigate through the environment.
      + The GBP local planning will still be in effect, in order to avoid local obstacles and other robots.
    ]
  )
]

#figure(
  // std-block[#jens[PLACEHOLDER]],
  image("../../../figures/out/maze-env.svg", width: 20%),
  caption: [An example of a maze-like environment.],
)<f.m.maze-env>

// as seen in @f.m.rrt-colliders.

// An example of the RRT algorithm in action can be seen in @f.m.rrt-colliders. #note.jens[more about the collider, and the environment representation.]

=== Environment Integration <s.m.planning.environment-integration>

// #todo[Something somehting `parry`]

As mentioned earlier in #todo[describe how the environment i built], the environment is built from several #acr("AABB") colliders. This is done using the 2D collision detection library `parry2d`@parry2d. @f.m.rrt-colliders shows how the environment#sl, is broken into smaller #acr("AABB") collider rectangles#sr. The #acr("RRT*") algorithm defines a collision problem between all the environment colliders, and a circle#stl with radius $r_C$. Every time the #acr("RRT*") algorithm wants to place a new node, it checks if this circle, placed at the position of the new node, intersects with any of the environment colliders; where the node is abondened if it does. The radius of this circle is important, as it defines how close the path will get to the obstacles. If the radius is small, the path will tend to get closer to the obstacles, as seen in @f.m.rrt-colliders#text(accent, "A"). If the radius is equal to the step length, $s$, the path will tend towards the middle of the free space, staying far from the environment, as seen in @f.m.rrt-colliders#text(accent, "B").

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
  caption: [RRT algorithm and environment avoidance integration. Left image shows a small collision radius#stl, which results in a path that tends to get closer to the obstacles#sl. Right image shows a collision radius, equal to the step length; $r_C = s$, which results in a path that tends towards the middle of the free space, staying far from the environment. The collision radius for each node is teal#stl when no intersection is detected, and red#sr when an intersection is detected.],
)<f.m.rrt-colliders>

=== Path Adherence <s.m.planning.path-adherence>

In general the path-finding algorithm chosen doesn't matter for either of the approaches described here. What is required is; 1) the path that is found, places waypoints near most of the bends in the path, and 2) the path avoids big obstacles. The possible approaches for the path adherence are as follows:
#set enum(numbering: box-enum.with(prefix: "Approach "))
+ Simply perform a #acr("RRT*"), and use the resulting points as waypoints. Only difference from the original@gbpplanner is that the waypoints are not placed by hand, but by the #acr("RRT*") algorithm, which has information about the environment.
+ From the points in the #acr("RRT*") path, introduce a new kind of factor, $f_t$; a tracking factor. This factor will be used to _track_ the robot along the path, by _pulling_ the prediction horizon towards the found path. This approach leverages the already-existing factorgraph structure, which is to follow a global path on a local level.

The main difference between the two approaches is that the second approach is more likely to adhere to the path, as it is _pulled_ towards the path, simply tracking directly towards the next waypoint. Both #boxed[Approach 1] and #boxed[Approach 2] are generalisable over any sequence of waypoints. In effect these waypoints could be generated by a different path-finding algorithm such as A\* or Dijkstra. However, one could argue that the #acr("RRT*") and other sample-based algorithms are more suited for this task, as the found path hasn't been descritised into a grid, which might need a level of post-processing to be useful. Solutions that use these grid-based algorithms are not explored by this thesis, but not ruled out as a possibility either. #jens[Maybe mention this in future work?]

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
#jens[make figure for each approach described above.]
#jens[make figure that matches the end reasult of the path tracking.]

==== Approach 1: Waypoint Tracking


==== Approach 2: Path Tracking
