#import "../../lib.typ": *
== Metrics

To objectively compare our reimplementation with the original GBP Planner, we measure and compare the same four metrics: distance travelled, makespan, smoothness, and inter robot collisions@gbpplanner:

#let metric(name) = [_ #name _ #h(1em)]

+ #metric[Distance travelled] The cumulative distance covered by the robot until it reaches its destination. Effective trajectories aim to minimize this measure.
+ #metric[Makespan] The overall duration for all robots to achieve their objectives. A collaborative system of numerous robots should strive to reduce this measure.
+ #metric[Smoothness] Continous smooth trajectories are required in most cases, in order to be realisable for the dynamics model of the robot and other real world constraints. #note.kristoffer[like what, torque, friction?].

Smoothness is a geometric property of the path traversed.

#kristoffer[use same citation as them]

dimensionless metric #note.k[higher is better?]



This metric aims to quantify the smoothness of the robot's trajectories.

$ L D J attach(=, t: Delta)  -ln( (t_("final") - t_("start"))^3 / v^2_("max") integral_(t_("start"))^(t_("final")) abs(attach(limits(v), t: dot.double)(t))^2 d t)  $ <equ.ldj>

where $t in [t_("start"), t_("final")]$ is the time interval the metric is measured over. $v(t)$ is the velocity of a robot at time $t$, and $v_("max")$ is the maximum velocity along the trajectory.

4. #metric[Inter robot Collisions] Number of collisions between robots. The physical size of each robot is represented by a bounding circle. A collision between two robots happen when their circles intersects.



In addition to the metrics used by by Patwardhan _et al._@gbpplanner we also consider the following metrics:

5. #metric[#acr("RMSE")]
