#import "../../../lib.typ": *
=== Global Planning
// RRT

Global planning has been made as an extension to the original GBP Planner software developed by #todo[cite]. The original algorithm works very well on a local level, and lacks a global overview of how to get from A#sg to B#sb as seen in @f-m-rrt-colliders.

An example of the RRT algorithm in action can be seen in @f-m-rrt-colliders. #note.jens[more about the collider, and the environment representation.]

#figure(
  image("../../../figures/out/rrt-colliders.svg", width: 30%),
  caption: [RRT algorithm and environment integration.],
)<f-m-rrt-colliders>

==== Path Adherence