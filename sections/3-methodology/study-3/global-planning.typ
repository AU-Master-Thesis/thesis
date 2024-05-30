#import "../../../lib/mod.typ": *
=== Global Planning <s.m.global-planning>

#let gp = (
  robot: text(theme.peach, $bold(R)$),
  A: text(theme.green, $bold(A)$),
  B: text(theme.blue, $bold(B)$),
  A1: boxed(text(weight: 900, "GP-1")),
  A2: boxed(text(weight: 900, "GP-2")),
)

Global planning has been made as an extension to the original GBP Planner software developed by @gbpplanner. The original algorithm works very well on a local level, and lacks a global overview of how to get from #gp.A to #gp.B. In order to solve this problem; a pathfinding algorithm has to be leveraged. In this thesis, the optimal #acr("RRT*") path planning algorithm has been utilised. The theory behind #acr("RRT*")@sampling-based-survey@erc-rrt-star can be found in @s.b.rrt-star, which builds on the original #acr("RRT")@original-rrt algorithm in @s.b.rrt. However, do note that the method described here is algorithm-agnostic, that is; as long at the path-finding algorithm in use outputs a series of points that avoid obstacles, it can be swapped in instead of #acr("RRT*"). The global planning procedure follows @ex.global-planning.

#example(
  caption: [Global Planning Procedure],
)[
  #set par(first-line-indent: 0em)
  #[
    Algorithm-agnostic global planning procedure. Any time PF is mentioned, it refers to the path-finding algorithm in use, e.g. #acr("RRT*").
  ]
  #grid(
    columns: (2.3fr, 3fr),
    blocked(
      title: [*Setup*],
      color: none,
      divider-stroke: 0pt,
    )[
      - A robot #gp.robot needs to get from point #gp.A to point #gp.B.
      - The path from #gp.A to #gp.B is convoluted, and includes more than simple obstacles to go around.

        An exemplification of such an environment could be a maze-like structure, see @f.m.maze-env.
    ],
    blocked(
      title: [*Steps*],
      color: none,
      divider-stroke: 0pt,
    )[
      #set enum(numbering: box-enum.with(prefix: "Step "))
      + The PF algorithm is used to find a path from #gp.A to #gp.B.
      + The result of PF is a series of points that can now be leveraged to navigate through the environment.
      + The GBP local planning will still be in effect, in order to avoid obstacles and other robots in a local context.
    ]
  )
]<ex.global-planning>

The environment for each experiment scenario is generated from an configuration file, which is described in @s.m.configuration, and the experimentation scenarios can be seen in @s.r.scenarios.



==== Robot Mission <s.m.robot-mission>
#jens[Maybe this should be in the Global Planning section]

#k[talk about Mission Component]

// as seen in @f.m.rrt-colliders.

// An example of the RRT algorithm in action can be seen in @f.m.rrt-colliders. #note.jens[more about the collider, and the environment representation.]

=== Environment Integration <s.m.planning.environment-integration>

// #todo[Something something `parry`]

As mentioned earlier in, the environment is built from several #acr("AABB") colliders. This is done using the 2D collision detection library `parry2d`@parry2d. @f.m.rrt-colliders shows how the environment#sl, is broken into smaller #acr("AABB") collider rectangles#sr. The #acr("RRT*") algorithm defines a collision problem between all the environment colliders, and a circle#stl with radius $r_C$. Every time the #acr("RRT*") algorithm wants to place a new node, it checks if this circle, placed at the position of the new node, intersects with any of the environment colliders; where the node is abondened if it does. The radius of this circle is important, as it defines how close the path will get to the obstacles. If the radius is small, the path will tend to get closer to the obstacles, as seen in @f.m.rrt-colliders#text(accent, "A"). If the radius is equal to the step length, $s$, the path will tend towards the middle of the free space, staying far from the environment, as seen in @f.m.rrt-colliders#text(accent, "B").

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

Again, do note that even though #acr("RRT*") is used here, the collision detection is a detached module, which can also be used with other path-finding algorithms. The `rrt` crate@rrt-crate has been extended for the purpose of this thesis, as it only provided an #acr("RRT") implementation, the authors have extended it to include the #acr("RRT*") algorithm as well. This is done through the `rrstar`#footnote[Found in the #source-link("https://github.com/AU-Master-Thesis/rrt", "rrt") crate at #source-link("https://github.com/AU-Master-Thesis/rrt/blob/d4384c7ef96cde507f893d8953ce053659483f85/src/rrtstar.rs#L159", "src/rrtstar.rs:159")]<footnote.rrtstar> function, which provides an interface taking two $N$-dimensional points, a step length, a neighbourhood radius, a max number of iterations, see @lst.rrtstar. Furthermore, it is a higher order function which takes two function closure trait objects; `is_collision_free` and `random_sample`.

#listing(
  [
    ```rust
    pub fn rrtstar<N>(
      start: &[N],
      goal: &[N],
      mut is_collision_free: impl FnMut(&[N]) -> bool,
      mut random_sample: impl FnMut() -> Vec<N>,
      extend_length: N,
      max_iters: usize,
      neighbourhood_radius: N,
      stop_when_reach_goal: bool,
    ) -> RRTStarResult<N, f32>
    where
        N: Float + Debug,
    { ... }
    ```
  ],
  caption: [The `rrtstar`@footnote.rrtstar function signature.],
)<lst.rrtstar>

=== Path Adherence <s.m.planning.path-adherence>

// #jonas[Take a look at this section and then at the top, where I have described a separate study (4) for the path tracking stuff. Does it make sense to separate it out, or is it good to have it in this context. I feel like you're biased towards wanting it in this context, but I am not too sure, since the path tracking is a general factor graph addition, which works no matter how the path is found or given, where the global planning is path-finding stuff, which is separate from figuring out how to follow the path right?]

In general the path-finding algorithm chosen doesn't matter for either of the approaches described here. What is required is; 1) the path that is found, places waypoints near most of the bends in the path, and 2) the path avoids big obstacles. The possible approaches for the path adherence are as follows:

#set enum(numbering: box-enum.with(prefix: "GP-"))
+ *Waypoint Tracking:* Simply perform a #acr("RRT*"), and use the resulting points as waypoints. Only difference from the original@gbpplanner is that the waypoints are not placed by hand, but by the #acr("RRT*") algorithm, which has information about the environment.
+ *Path Tracking:* From the points in the #acr("RRT*") path, introduce a new kind of factor, $f_t$; a tracking factor. This factor will be used to _track_ the robot along the path, by _pulling_ the prediction horizon towards the found path. This approach leverages the already-existing factorgraph structure, which is to follow a global path on a local level.

#todo[
  Tracking without global planning?
]

The main difference between the two approaches is that the second approach is more likely to adhere to the path, as it is _pulled_ towards the path, simply tracking directly towards the next waypoint. Both global planning approach #gp.A1 and #gp.A2 are generalisable over any sequence of waypoints. In effect these waypoints could be generated by a different path-finding algorithm such as A\* or Dijkstra. However, one could argue that the #acr("RRT*") and other sample-based algorithms are more suited for this task, as the found path hasn't been descritised into a grid, which might need a level of post-processing to be useful. Solutions that use these grid-based algorithms are not explored by this thesis, but not ruled out as a possibility either.
#jens[Maybe mention this in future work?]


==== Approach 1: Waypoint Tracking <s.m.planning.waypoint-tracking>
The steps to perform this approach is visualised in @f.m.waypoint-tracking, and are:
#[
  #set enum(numbering: box-enum.with(prefix: "Step "))
  + Perform the #acr("RRT*") algorithm to find a path from #gp.A to #gp.B.
  + Where usually #gp.A and #gp.B would be used as waypoint, now instead; use the points of the resulting path as waypoints.
  + Follow the waypoint with the already existing local planning algorithm without any modifications.
]

#figure(
  [],
  caption: [Waypoint tracking steps.],
)<f.m.waypoint-tracking>

#[
  #set par(first-line-indent: 0em)
  *Expectation:* The waypoints from the path will be followed, however, without any guarantees or attempts to adhere to the known obstacle free path that the line the resulting #acr("RRT*") path represents. However, as the #acr("RRT*") path is obstacle-free, the original difficulty with more complex environments without global planning is solved. Furthermore, without any path adherence measures, other than aiming for the next waypoint, the robots will have much more freedom to cut corners, and also to move around each other in more _complex_#note.wording[creative / sophisticated ?] ways.
]


==== Approach 2: Path Tracking <s.m.planning.path-tracking>

To achieve a level of adherence to the path given to each robot, the  factor graph structure can be utilised. A new factor, namely the tracking factor, $f_t$, has been designed to reach this goal. The tracking factor is designed to attach to each variable in the prediction horizon, except for the first and last that already have anchoring pose factors, as these cannot be influenced either way. In @s.m.tracking-factor, the design of the tracking factor is explained in detail, while @f.m.tracking-factor visualises the inner working.

// #figure(
//   {
//     // set text(font: "JetBrainsMono NF", size: 0.85em)
//     grid(
//       columns: (30%, 30%),
//       std-block(
//         breakable: false,
//       )[
//         #image("../../../figures/out/rrt-optimisation-no-env.svg")
//         #v(0.5em)
//         #text(theme.text, [A: Path Optimisation])
//       ],
//       std-block(
//         breakable: false,
//       )[
//         #image("../../../figures/out/rrt-path-tracking.svg")
//         #v(0.5em)
//         #text(theme.text, [B: Path Tracking])
//       ],
//     )
//   },
//   caption: [Path tracking on the pseudo-optimal path found with #acr("RRT*").],
// )<f.m.path-tracking>

#figure(
  {
    include "figure-tracking.typ"
  },
  caption: [Visualisation of the tracking factor's measurements. On A) it is visualised how the tracking factor pulls the variable towards the path, while also trying to keep the variable moving along the path. Furthermore, a green area#swatch(theme.green.lighten(35%)) is shown close to the second waypoint $w_1$. Within this area, the tracking factor will track towards the corner. On B) tracking factors are visualised for a robot moving from $w_0$ to $w_1$.],
)<f.m.tracking-factor>

// #jens[make figure for each approach described above.]
// #jens[make figure that matches the end reasult of the path tracking.]

#[
  #set par(first-line-indent: 0em)
  // *Expectation:* The path tracking approach will be more likely to adhere to the path, as the tracking factors will _pull_ the prediction horizon towards the found path. This will result in a more _stable_ path, that doesn't necessarily guarantee strict adherence to the path, but it is expected that the average deviation error from the path will be lower for this approach than for #gp.A1. Lastly, this method won't provide as much freedom to the robots, which could be a good or a bad thing, depending on the context. One might need stronger path adherence guarantees, e.g. a system could exploit the found #acr("RRT*") paths to reason about each robot's whereabouts within some timeframe.

  *Expectation:* The path tracking approach, influenced by the tracking factor $f_t$, will likely adhere more closely to the prescribed path $#m.P$. This factor $f_t$ consistently pulls the prediction horizon towards the path, akin to but opposite of how the interrobot factor $f_i$ pushes the variables apart. This results in a more _stable_ path with lower average _perpendicular deviation error_ compared to approach #gp.A1. The effect should be particularly noticeable around corners, where $f_t$ reduces the tendency to cut corners and helps maintain consistent speed by minimizing the time spent correcting deviations or _catching up_ to the horizon variable. While this approach provides less freedom to the robots, it ensures stronger adherence to the path, which could be beneficial in contexts where precise path tracking is critical, such as in systems exploiting #acr("RRT*") paths for reasoning about each robot's whereabouts within specific timeframes.
]
