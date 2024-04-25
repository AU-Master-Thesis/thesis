#import "../../lib.typ": *
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
// Explaing how the
// - factors are Gaussian distributions
// - measurement or constraint of factor is represented by a measurement function $h$
// - variables are the mean and variance of the Gaussian

// Mathematically, the Hammersley-Clifford Theorom states that any positive joint distribution can be represented as a product of factors,

A factor graph is a bipartite graph, where the nodes are divided into two disjoint sets; variables and factors. The edges between nodes each connect one from each set, and represent the dependencies between the variables and factors. A factor graph represents the factorisation of any positive joint distribution , $p(X)$, as stated by the Hammersley-Clifford Theorom. That is, a product of factors for each clique of variables in the graph, which can be seen in @eq-factor-product@gbpplanner@gbp-visual-introduction@dellaert_factor_2017@loeliger_introduction_2004@alevizos_factor_2012.

$
  p(X) = product_{i} f_i (X_i)
$<eq-factor-product>

Thus interpreting this, the factors are not necessarily in themselves probabilities, but rather the functions that determine the probabilities of the variables.@loeliger_introduction_2004@alevizos_factor_2012 Additionally, it can be useful to present factor graphs as energy-based models@energy-based-models, where, as seen in @eq-factor-energy@gbp-visual-introduction, each factor $f_i$ is associated with an energy $E_i > 0$:@gbp-visual-introduction

$
  f_i(X_i) = exp(-E_i(X_i))
$<eq-factor-energy>

This presentation also gives another way of finding the #acr("MAP") estimate, by finding the state with the lowest energy in the factor graph, see @eq-map-energy@gbp-visual-introduction:

$
  X_"MAP" &= "arg min"_X -log p(X) \
          &= "arg min"_X sum_i E_i(X_i)
$<eq-map-energy>

#example[
  An example factor graph is visualised in @fig-factor-graph, with variables #text(theme.red, ${v_1, dots, v_4}$) and factors #text(theme.lavender, ${f_1, dots, f_4}$). Writing out the visualised factor graph produces:

  $
    p(v_1,v_2,v_3,v_4) = 1/Z#note.wording[Should this be here? `gbp-visual-introduction` doesn't have it] f_1(v_1,v_2,v_3) f_2(v_3,v_4) f_3(v_3,v_4) f_4(v_4)
  $

  #figure(
    image("../../figures/out/factor-graph.svg", width: 60%),
    caption: [A factor graph is a bipartite graph, where the nodes are divided into two sets; variables and factors. Variables are represented as red circles#sr, and factors as blue squares#sl. The edges between the nodes represent the dependencies between the variables and factors.],
  )<fig-factor-graph>
]

The factor graph is a generalisation of constraint graphs, and can represent any join function. Moreover, the factor graph structure enables efficient computation of marginal distributions through the sum-product algorithm.@loeliger_introduction_2004@alevizos_factor_2012 The sum-product algorithm is detailed in @s.b.belief-propagation.

// Below is factor graph notions in terms of the multi-agent robotic system we have developed
In @fig-robot-factor-graph two joint factor graphs are visualised. The first variables in each factor graph $v_1$#note.wording[#variable(theme.green, $v_1$)], represent the location of a green#sg and purple#sp robot respectively. Each robot has a corresponding factorgraph, where the figure shows how the two factor graphs are connected with interrobot factors $f_i$ when they are close enough to each other. Variables $v_2, dots, v_n$ represent the future predicted#note.wording[planned] states of the robot respectively at timesteps $t_2, dots, t_n$, where $t_1$ is the current time.

#figure(
  image("../../figures/out/robot-factor-graph.svg"),
  caption: [Here shown are two factor graphs, one for a green#sg robot, and one for a purple#sp robot. In this specific case the two robots are close to each other, and perfectly aligned. At the top, the planning horizon is shown in red#sr, #text(theme.maroon, $n$) times-steps into the future, #text(theme.maroon, ${t_1, t_2, dots, t_n}$). Variables are visualised as circles, and factors as squares.],
)<fig-robot-factor-graph>

== Belief Propagation <s.b.belief-propagation> // The Sum-Product Algorithm <background-sum-product-algorithm>

// NOTES:
// Sum-Product Algorithm @theodoridis_machine_2020
// The sum-product algorithm is a message passing algorithm used to perform exact inference on factor graphs.
// #acr("BP") is an algorithm for marginal inference, as opposed to exact inference.

// #acr("BP") is carried out by the sum-product algorithm.@robotweb@gbpplanner@gbp-visual-introduction

The process of performing inference#note.wording[] on a factor graph is done by passing messages between the variables and factors. @fig.message-passing visualises the two major steps; #iteration.variable and #iteration.factor, each with two sub-steps; an internal update, and a message passing step.

#gridx(
  columns: (2em, 1fr, 4em, 1fr),
  [], [
    #set enum(numbering: req-enum.with(prefix: "Step ", color: theme.maroon))
    + Variable update
    + Variable to factor message
  ], [], [
    #set enum(start: 3, numbering: req-enum.with(prefix: "Step ", color: theme.lavender))
    + Factor update
    + Factor to variable message
  ]
)

#figure(
  image("../../figures/out/message-passing.svg"),
  caption: [The four steps of propagating messages in a factor graph. Firstly, the variables#sr are internally updated, and new messages are sent to neighbouring factors#sl, who then update internally, sending the updated messaages back to neighbouring variables#sr. \ _Note that this figure shows the #iteration.variable first, however, performing the #iteration.factor first is also a valid, the main idea is simply that they are alternating._],
)<fig.message-passing>

#jens[context for BP and the sum-product algorithm]

In #step.s1 the computation of the marginal distribution of a variable $x_i$ takes place. This is done by finding the product of all messages from neighbouring factors $f_j$ to $x_i$, as seen in  @eq.mp-variable-update@gbpplanner@gbp-visual-introduction@robotweb.

$
  m_(x_i) = product_(s in N(i)) m_(f_s #ra x_i)
$<eq.mp-variable-update>

Secondly, in #step.s2 the variable to factor messages $m_(x_i #ra f_j)$ are computed as described in @eq-mp-variable-to-factor@gbpplanner, which is a product of all messages from neighbouring factors $f_s$ except $f_j$.@gbpplanner@gbp-visual-introduction@robotweb

$
  m_(x_i #ra f_j) = product_(s in N(i) \\ j) m_(f_s #ra x_i)
$<eq-mp-variable-to-factor>

The factor to variable messages $m_(f_j #ra x_i)$ are described in @eq.mp-factor-to-variable@gbpplanner, where the message is the product of the factor $f_j$ and the messages from all neighbouring variables $x_i$ except $x_i$ itself.@gbpplanner@gbp-visual-introduction@robotweb This corresponds to the entire #iteration.factor, i.e. #step.s3 and #step.s4, also shown in @fig.message-passing.
$
  m_(f_j #ra x_i) = sum_(X_j \\ x_i) f_j (X_j) product_(k in N(j) \\ i) m_(x_k #ra f_j)
$<eq.mp-factor-to-variable>

#jens[finish this section]

Originally #acr("BP"), was created for inference in trees, where each message passing iteration is synchronous. This is a simpler environment to guarantee convergence in, and in fact after one synchronous message sweep from root to leafs, exact marginals would be calculated. However, factor graphs, as explained earlier, are not necessarily trees; they can contain cycles, and as such loopy #acr("BP") is required. Loopy #acr("BP"), instead of sweeping messages, applies the message passing steps to each each at every iteration, but still in a synchronous fashion.@gbp-visual-introduction#jens[more citation for loopy BP]

The expansion to loopy graphs is not without its challenges, as the convergence of the algorithm is not guaranteed. As such the problem transform from an exact method to and approximation. This means, that instead of minimising the factor energies through #acr("MAP") directly, loopy #acr("BP") minimises the #acr("KL") divergence between the true distribution and the approximated distribution, which can then be used as a proxy for marginals after satisfactory optimisation.@gbp-visual-introduction

Loopy #acr("BP") is derived via the Bethe free energy, which is a constrained minimisation of an approximation of the #acr("KL") divergence. As the Bethe free energy is non-convex, the algorithm isn't guaranteed to converge, and furthermore, it might converge to local minima in some cases. It has been shown that empirically loppy #acr("BP") is very capable of converging to the true marginals, as long as the graphs aren't highly cyclic#note.wording[too loopy? Is loopy and cyclic the same thing?].@gbp-visual-introduction

== Gaussian Belief Propagation <s.b.gaussian-belief-propagation>

#jens[do this #emoji.face.smile]

== Non-Linearities <s.b.non-linearities>

#jens[and this]

Non-linear factors can exist, however, to understand the impact, let's first look at linear factors. A factor is usually modeled with data $d$. Equation @eq.gaussian-factor@gbp-visual-introduction shows how this is written:

$
  #text(theme.green, $d$) &tilde.op #text(theme.maroon, $m(X_n)$) + epsilon.alt
$<eq.gaussian-factor>

Here, #text(theme.maroon, $m(X_n)$) represents the measurement of the state of the subset of neighbouring variables, $X_n$, to the factor, and the error term $epsilon.alt tilde.op cal(N) (0, #text(theme.mauve, $Sigma_n$))$ is white noise. Thus, finding the residual $r$ between the measurement and the model, as seen in @eq.gaussian-residual@gbp-visual-introduction, reveals propogates the Gaussian nature of the model to the residual.

$
  r = #text(theme.green, $d$) - #text(theme.maroon, $m(X_n)$) tilde.op cal(N) (0, #text(theme.mauve, $Sigma_n$))
$<eq.gaussian-residual>

With this, looking at @f.gaussian-models, the #gaussian.moments can be rewritten with the measurement, $m(x)$, and the model $d$@eq.gaussian-energy@gbp-visual-introduction:

$
  E(X_n) = 1/2 (#text(theme.maroon, $m(X_n)$) - #text(theme.green, $d$))^top #text(theme.mauve, $Sigma_n$)^(-1) (#text(theme.maroon, $m(X_n)$) - #text(theme.green, $d$))
$<eq.gaussian-energy>

#let jacobian = $upright(bold(J))$
In case of a linear factor, the measurement function is quadratic and can be written as $#text(theme.maroon, $m(X_n)$) = jacobian X_n + c$, where $jacobian$ is the jacobian. This allows us to rearrange the energy onto #gaussian.canonical @eq.gaussian-canonical@gbp-visual-introduction:

$
  E(X_n) = 1/2 X_n^top #text(theme.yellow, $Lambda$) X_n - #text(theme.yellow, $eta$)^top X_n#h(1em), "where" #text(theme.yellow, $eta$) = jacobian^top #text(theme.mauve, $Sigma_n$)^(-1) (#text(theme.green, $d$) - c) "and" #text(theme.yellow, $Lambda$) = jacobian^top #text(theme.mauve, $Sigma_n$)^(-1) jacobian
$<eq.gaussian-canonical>

However, in case of a non-linearity in $#text(theme.maroon, $m$)$, the energy is also not quadratic in $X_n$, which in turn means that the factor is not Gaussian. To achieve a Gaussian distribution for the factor in this case, it is necessary to linearise around a current estimate $X_0$, which is from here called the #factor.lp. This linearisation takes place by @eq.factor-linearisation@gbp-visual-introduction:

$
  #text(theme.maroon, $m(X_n)$) = #text(theme.maroon, $m(X_0)$) + jacobian(X_n - X_0)
$<eq.factor-linearisation>

As such, we end up with a linearised factor on the form @eq.linearised-factor@gbp-visual-introduction, which ends up with a Gaussian approximation of the true non-linear distribution:

$
  c = #text(theme.maroon, $m(X_n)$) - jacobian X_n
$<eq.linearised-factor>

#example[
  #jens[make this example with similar figure as to @gbp-visual-introduction]
]
