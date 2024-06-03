#import "../../lib/mod.typ": *
== Factor Graphs <s.b.factor-graphs>

// NOTES:
// Explain the concept of factor graphs
// - variables and factors
// - visually it is undirected bipartite graph
// - factorisation of a joint function
// - factors are functions that determine probability, not probability in themself @alevizos_factor_2012
// - representing the factorisation of a joint function
// from @loeliger_introduction_2004:
// - in probability used to represent a _probability distribution function_
//
// Properties:
// - enables efficient computation
// - enables computation of marginal distributions through the sum-product algorithm
// - generalisation of constraint graphs
//
// Gaussian factor graph:
// Explaining how the
// - factors are Gaussian distributions
// - measurement or constraint of factor is represented by a measurement function $h$
// - variables are the mean and variance of the Gaussian

// Mathematically, the Hammersley-Clifford Theorom states that any positive joint distribution can be represented as a product of factors,

A factor graph is a bipartite graph with undirected edges, where the nodes are divided into two disjoint sets; variables and factors. And exemplification of a factor graph and important intuition is shown in @ex.factor-graph. The edges between nodes each connect one from each set, and represent the dependencies between the variables and factors. A factor graph represents the factorisation of any positive joint distribution, $p(#m.Xb)$, as stated by the Hammersley-Clifford Theorom. That is, a product of factors for each set of related variables in the graph, which can be seen in @eq.factor-product@gbpplanner@gbp-visual-introduction@dellaert_factor_2017@loeliger_introduction_2004@alevizos_factor_2012.

$
  p(#m.Xb ) = product_{i} f_i (#m.Xb _i)
$<eq.factor-product>

Thus interpreting this, the factors are not necessarily in themselves probabilities, but rather the functions that determine the probabilities of the variables.@loeliger_introduction_2004@alevizos_factor_2012 Additionally, it can be useful to present factor graphs as energy-based models@energy-based-models, where, as seen in @eq.factor-energy@gbp-visual-introduction, each factor $f_i$ is associated with an energy $E_i > 0$:

$
  f_i(#m.Xb _i) = exp(-E_i(#m.Xb _i))
$<eq.factor-energy>

This presentation also gives another way of finding the #acr("MAP") estimate, by finding the state with the lowest energy in the factor graph, see @eq.map-energy@gbp-visual-introduction:

$
  #m.Xb _"MAP" &= "arg min"_#m.Xb -log p(#m.Xb) \
          &= "arg min"_#m.Xb sum_i E_i(#m.Xb _i)
$<eq.map-energy>

#example(
  caption: [Factor Graph]
)[
  #let body = [
    An example factor graph is visualised in @fig.factor-graph, with variables #text(theme.green, ${v_1, dots, v_4}$) and factors #text(theme.lavender, ${f_1, dots, f_4}$). Writing out the visualised factor graph produces @eq.example.factor-graph.

    $
      p(v_1,v_2,v_3,v_4) = 1/Z &f_1(v_1,v_2,v_3) f_2(v_3,v_4) \
      &f_3(v_3,v_4) f_4(v_4)
    $<eq.example.factor-graph>
    Where $Z$ is the amount of factors in the graph. As such, the joint distribution also functions as a weighting of the different factors' influence.
  ]

  #let fig = [
    #figure(
      image("../../figures/out/factor-graph.svg", width: 50%),
      caption: [A factor graph is a bipartite graph, where the nodes are divided into two sets; variables and factors. Variables are represented as green circles#sg, and factors as blue squares#sl. The edges between the nodes represent the dependencies between the variables and factors.],
    )<fig.factor-graph>
  ]

  #body
  #fig

  // #grid(
  //   columns: (90mm, 1fr),
  //   body,
  //   fig
  // )
]<ex.factor-graph>

The factor graph is a generalisation of constraint graphs, and can represent any joint function. Moreover, the factor graph structure enables efficient computation of marginal distributions through the sum-product algorithm.@loeliger_introduction_2004@alevizos_factor_2012 The sum-product algorithm is detailed in @s.b.belief-propagation.

#figure(
  image("../../figures/out/robot-factor-graph.svg", width: 70%),
  caption: [Shown here are two factor graphs, one for a green#sg robot, and one for a purple#sp robot. In this specific case the two robots are close to each other, and perfectly aligned. At the top, the planning horizon is shown in blue#sl, #text(theme.lavender, $n$) times-steps into the future, #text(theme.lavender, ${t_1, t_2, dots, t_n}$). Variables are visualised as circles, and factors as squares.],
)<fig-robot-factor-graph>

// Below is factor graph notions in terms of the multi-agent robotic system we have developed
In @fig-robot-factor-graph two joint factor graphs are visualised in the context of multi-agent robotics. The first variables in each factor graph $v_1$, represent the location of a green#sg and purple#sp robot respectively. Each robot has a corresponding factorgraph, where the figure shows how the two factor graphs are connected with interrobot factors $f_i$ when they are close enough to each other. Variables $v_2, dots, v_n$ represent the future predicted states of the robot respectively at timesteps $t_2, dots, t_n$, where $t_1$ is the current time.

== Belief Propagation <s.b.belief-propagation> // The Sum-Product Algorithm <background-sum-product-algorithm>

// NOTES:
// Sum-Product Algorithm @theodoridis_machine_2020
// The sum-product algorithm is a message passing algorithm used to perform exact inference on factor graphs.
// #acr("BP") is an algorithm for marginal inference, as opposed to exact inference.

// #acr("BP") is carried out by the sum-product algorithm.@robotweb@gbpplanner@gbp-visual-introduction


Inference on a factor graph is achieved by passing messages between the variables and factors. @fig.message-passing visualises the two major steps; #iteration.variable and #iteration.factor, each with two sub-steps; an internal update, and a message passing step.

// The process of performing inference#note.wording[] on a factor graph is done by passing messages between the variables and factors. @fig.message-passing visualises the two major steps; #iteration.variable and #iteration.factor, each with two sub-steps; an internal update, and a message passing step.

#gridx(
  columns: (2em, 1fr, 4em, 1fr),
  [], [
    #set enum(numbering: req-enum.with(prefix: "Step ", color: colors.variable))
    + Variable update
    + Variable to factor message
  ], [], [
    #set enum(start: 3, numbering: req-enum.with(prefix: "Step ", color: colors.factor))
    + Factor update
    + Factor to variable message
  ]
)

#figure(
  image("../../figures/out/message-passing.svg"),
  caption: [The four steps of propagating messages in a factor graph. Firstly, the variables#sg are internally updated, and new messages are sent to neighbouring factors#sl, who then update internally, sending the updated messaages back to neighbouring variables#sg. _Note that this figure shows the #iteration.variable first, however, performing the #iteration.factor first is also a valid, the main idea is simply that they are alternating._],
)<fig.message-passing>

// #jonas[Is more context for BP and the sum-product algorithm needed?]

In #step.s1 the computation of the marginal distribution of a variable $x_i$ takes place. This is done by finding the product of all messages from neighbouring factors $f_j$ to $x_i$, as seen in  @eq.mp-variable-update@gbpplanner@robotweb@gbp-visual-introduction.

$
  m_(x_i) = product_(s in N(i)) m_(f_s #ra x_i)
$<eq.mp-variable-update>

Secondly, in #step.s2 the variable to factor messages $m_(x_i #ra f_j)$ are computed as described in @eq-mp-variable-to-factor@gbpplanner, which is a product of all messages from neighbouring factors $f_s$ except $f_j$.@gbpplanner@robotweb@gbp-visual-introduction

$
  m_(x_i #ra f_j) = product_(s in N(i) \\ j) m_(f_s #ra x_i)
$<eq-mp-variable-to-factor>

The factor to variable messages $m_(f_j #ra x_i)$ are described in @eq.mp-factor-to-variable@gbpplanner, where the message is the product of the factor $f_j$ and the messages from all neighbouring variables $x_i$ except $x_i$ itself.@gbpplanner@robotweb@gbp-visual-introduction This corresponds to the entire #iteration.factor, i.e. #step.s3 and #step.s4, also shown in @fig.message-passing.
$
  m_(f_j #ra x_i) = sum_(X_j \\ x_i) f_j (X_j) product_(k in N(j) \\ i) m_(x_k #ra f_j)
$<eq.mp-factor-to-variable>

Originally #acr("BP"), was created for inference in trees, where each message passing iteration is synchronous. This is a simpler environment to guarantee convergence in, and in fact after one synchronous message sweep from root to leaves, exact marginals would be calculated. However, factor graphs, as explained earlier, are not necessarily trees; they can contain cycles, and as such loopy #acr("BP") is required. Loopy #acr("BP"), instead of sweeping messages, applies the message passing steps to each each at every iteration, but still in a synchronous fashion.@gbp-visual-introduction

The expansion to loopy graphs is not without its challenges, as the convergence of the algorithm is not guaranteed. As such the problem transforms from an exact method to an approximate one. This means, that instead of minimising the factor energies through #acr("MAP") directly, loopy #acr("BP") minimises the #acr("KL") divergence between the true distribution and the approximated distribution, which can then be used as a proxy for marginals after satisfactory optimisation.@gbp-visual-introduction

Loopy #acr("BP") is derived via the Bethe free energy, which is a constrained minimisation of an approximation of the #acr("KL") divergence. As the Bethe free energy is non-convex, the algorithm isn't guaranteed to converge, and furthermore, it might converge to local minima in some cases. It has been shown that empirically loppy #acr("BP") is very capable of converging to the true marginals, as long as the graphs aren't highly cyclic#note.wording[too loopy? Is loopy and cyclic the same thing?].@gbp-visual-introduction

// #todo[later mention that the specific factorgraph structure is non-cyclic in our case]

== Gaussian Belief Propagation <s.b.gaussian-belief-propagation>

// #jens[do this #emoji.face.smile]

Having introduced both Gaussian models, and #acr("BP"), we can now take a look at #acr("GBP"). #acr("GBP") is a variant of #acr("BP"), where, due to the closure properties#jens[cite] of Gaussians, the messages and beliefs are represented by Gaussian distributions. In its base form #acr("GBP") works by passing Gaussians around in the #gaussian.canonical, i.e. the messages and beliefs contain the precision matrix, #text(theme.mauve, $Lambda$), and the information vector #text(theme.mauve, $eta$). As mentioned earlier, general #acr("BP") is not guaranteed to compute exact marginals, however, for #acr("GBP"); exact marginal means are guaranteed, and even though the variances often converge to the true marginals, there exists no such guaranteed.@gbp-visual-introduction

In a factor graph, where all factors are Gaussian, and since all energy terms are additive in the #gaussian.canonical, the energy of the factor graph is also Gaussian, which means that one can represent it as a single multivariate Gaussian. See the equation for this joint distribution in @eq.gaussian-joint@gbp-visual-introduction:

$
  p(X) prop exp(-1/2 X^top #m.Lambda X + #m.eta^top X)
$<eq.gaussian-joint>

==== MAP Inference <s.b.gbp.map-inference>

In the context of #acr("GBP"), the #acr("MAP") estimate can be found by the parameters $X_"MAP"$ that maximises the joint distribution in @eq.gaussian-joint. The total energy can then be written as @eq.gaussian-energy-total@gbp-visual-introduction

$
  nabla_X E(X) = nabla_X log P(X) = -#m.Lambda X + #m.eta
$<eq.gaussian-energy-total>

which is the gradient of the log-probability, and can be set to zero, $nabla_X E = 0$, to find the #acr("MAP") estimate, which, in #acr("GBP") is reduced to the mean #m.mu, as seen in @eq.gaussian-map@gbp-visual-introduction:

$
  X_"MAP" = #m.Lambda^(-1) #m.eta = #m.mu
$<eq.gaussian-map>

==== Marginal Inference <s.b.gbp.marginal-inference>

The goal of marginal inference in #acr("GBP") is to find the per variable marginal posterior distributions. In the #gaussian.moments this looks like @eq.gaussian-marginal-moments@gbp-visual-introduction:

$
  p(x_i) &= integral p(X) #h(0.25em) d X_(-i) \
         &prop exp(-1/2 (x_i - #m.mu _i)^top #m.Sigma _(i i)^(-1) (x_i - #m.mu _i))
$<eq.gaussian-marginal-moments>

where $X_{-i}$ is the set of all variables except $x_i$, and $#m.Sigma _(i i)$ is the $i^"th"$ diagonal element of the covariance matrix $#m.Sigma = #m.Lambda$. The marginal posterior distribution is then a Gaussian with mean $#m.mu _i$ and variance $#m.Sigma _(i i)$. Furthermore, $#m.mu _i$ is the $i^"th"$ element of the joint mean vector $#m.mu$, as in @eq.gaussian-joint.

With the understanding from #numref(<s.b.gbp.map-inference>) and #numref(<s.b.gbp.marginal-inference>); inference in #acr("GBP") ends up being a matter of solving the linear system of equations @eq.gaussian-linear-system@gbp-visual-introduction:

$
  A x = b #sym.arrow.r.double #m.Lambda #m.mu = #m.eta
$<eq.gaussian-linear-system>

Where #inference.MAP solves for the mean, #m.mu, and #inference.marginal finds the covariance, #m.Sigma, by solving for the block diagonal of $#m.Lambda^(-1)$, and indirectly also the mean, #m.mu.

=== Variable Update <s.b.gbp.variable-update>

The variable belief update happens by taking the product of incoming messages from neighbouring factor nodes, here denoted as $N(i)$, as seen in @eq.gbp-variable-update@gbpplanner@gbp-visual-introduction:

$
  b_i(x_i) = product_(s in N(i)) m_(f_s #ra x_i)
$<eq.gbp-variable-update>

Writing out the Gaussian message in #gaussian.canonical becomes @eq.gbp-message-canonical@gbpplanner@gbp-visual-introduction:

$
  m = cal(N)^(-1) (x; mu, Lambda) prop exp(-1/2 x^top Lambda x + eta^top x)
$<eq.gbp-message-canonical>

Fortunately, as the messages are stored in #gaussian.canonical, the product in @eq.gbp-variable-update is the same as summing up the information vectors and precision matrices, as seen in @eq.gbp-variable-update-canonical@gbpplanner@gbp-visual-introduction:

$
  eta_b_i = sum_(s in N(i)) eta_(f_s #ra x_i)
  #h(1em)"and"#h(1em)
  Lambda_b_i = sum_(s in N(i)) Lambda_(f_s #ra x_i)
$<eq.gbp-variable-update-canonical>

=== Variable to Factor Message <s.b.gbp.variable-to-factor>

The variable to factor message passing is described in @eq.gbp-variable-to-factor@gbp-visual-introduction, where the message is the product of the incoming messages from all neighbouring factors $f_j$ except the factor $f_i$ itself, same as described in @eq-mp-variable-to-factor@gbpplanner:

$
  m_(x_i #ra f_j) = product_(s in N(i) \\ j) m_(f_s #ra x_i)
$<eq.gbp-variable-to-factor>

Again in this case, the message is sent in the #gaussian.canonical, and as such the outgoing messages can simply be computed by summing up the information vectors and precision matrices, as seen in @eq.gbp-variable-to-factor-canonical@gbp-visual-introduction:

$
  eta_(x_i #ra f_j) = sum_(s in N(i) \\ j) eta_(f_s #ra x_i)
  #h(1em)"and"#h(1em)
  Lambda_(x_i #ra f_j) = sum_(s in N(i) \\ j) Lambda_(f_s #ra x_i)
$<eq.gbp-variable-to-factor-canonical>

=== Factor Update <s.b.gbp.factor-update>

// #jonas[I have written this section out, which was a todo box before, please read.]
This step is not written out in @gbpplanner, as it is not a step like the rest, where state is updated. Instead, the updating of a factor here describes the mathematical steps taken before passing messages to neighbouring variables. Writing this step out also represents the developed software@repo more directly. The following steps take place:
#[
  #set enum(numbering: box-enum.with(prefix: "Step ", color: theme.mauve))
  // #set par(first-line-indent: 0em)
  + *Aggregate Messages:* Messages from neighbouring variables are aggregated into a single message, as seen in @eq.gbp-factor-to-variable@gbpplanner@gbp-visual-introduction:

    $
      m_(f_i #ra x_j) = product_(s in N(j) \\ i) m_(x_s #ra f_i)
    $<eq.gbp-factor-to-variable>

  + *Update Linearisation Point:* As the factor has received new messages from neighbouring variables, the linearisation point is updated to the new mean, $mu_f$.

  + *Measurement & Jacobian:* The measurement residual is computed as the difference between the measurement at the initial linearisation point, $h(#m.Xb _0)$, and the current measurement, $h(#m.Xb _n)$, see @eq.factor-measurement@gbp-visual-introduction:

    $
      h_i = h(#m.Xb _0) - h(#m.Xb _n)
    $<eq.factor-measurement>

    Where $X_0$ is the configuration at $t_0$, and $X_n$ is the configuration at the current timestep $t_n$.

  + *Factor Potential Update:* The factor potential is updated by computing the precision matrix and information vector of the factor potential, as seen in @eq.factor-potential@gbp-visual-introduction:

    $
      #m.Lambda _p = jacobian^top #m.Lambda _M jacobian
      #h(1em)"and"#h(1em)
      #m.eta _p = jacobian^top #m.Lambda _M (jacobian l_p + m_r)
    $<eq.factor-potential>

    Where $#m.Lambda _p$ and $#m.eta _p$ denotes the measurement precision matrix and information vector of the factor potential, respectively. Lastly, $#m.Lambda _M$ is the measurement precision matrix.
]

=== Factor to Variable Message <s.b.gbp.factor-to-variable>

As the factor has been updated, it is now possible to pass messages to neighbouring variables. The messages to each neighbouring variables has to be marginalised with respect to all other variables, that is; to find the message to variable $x_i$, margininalise out its own contribution to the aggregated message. This is best described through an example, see @ex.factor-to-variable@gbp-visual-introduction.

#example(caption: [Factor Message Marginalisation])[
  Consider a factor $f$ connected to 3 variables; $x_1,x_2,x_3$, and we want to compute the message to be passed to variable $x_1$. Write the factor out as a Gaussian distribution, see @eq.ex.factor@gbp-visual-introduction:

  $
    f(mat(x_1,x_2,x_3)) = cal(N)^(-1) (mat(x_1,x_2,x_3); eta_f, Lambda_f)
  $<eq.ex.factor>

  Here, the two Gaussian parameters $eta_f$ and $Lambda_f$ can be expanded to see the individual contributions from each variable, as seen in @eq.ex.factor-canonical@gbp-visual-introduction:

  $
    eta_f = mat(eta_(f"1"); eta_(f"2"); eta_(f"3"))
    #h(1em)"and"#h(1em)
    Lambda_f = mat(
      Lambda_(f"11"), Lambda_(f"12"), Lambda_(f"13");
      Lambda_(f"21"), Lambda_(f"22"), Lambda_(f"23");
      Lambda_(f"31"), Lambda_(f"32"), Lambda_(f"33")
    )
  $<eq.ex.factor-canonical>

  As described earlier, first step is to compute the message that will passed to $x_1$, which is the product of the incoming messages from $x_2$ and $x_3$, as seen in @eq.ex.product-adjacent, as we are in the #gaussian.canonical. This is a summation, and yields the Gaussian, $cal(N) (eta_f^prime, Lambda_f^prime)$@gbp-visual-introduction:

  $
    eta_f^prime = mat(eta_(f"1"); eta_(f"2") + eta_(x_2 #ra f); eta_(f"3") + eta_(x_3 #ra f))
    #h(1em)"and"#h(1em)
    Lambda_f^prime = mat(
      Lambda_(f"11"), Lambda_(f"12"), Lambda_(f"13");
      Lambda_(f"21"), Lambda_(f"22") + Lambda_(x_2 #ra f), Lambda_(f"23");
      Lambda_(f"31"), Lambda_(f"32"), Lambda_(f"33") + Lambda_(x_3 #ra f)
    )
  $<eq.ex.product-adjacent>

  Now as we are passing a message to $x_1$, we have to marginalise out all other variables, $x_2$ and $x_3$. This is done by the marginalisation equations given by @marginalisation for Gaussians in #gaussian.canonical. See @eq.ex.marginalisation-setup and @eq.ex.marginalisation for the joint  distribution over variables $a$ and $b$@gbp-visual-introduction@marginalisation.

  $
    eta = mat(eta_a; eta_b)
    #h(1em)"and"#h(1em)
    Lambda = mat(
      Lambda_(a a), Lambda_(a b);
      Lambda_(b a), Lambda_(b b)
    )
  $<eq.ex.marginalisation-setup>

  $
    eta_(M a) = eta_a + Lambda_(a b) Lambda_(b b)^(-1) eta_b
    #h(1em)"and"#h(1em)
    Lambda_(a a) = Lambda_(M a) - Lambda_(a b) Lambda_(b b)^(-1) Lambda_(b a)
  $<eq.ex.marginalisation>

  Now to marginalise, perform the two steps:
    #set enum(numbering: box-enum.with(prefix: "Step ", color: theme.peach))
  + *Reorder the vector $eta_f^prime$ and the matrix $Lambda_f^prime$ to bring the contribution from the recipient $x_1$ to the top.* \
    _In our case no reordering is to be done, as $x_1$ is already at the top._

  + *Recognise the subblocks $a$ and $b$ from @eq.ex.marginalisation-setup and @eq.ex.marginalisation.* \
    _In our case $a = x_1$ and $b = mat(x_2, x_3)$._
]<ex.factor-to-variable>

As such, each neighbouring variable receives an updated message from the factor, in effect imposing the factor's constraints on the variables.

== Non-Linearities <s.b.non-linearities>

Non-linear factors can exist, however, to understand the impact, let's first look at linear factors. A factor is usually modeled with data $#m.d$. Equation @eq.gaussian-factor@gbp-visual-introduction shows how this is written:

$
  #m.d &tilde.op h(#m.Xb _n)) + epsilon.alt
$<eq.gaussian-factor>

Here, $h(#m.Xb _n)$) represents the measurement of the state of the subset of neighbouring variables, $#m.Xb _n$, to the factor, and the error term $epsilon.alt tilde.op cal(N) (0, #text(theme.mauve, $Sigma_n$))$ is white noise. Thus, finding the residual $r$ between the measurement and the model, as seen in @eq.gaussian-residual@gbp-visual-introduction, propagates the Gaussian nature of the model to the residual.

$
  r = #m.d - h(#m.Xb _n)) tilde.op cal(N) (0, #text(theme.mauve, $Sigma_n$))
$<eq.gaussian-residual>

With this, looking at @f.gaussian-models, the #gaussian.moments can be rewritten with the measurement, $h(#m.Xb)$, and the model $#m.d$@eq.gaussian-energy@gbp-visual-introduction:

$
  E(#m.Xb _n) = 1/2 h(#m.Xb _n) - #m.d)^top #text(theme.mauve, $Sigma_n$)^(-1) h(#m.Xb _n) - #m.d)
$<eq.gaussian-energy>

In case of a linear factor, the measurement function is quadratic and can be written as $h(#m.Xb _n) = jacobian #m.Xb _n + c$, where $jacobian$ is the Jacobian. This allows us to rearrange the energy onto #gaussian.canonical @eq.gaussian-canonical@gbp-visual-introduction:

$
  E(#m.Xb _n) = 1/2 #m.Xb _n^top #text(theme.yellow, $Lambda$) #m.Xb _n - #text(theme.yellow, $eta$)^top #m.Xb _n#h(1em), "where" #text(theme.yellow, $eta$) = jacobian^top #text(theme.mauve, $Sigma_n$)^(-1) (#m.d - c) "and" #text(theme.yellow, $Lambda$) = jacobian^top #text(theme.mauve, $Sigma_n$)^(-1) jacobian
$<eq.gaussian-canonical>

However, in case of a non-linearity in $h$, the energy is also not quadratic in $#m.Xb _n$, which in turn means that the factor is not Gaussian. To achieve a Gaussian distribution for the factor in this case, it is necessary to linearise around a current estimate $#m.Xb _0$, which is from here called the #factor.lp. This linearisation takes place by @eq.factor-linearisation@gbp-visual-introduction:

$
  h(#m.Xb _n) = h(#m.Xb _0) + jacobian(#m.Xb _n - #m.Xb _0)
$<eq.factor-linearisation>

As such, we end up with a linearised factor on the form @eq.linearised-factor@gbp-visual-introduction, which ends up with a Gaussian approximation of the true non-linear distribution:

$
  c = h(#m.Xb _n) - jacobian #m.Xb _n
$<eq.linearised-factor>

The underlying potential non-linearities of factors is exemplified in @ex.non-linearities, and visualised in @fig.non-linearities.

#example(caption: [Factor Linearisation])[
  Consider a 2D world, where a robot exists alongside a landmark. As seen in @fig.non-linearities, the robot is located at $r_0$, and the landmark at $l_0$. This figure visualises the contour plot for the factor $f(r_0, l)$, assuming the robot's true position is known to be $r_0$ without uncertainties. The true non-linear belief of the landmark's position is visualised as a grey#sgr2 contour plot. The factor measurement function $h(r,l)$ in @eq.non-linear-measurement@gbp-visual-introduction is non-linear.

  $
    h(r,l) = mat(abs(r - l); arctan((l_y - r_y) / (l_x - r_x)))
  $<eq.non-linear-measurement>

  As such, the factor is linearised around $(r_0, l_0)$, which is shown as red contours#sr in @fig.non-linearities. In the @fig.non-linearities#text(accent, "A"), the measurement noise model corresponds to covariance $#m.SA$, and in @fig.non-linearities#text(accent, "B") the covariance is $#m.SB$, see @eq.non-linear-covariances@gbp-visual-introduction.

  $
    #m.SA = mat(0.25, 0; 0, 0.25)
    #h(1em)"and"#h(1em)
    #m.SB = mat(0.25, 0; 0, 1.0)
  $<eq.non-linear-covariances>

  #figure(
    {
      set text(theme.text)
      grid(
        columns: 2,
        std-block(
          fill: theme.lavender.lighten(75%)
        )[
          #image("../../figures/plots/ellipses-narrow.svg")
          A: With covariance $#m.SA$
        ],
        std-block(
          fill: theme.lavender.lighten(75%)
        )[
          #image("../../figures/plots/ellipses-wide.svg")
          B: With covariance $#m.SB$
        ]
      )
    },
    caption: [A non-linear factor is visualised, where the measurement function $h(#m.Xb _n)$ is non-linear. The linearisation point $l_0$#st is shown, and the robot's position#sg. The non-linear true distribution is visualised as a grey#sr contour plot underneath the linearised gaussian distribution#sgr2 on top.@gbp-visual-introduction],
  )<fig.non-linearities>

  The purpose of this example is to make it clear, that the accuracy of a gaussian factor is dependent on the linearity of the measurement function, $h$. As in @fig.non-linearities#text(accent, "A"), the measurement model is reasonably smooth, and the linearised gaussian factor is a fairly good approximation, however, in @fig.non-linearities#text(accent, "B") highlights how a larger variance can lead to a very poor approximation, even without straying too far from the linearisation point.
]<ex.non-linearities>
