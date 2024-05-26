#import "../../../lib/mod.typ": *
=== Factor Graph <s.m.factor-graph>

#jens[Make sure factor graph notation is consistent with background math notation.]

This section describes how the factor graph theory is used in the developed software. Thus, detailing each factor used in the #acr("GBP") algorithm, as was also done in the original work@gbpplanner. As touched on in @s.b.factor-graphs, the factors are the components of the factor grah that introduces constraints between the variables.

==== Variables $bold(V)$ <s.m.factors.variables>

The variables represent the state of the robot at a given time in the future. The statespace is four dimensional, and consists of the robot's position and its first derivative; velocity, see @eq.state.

$
  X = mat(x, y, equation.overdot(x), equation.overdot(y))
$<eq.state>

Hence, the variables and thus robots all have four #acr("DOF") each; i.e. $"DOFS" = 4$ and doesn't change during the inference process.

#todo[variables math]

==== First Order Jacobian <s.m.factors.jacobian-first-order>
The first order Jacobian is used to calculate the gradient of the factor measurement. The Jacobian is defined in $RR^(R times C)$, where $R$ is defined by the amount of rows in the factor measurement $h(X)$, and $C$ is the amount of columns in the linearisation point, which is state space columns multiplied by the amount of variables the factor connects.

In mathematical terms, the implemented `first_order_jacobian`#footnote[Found in the #gbp-rs(content: [#crates.gbpplanner-rs]) crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/9d06aab257eec234a57a8a8a87ce54369da00cce/crates/gbpplanner-rs/src/factorgraph/factor/mod.rs#L102", "/src/factorgraph/factor/mod.rs:102")] function, can be expressed as follows; let

- $h : RR^n -> RR^m$#note.jens[be more specific with dimensions?] be the factor measurement function that maps a linearisation point to a measurement.
- $x$ be the linearisation point, an $n$-dimensional vector, representing the state or states at which the Jacboian is computed.
- $delta$ be a small perturbation value for computing the finite difference approximation.

The function computes the Jacobian matrix $jacobian$ of $h$ at $x$ by approximating the partial derivatives with respect to each component of $x$ using the #acr("FDM"). Mathematically, the $j$-th column of $jacobian$, denoted as $jacobian_j$, is computed using @eq.foj-column-j:

$
  jacobian_j = (h(x + delta e_j) - h(x)) / delta
$<eq.foj-column-j>

#let eq-exp = [
  #show regex("(Matrix)"): set text(theme.mauve, font: "JetBrainsMono NF")
  where $e_j$ is the $j$-th unit vector in $RR^n$, i.e. with 1 in the $j$-th position and 0 elsewhere. The Jacobian matrix is then computed by stacking the columns $jacobian_j$ for $j = 1, 2, ..., n$, which is described in @alg.jacobian-first-order; where `Matrix(r,c)` is a function that creates a zero matrix of size $r times c$.
]

#let func(content) = text(theme.mauve, content)
#let alg = [
  #algorithm(
    [
      #show regex("(Matrix)"): set text(theme.mauve, font: "JetBrainsMono NF", size: 0.85em)
      #let ind() = h(2em)
      *Input:* $x, delta$ \ \

      $h_0 #la h(x)$ \
      $jacobian #la "Matrix"(m, n)$ \ \

      *for* $j = 0, dots, "x.len"()-1$ *do* \
      #ind()$x_j #la x_j + delta$ \
      #ind()$h_1 #la h(x)$ \
      #ind()$h^prime #la (h_1 - h_0) / delta$ \
      #ind()$jacobian_j = h^prime$ \
      #ind()$x_j #la x_j - delta$ \
      *end* \ \

      *Output:* $jacobian$
    ],
    caption: [First Order Jacobian]
  )<alg.jacobian-first-order>
]

#let exp = [Thus the first order Jacobian is formed, resulting in an $RR^(m times n)$ matrix, where $m$ is the amount of rows in the measurement, $h$, and $n$ is the amount of columns in the linearisation point, $x$. This Jacobian represents the linear approximation of how the factor measurement changes with respect to small changes in each component of the linearisation point.]

#grid(
  columns: (
    5fr,
    4fr,
  ),
  column-gutter: 1em,
  alg,
  eq-exp + linebreak() + h(1em) + exp,
)


==== Pose Factor $bold(f_p)$ <s.m.factors.pose-factor>
The pose factor is the most basic, but also quite a crucial factor in the factor graph. It expresses a strictness on a variables belief at a given timestep. The pose factor can thereby be used to enforce a "known" position. For example, the robot is known to be at its current position and therefore the first variable in the chain has a strict pose factor attached. The same is the deal for the last variable in the chain, which enforces a _want_ to be at that position in the future. Every variable inbetween doesn't have a pose factor, as they are free to move within the constraints of the other factors. This is what allows the robot to diverge from its trajectory to collaboratively avoid other agents while maintaining a trajectory that will eventually lead to the goal.

#todo[Pose factor math]

==== Dynamic Factor $bold(f_d)$ <s.m.factors.dynamic-factor>
The dynamic factor imposes the kinematic constraints on the robot. If one were to model a differential drive robot, it would take place here. For the purpose of this reproduction, the dynamic factor doesn't impose any non-holonomic constraints, but simply ensures that the straight line between two variables is viable.

The dynamic factor Jacobian, $jacobian_d$, is defined in $RR^(4 times 8)$, as the factor connects two variables. This Jacobian is computed and cached when the factor is created, as it doesn't change during the inference process.

$
  #let ident = $bold(upright(I))$
  #let zero = $bold(upright(0))$
  jacobian_d = mat(
    ident_n, delta_t ident_n, -ident_n, zero_n;
    zero_n, ident_n, zero_n, -ident_n;
  ) = mat(
    1, 0, delta_t, 0, -1, 0, 0, 0;
    0, 1, 0, delta_t, 0, -1, 0, 0;
    0, 0, 1, 0, 0, 0, -1, 0;
    0, 0, 0, 1, 0, 0, 0, -1;
  )
$<eq.jacobian-d>

Where $ident_n$ is the $n times n$ identity matrix, $zero_n$ is the $n times n$ zero matrix, $delta_t$ is the time step between the two variables, and $n = "DOFS" "/" 2$, that is, half the state space dimensions.

#todo[Measurement math]
#todo[Measurement precision]

==== Obstacle Factor $bold(f_o)$ <s.m.factors.obstacle-factor>
The obstacle factor makes sure that the robot doesn't collide with any of the static environment. This is done by using a 2D #acr("SDF") representation of the environment baked into an image. The obstacle factors then measure the lightness of the #acr("SDF") at the linearisation point, which determines whether the factor detects future collision or not.

#figure(
  std-block(todo[SDF example image, e.g. from the circle with obstacles environment.]),
  caption: [Example of a signed distance field, where the lightness of the pixel represents the distance to the closest obstacle.]
) <f.sdf-example>

And example #acr("SDF") is shown in @f.sdf-example. The #acr("SDF") is a greyscale image, where white regions are obstacle-free, and black regions are occupied by obstacles in the environment. Furthermore, the image has image is blurred as to represent distances to objects as values in grey. That is, everything between a lightness of 0% and 100% conceptually represents the distance to the closest object, but not in what direction it lies.

The Jacobian for the obstacle factor, $jacobian_o$, is defined in $RR^(1 times 4)$, and is the first order Jacobian following @alg.jacobian-first-order. As such, using the first order Jacobian, measuring the gradient underlying #acr("SDF"), enables the Jacobian to impact the factor potential to _push_ the variable in the opposite direction of environment obstacles, during the next message iteration.

#jens[Measurement math]

==== Interrobot Factor $bold(f_i)$ <s.m.factors.interrobot-factor>
The interrobot factor expresses how robots should interact with each other when they get close enough. Interrobot factors measure the distance between the two robots, and if they get too close, the factor will in turn impose a repulsive force on the robots. Interrobot factors only exist between robots that are close enough, however, as soon as they are, an interrobot factor will be created between each variable for each timestep. This happens symmetrically, which means both robots will have a factor for each of its variables that connects externally to the other robot's variables. These are the connection that are used when external iterations of #acr("GBP") are made#note.kristoffer[refer to where you explain these]. To identify the connected variable in the external factorgraph, the interrobot factor store an unique identifier that consists of a two field tuple of the robots id, and index offset from the current variable. The interrobot factors take a safety distance into account which is some scaled version of the two robots' radii, see @eq.interrobot-factor.

$
  h_r (x_k^A, x_k^B) = cases(
    1 - (d_r (x_k^A, x_k^B)) / d_s "if" d_r (x_k^A, x_k^B) < d_s,
    0,
  )
$<eq.interrobot-factor>

where $d_r$ is the distance between the two robots, see @eq.interrobot-distance, and $d_s$ is the safety distance, which is calculated as $d_s = f times r$, where $f$ is a configurable parameter; scaling the robot's radius.

$
  d_r (x_k^A, x_k^B) = ||x_k^A - x_k^B||
$<eq.interrobot-distance>

To weaken the effect of states further into the future, the factors precision matrix is defined as $Lambda_r = (t_k sigma_r)^(-2) bold(I)$. The interrobot factor Jacobian, $jacobian_i$, is defined in $RR^(4 times 8)$ as shown in @eq.jacobian-i. #att[The Jacobian is used to calculate the gradient of the factor], which is used in the inference process.
$
  jacobian_i = mat(
    - (r (p_1_x - p_2_x)) / d_s, - (r (p_1_y - p_2_y)) / d_s, 0, 0, (r (p_1_x - p_2_x)) / d_s, (r (p_1_y - p_2_y)) / d_s, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
  )
$<eq.jacobian-i>

Where $r$ is the robot's radius, $d_s$ is the safety distance, $p_1$ and $p_2$ are the positions of the two variables.

#todo[Measurement precision math]


==== Asynchronous Message Passing <s.m.factors.asynchronous-message-passing>

As mentioned#note.jens[make sure this is mentioned in background] in @s.b.factor-graphs, the factor graph inference typically happens in a synchronous manner. A variable to factor message first, then a factor to variable message. This synchronous method will likely converge towards the true marginals. However, the factor graph structure allows for asynchronous message passing, although with a slower convergence, and likely with a higher variance. But in theory, variables and factors can always keep each other updated as soon as they have something to update with, or as soon as they get the opportunity to do so. Thus all the necessary information for inference will still be passed, hence still expecting similar convergence.

This is very useful in a multi-agent system such as `gbpplanner`@gbpplanner, where robots don't have boundless communication possibilities. As described above; the messages passed to and from interrobot factors from one robot to another robot represent the communication between the robots. In `gbpplanner`, and thus also in this reproduction the robots have a finite communication radius, and radios that sometimes fail. This means that synchronous iterations aren't guaranteed, but messages are rather passed on an opportunistic basis.

#todo[say more about the internal and external iterations of GBP]
