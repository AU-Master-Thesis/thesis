#import "../../lib/mod.typ": *
== #study.H-3.full.n <s.d.study-3>

Here the results from the third contribution #study.H-3.name are deliberated. The results of the global planning layer and the tracking factor are discussed in @s.d.global-planning and @s.d.tracking-factor, respectively.

// 1. about the global planning layer
=== On the Global Planning Layer <s.d.global-planning>
The global planner has successfully been implemented with the pseudo-optimal #acr("RRT*") methodology, which provides very satisfactory results in a highly complex maze-like environment. The robots' ability to navigate in these environment by themselves has been introduced with this contribution, which was not a possibility with #gbpplanner@gbpplanner.
//which is completely manual in this aspect.

// Stuff about the gathered results
The results of the global planning layer are covered in @s.r.study-3, which compares the two approaches described in the #nameref(<s.m.planning.path-adherence>, "Path Adherence") methodology. The path tracking approach seems to be the most appealing alternative, as it only adds an extra linear, $cal(O)(|V|)$ computation time for each robot, each timestep, but still provides up to $#strfmt("{0:.0}", solo-gp-mean-decrease)%$ reduced path deviation error. The #scen.collaborative-gp.s scenario, shows that even with a dynamic environment, with many robots; path tracking is still able to lower the path deviation error. Comparing the solo and collaborative scenarios, it is clear that the variance is much higher as soon as more robots are introduced, which is both expected and desired. It should always be a harder constraint to avoid other robots, than to track closely to the path.

It is important to note that the combination of a sporadic, and random approach to global planning does not seem to mesh well with the path tracking approach. Looking at the number of collisions that happen at the cost of lowering path deviation, we see an increase of around $#strfmt("{0:.0}", (11.9 / 2.8) * 100)%$ in collisions, which is not a desirable trade-off. Path tracking would be more suitable for paths that are either pre-planned, or some level of predictability is present. These kinds of constraints can to be introduced through the global planner by limiting the possible sample-space, or by, in the context of #acr("RRT*"), introducing a bias towards pre-defined lanes; e.g. towards the right side of designated driving areas. A system made this way could possibly reach a level of adherence that resembles the #scen.solo-gp.n scenario, but with many robots, only having to rely on deviating from their path in crossings, or merging scenarios.

Another critical detail, is how notion of speed, and movement is currently handled both in `gbpplanner`@gbpplanner@gbpplanner-code and in #acr("MAGICS"). The horizon variable is simply moved along the given path at a static rate, not influenced by the robot's actual progress along the path. This is a double-edged sword, as it provides a way of _pulling_ on the robot until it escapes a local minima, but it also provides instability to the factor graph. In case the robot gets stuck, either between other robots or the environment, the horizon variable will keep moving, which stretches out the spacing of the variables, essentially asking the robot to go at a increasingly higher speed. This _will_ sometimes result in the obstacle or interrobot collision factors, to lose to the dynamic factor, meaning the robot will drive straight through the obstacles or robots that are in the way.

It would be beneficial to look at a smarter way to move this horizon variable. In the context of the tracking factor, one suggestion could be to attach a tracking factor to the horizon state while removing its pose factor. This might be able to pull the horizon state along the path, while also being impacted by the how far behind the robot is through the dynamic factors. Much more development is needed in this area, as the tracking factors are currently not able to guarantee _pulling_ on variables at a rate that will reach the target speed. This is a possible path of future work.

// 2. About the tracking factor
=== On the Tracking Factor <s.d.tracking-factor>
As seen in the results; it has been possible to the extend the underlying factor graph with an extra factor to combat path deviation issues. The tracking factor, $f_t$, provides a stable way to reach a lower path deviation error. This tracking factor is very useful when you want to guarantee, with soft constraints, a level of path adherence. Being able to reason about such a property is very useful in a multi-agent system, where you want to ensure that the agents are not only reaching their goals, but also doing so in a way that is not disruptive to the environment or other agents. This can be achieved by constricting the global planner to only plan paths that do not intersect with each other. It could for example be the case that, in a large facility you want trafficesque rules; where robots travelling in one direction stay on the right side, and vice versa. These constraints can be the global planner's responsibility, instead of overloading the #acr("GBP") with unnecessary local complexity. Not that the #acr("GBP") is unable to handle these issues, but with many robots, having an overall structure, or underlying plan embedded as a pre-step will likely avoid many local minima hold-ups, where robots are struggling to get past each other.

// #todo[About the balance of tracking vs. interrobot vs obstacle]

As is evident from earlier discussion about the global planning integration with the tracking factor, and the results from the #scen.collaborative-gp.s scenario, the tracking factor is able to impact the factor graph positively and negatively. Sometimes, even both at once, which is specifically shown with $sigma_t = 0.15$. This likely stems from the fact that adding another factor to the graph simply increases its complexity, and also the number of possible local minima. Furthermore, instead of balancing three factors as before, four certainties, ${sigma_d, sigma_i, sigma_o, sigma_t}$, have to be balanced to interact with each other in a way that is beneficial to the overall system. This balance is very hard to achieve, especially when factors are working against each other in a three or four-way relationship. Even though the interrobot certainty $sigma_i=0.1$ is much higher than that of the tracking factor $sigma_t=0.5$ in the last experiment, the amount of collisions was still increased with $#strfmt("{0:.0}", 3.4 / 2.8 * 100 - 100)%$, which, though lower than with $sigma_t=0.15$, is still very much undesirable. Thus, the tracking factor proves very difficult to balance while keeping a safe system, free of collisions. The earlier discussed notion of pseudo-preplanned paths, or a global planning bias in some way would help to alleviate this issue. Nevertheless, it is important to have the dynamic factor have a higher certainty than the tracking factor. This is due to the design of the tracking factor measurement function.

As deliberated in @s.m.tracking-factor, the measurement will enable the tracking factor to pull towards the corner when the linearisation point is close enough. This is once again a double-edged sword, as shown in @f.solo-plot, this behaviour eliminates most of the corner-cutting behaviour, however this specific detail also makes the factor graph more prone to local minima, where the robot gets stuck in a corner if most of its tracking factors are pulling towards it. This is however mostly alleviated by making sure that the tracking factor's certainty is not close to or higher than the dynamic factor's. This way the dynamic factors have more pull on each individual variable, enabled them to _overpower_ the tracking factors when necessary.
