#import "../../../lib/mod.typ": *
=== Factor Graph <s.m.factor-graph>

This section describes how the factor graph theory is used in the developed software. Thus, detailing each factor used in the #acr("GBP") algorithm, as was also done in the original work@gbpplanner. As touched on in @s.b.factor-graphs, the factors are the components of the factor grah that introduces constraints between the variables.

==== Variables $bold(V)$ <s.m.factors.variables>

The variables represent the state of the robot at a given time in the future. The statespace is four dimensional, and consists of the robot's position and its first derivative; velocity, see @eq.state.

$
  X = mat(x, y, equation.overdot(x), equation.overdot(y))
$<eq.state>

Hence, the variables and thus robots all have four #acr("DOF") each.

#todo[variables math]

==== Pose Factor $bold(f_p)$ <s.m.factors.pose-factor>
The pose factor is the most basic, but also quite a crucial factor in the factor graph. It expresses a strictness on a variables belief at a given timestep. The pose factor can thereby be used to enforce a "known" position. For example, the robot is known to be at its current position and therefore the first variable in the chain has a strict pose factor attached. The same is the deal for the last variable in the chain, which enforces a _want_ to be at that position in the future. Every variable inbetween doesn't have a pose factor, as they are free to move within the constraints of the other factors. This is what allows the robot to diverge from its trajectory to collaboratively avoid other agents while maintaining a trajectory that will eventually lead to the goal.

#todo[Pose factor math]

==== Dynamic Factor $bold(f_d)$ <s.m.factors.dynamic-factor>
The dynamic factor imposes the kinematic constraints on the robot. If one were to model a differential drive robot, it would take place here. For the purpose of this reproduction, the dynamic factor doesn't impose any non-holonomic constraints, but simply ensures that the straight line between two variables is viable.

#todo[Dynamic factor math]

==== Obstacle Factor $bold(f_o)$ <s.m.factors.obstacle-factor>
The obstacle factor makes sure that the robot doesn't collide with any of the static environment. This is done by using a 2D #acr("SDF") representation of the environment baked into an image. The obstacle factors then measure the lightness of the #acr("SDF") at the linearisation point, which determines whether the factor detects future collision or not.

#figure(
  std-block(todo[SDF example image, e.g. from the circle with obstacles environment.]),
  caption: [Example of a signed distance field, where the lightness of the pixel represents the distance to the closest obstacle.]
) <f.sdf-example>

And example #acr("SDF") is shown in @f.sdf-example. The #acr("SDF") is a greyscale image, where white regions are obstacle-free, and black regions are occupied by obstacles in the environment. Furthermore, the image has image is blurred as to represent distances to objects as values in grey. That is, everything between a lightness of 0% and 100% conceptually represents the distance to the closest object, but not in what direction it lies.

#todo[Obstacle factor math]

==== Interrobot Factor $bold(f_i)$ <s.m.factors.interrobot-factor>
The interrobot factor expresses how robots should interact with each other when they get close enough. Interrobot factors measure the distance between the two robots, and if they get too close, the factor will in turn impose a repulsive force on the robots. Interrobot factors only exist between robots that are close enough, however, as soon as they are, an interrobot factor will be created between each variable for each timestep. This happens symmetrically, which means both robots will have a factor for each of its variables that connects externally to the other robot's variables. These are the connection that are used when external iterations of #acr("GBP") are made#note.kristoffer[refer to where you explain these].

The interrobot factors take a safety distance into account which is some scaled version of the two robots' radii.

#todo[Interrobot factor math]

==== Asynchronous Message Passing <s.m.factors.asynchronous-message-passing>

As mentioned#note.jens[make sure this is mentioned in background] in @s.b.factor-graphs, the factor graph inference typically happens in a synchronous manner. A variable to factor message first, then a factor to variable message. This synchronous method will likely converge towards the true marginals. However, the factor graph structure allows for asynchronous message passing, although with a slower convergence, and likely with a higher variance. But in theory, variables and factors can always keep each other updated as soon as they have something to update with, or as soon as they get the opportunity to do so. Thus all the necessary information for inference will still be passed, hence still expecting similar convergence.

This is very useful in a multi-agent system such as `gbpplanner`@gbpplanner, where robots don't have boundless communication possibilities. As described above; the messages passed to and from interrobot factors from one robot to another robot represent the communication between the robots. In `gbpplanner`, and thus also in this reproduction the robots have a finite communication radius, and radios that sometimes fail. This means that synchronous iterations aren't guaranteed, but messages are rather passed on an opportunistic basis.

#todo[say more about the internal and external iterations of GBP]
