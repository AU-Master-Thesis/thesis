#import "../../lib/mod.typ": *
== #study.H-3.full.n <s.d.study-3>

Here the results from the third contribution #study.H-3.name deliberated

// 1. about the global planning layer
=== On the Global Planning Layer
The global planner has successful benn implemented with the pseudo-optimal #acr("RRT*") methodology, which provides very satisfactory results in a highly complex maze-like environment. The robots' ability to navigate in these environment by themselves has been introduced with this contribution, which wasn't a possibility with #gbpplanner@gbpplanner, which is completely manual in this aspect.

// 2. About the tracking factor
=== On the Tracking Factor
As seen in the results; it has been possible to the extend the underlying factor graph wit han extra factor to combat path deviation issues. The tracking factor, $f_t$, provides a stable way to reach a lower path deviation error. This tracking factor is very useful when you want to guarantee with soft constraints some level of path adherence. Being able to reason about such a property is very useful in a multi-agent system, where you want to ensure that the agents are not only reaching their goals, but also doing so in a way that is not disruptive to the environment or other agents. This can be achieved by constricting the global planner to only plan paths that don't intersect with each other. It could for example be the case that, in a large facility you want robots travelling in one direction to stay on the right side of the hallway, and vice versa. These constraints can be the global planner's responsibility, instead of overloading the #acr("GBP") with unecessary local complexity. Not that the #acr("GBP") can't handle these issues, but with many robots, having an overall structure, or underlying plan embedded as a pre-step will likely avoid many local minima hold-ups, where robots are struggling to get past each other.
