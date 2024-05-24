#import "../../lib/mod.typ": *
== Metrics <s.r.metrics>
// #jonas[This section mostly is simply missing some layouting concern. And also some equations other than that please do comment on content.]

To objectively compare our reimplementation with the original GBP Planner, we measure and compare the same four metrics: distance travelled, makespan, smoothness, and inter robot collisions@gbpplanner:


#set enum(numbering: box-enum.with(prefix: "Metric-"))

#let metric(name) = [_ #name _ #h(1em)]

+ #metric[Distance travelled] The cumulative distance covered by the robot until it reaches its destination. Effective trajectories aim to minimize this measure.
+ #metric[Makespan] The overall duration for all robots to achieve their objectives. A collaborative system of numerous robots should strive to reduce this measure.
+ #metric[Smoothness] Continuous smooth trajectories are required in most cases, in order to be realisable for the dynamics model of the robot. Such as those due to wheel actuators/encoders.  Smoothness is inherently a geometric property of the path traversed. Too quantify this, the #acr("LDJ") metric is used@ldj-metric. It is a dimensionless metric that looks at how the jerk of a movement changes over a timespan. The equation for it is defined here @equ.ldj. Values lie in the interval $[0, -infinity]$ where closer to $0$ is better.

// as it does not depend on the time taken or velocity #note.kristoffer[how is this true given the equation]. It is defined as

// Smoothness: Robot trajectories must be smooth, in order to be feasible with respect to real-world constraints such as those due to actuators. Since smoothness is intrinsically a geometric property of the path, it should not depend on time taken or velocity. We use the Log Dimensionless Jerk (LDJ), a smoothness metric first defined in [14]. This metric is a lognormalised value of the total squared jerk along the trajectory and is defined as LDJ ∆ = − ln ( (tfinal − tstart)3 v2 max ∫ tfinal tstart | ̈ v(t)|2 dt ) (22) where t ∈ [tstart, tfinal] is the time interval over which the metric is considered, v(t) is the robot velocity at time t, and vmax is the maximum velocity along the trajectory. The LDJ metric was shown to be a better indicator of smoothness than other dimensionless metrics, and values that are more positive represent ‘smoother’ paths.

// #kristoffer[use same citation as them]

// dimensionless metric #note.k[higher is better?]

// #line(length: 100%, stroke: red + 10pt)

// This metric aims to quantify the smoothness of the robot's trajectories.

// $ L D J attach(=, t: Delta)  -ln( (t_("final") - t_("start"))^3 / v^2_("max") integral_(t_("start"))^(t_("final")) abs(attach(limits(v), t: dot.double)(t))^2 d t)  $ <equ.ldj>
$ L D J attach(=, t: Delta)  -ln( (t_("final") - t_("start"))^3 / v^2_("max") integral_(t_("start"))^(t_("final"))  abs((d^2 v(t))/(d t))^2  d t)  $ <equ.ldj>

// #let ldj(t_start, t_final, )

-  $t in [t_("start"), t_("final")]$ is the time interval the metric is measured over.
- $v_("max")$ is the maximum velocity along the trajectory.
- $v(t)$ is the velocity of a robot at time $t$.
- $attach(limits(v), t: dot.double)(t)$ is change in acceleration at time $t$. Also known as jerk.

Each robots velocity is sampled and recorded with an interval of $20 H z$. For numerical integration Simpson's rule is used@simpsons-rule. The code for how the metric is computed can be found in the accompanying source code@repo under #github("AU-Master-Thesis", "gbp-rs", path: "./scripts/ldj.py"), and in @appendix.ldj-metric-computation.



4. #metric[Inter Robot Collisions] Number of collisions between robots. The physical size of each robot is represented by a bounding circles, equal in radius to the robot's radius. A collision between two robots happen when their circles intersect.

In addition to the metrics used by by Patwardhan _et al._@gbpplanner the following metrics are also looked at:

5. #metric[#acr("RMSE") of Perpendicular Path Deviation]


      // std-block(
      //   breakable: false,
      // )[
      //   #image("../../../figures/out/rrt-optimisation-no-env.svg")
      //   #v(0.5em)
      //   #text(theme.text, [A: Path Optimisation])
      // ],

#kristoffer[improve figure and layout]
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  // [#lorem(50)],
  [
  At each sampled position the distance between it and the closest projection onto each line segment of the planned path is measured and accumulated using the #acr("RMSE") score. A visual depiction of this is shown in @f.perpendicular-path-deviation. This is measured to test the effect of the proposed tracking factor, see #todo[ref], as some applications might require that robots follow a path with little deviation.

],

  std-block(
    breakable: false,
  )[
#figure(
  image("../../figures/out/perpendicular-path-deviation.svg"),
    // caption: figure.caption(
    //     position: top,
    //     [Illustration of how the perpendicular path deviation error is calculated. The green#sg line segments are the optimal path between waypoints. The red#sr line segments are the planned path. The dashed gray#sgr lines show the projection with the shortest distance to one of the waypoint segments, from a sampled position.]
    //   )
    caption:  [Illustration of how the perpendicular path deviation error is calculated. The green#sg line segments are the optimal path between waypoints. The red#sr line segments are the planned path. The dashed gray#sgr lines show the projection with the shortest distance to one of the waypoint segments, from a sampled position.]

) <f.perpendicular-path-deviation>
  ]


// [#figure(
//   image("../../figures/out/perpendicular-path-deviation.svg"),
//     caption: [Illustration of how the perpendicular path deviation error is calculated. The green#sg line segments are the optimal path between waypoints. The red#sr line segments are the planned path. The dashed gray#sgr lines show the projection with the shortest distance to one of the waypoint segments, from a sampled position.]
// ) <f.perpendicular-path-deviation>]
//
//
)

// $ proj $
  // $ d = ||P - P'|| = || P - (A + "proj"_(A B) A P) $

  $ { L_1, L_2, ..., L_m } $
  $ { P_1, P_2, ..., P_n } $
  $ d_j = min_i {"distance"(P_j, L_i)} $

$ "RMSE" = sqrt(1/n sum_(j=1)^(n) (min_i {"distance"(P_j, L_i)})^2 ) $

#kristoffer[compress equations more]
// $ "RMSE" = sqrt(1/n sum_(j=1)^(n) (min_i {d(P_j, L_i)})^2 ) $


6. #metric[Environment Robot Collisions] Number of collisions between robots and the environment. Similar to _Inter Robot Collisions_ bounding circles are used for the robots. Each environment obstacle is equipped with a collider of the same geometric layout. // For obstacles that are not rectangular like the triangles in the Circle experiment, see @s.r.scenarios.circle the minimum #acr("AABB") fully containing the triangle is used.


// Opposite to _Inter Robot Collisions_ #acrpl("AABB") are used to check for intersections. The reason for this is that _parry2d_ the library used for checking intersection of geometric shapes do not support checking intersections between bounding circles and #acrpl("AABB")@parry2d#footnote([As of version 0.13.7]). To be conservative the minimum #acr("AABB") is used for both robots and obstacles, instead of bounding spheres, which would cover a significantly larger area in some of the environment obstacles in the _*Circle*_ experiment are non-rectangular, see @s.r.scenarios.circle,


7. #metric[Maximum Task Completion Time Difference] This metric represents the largest difference between the end times of each robot's task. In a collaborative setting, it is desirable for robots with similar tasks to finish in roughly the same amount of time to ensure high task throughput. Especially when there is inter-task dependencies between robots.
