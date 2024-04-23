#import "../../lib.typ": *

== Probabilistic Inference <background-probabilistic-inference>

To contextualise factor graph inference, the underlying probabilistic inference theory is introduced. The goal of probabilistic inference is to estimate the probability distribution of a set of unknown variables, $X$, given some observed or known quantities, $D$. This is done by combining prior knowledge with $D$, to infer the most likely distribution of the variables.@gbp-visual-introduction

#example[
  // Everyday example describing how meteorological forecasts are made
  An everyday example of probabilistic inference is in the field of meteorology. Meteorologists use prior knowledge of weather patterns ($D$), combined with observed data to infer the most likely weather forecast for the upcoming days ($X$).
]

// Explain bayesian inference
Baye's rule is the foundation of probabilistic inference, and is used to update the probability distribution of a set of variables, $X$, given some observed data, $D$. The rule is defined as in @eq-bayes-theorom@gbp-visual-introduction:

$
  p(X|D) = (p(D|X)p(X)) / (p(D))
$<eq-bayes-theorom>

This posterior distribution describes our belief of $X$, after observing $D$, which can then be used for decision making about possible future states.@gbp-visual-introduction Furthermore, when we have the posterior, properties about $X$ can be computed;

#set enum(numbering: req-enum.with(prefix: "Property ", color: theme.green))
+ The most likely state of $X$, the #acr("MAP") estimate $X_"MAP"$, is the state with the highest probability in the posterior distribution. See @eq-map-estimate@gbp-visual-introduction:

  $
    X_"MAP" = "argmax"_X p(X|D)
  $<eq-map-estimate>

+ The marginal posteriors, summarising our beliefs of individual variables in $X$, can be computed by marginalising the posterior distribution, see @eq-marginal-posterior@gbp-visual-introduction:

  $
    p(X_i|D) = sum_(X \\ x_i) p(X|D)
  $<eq-marginal-posterior>

// The most common methods for probabilistic inference are exact inference and approximate inference.

== Factor Graphs <background-factor-graphs>

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

The factor graph is a generalisation of constraint graphs, and can represent any join function. Moreover, the factor graph structure enables efficient computation of marginal distributions through the sum-product algorithm.@loeliger_introduction_2004@alevizos_factor_2012 The sum-product algorithm is detailed in @background-belief-propagation.

// Below is factor graph notions in terms of the multi-agent robotic system we have developed
In @fig-robot-factor-graph two joint factor graphs are visualised. The first variables in each factor graph $v_1$#note.wording[#variable(theme.green, $v_1$)], represent the location of a green#sg and purple#sp robot respectively. Each robot has a corresponding factorgraph, where the figure shows how the two factor graphs are connected with interrobot factors $f_i$ when they are close enough to each other. Variables $v_2, dots, v_n$ represent the future predicted#note.wording[planned] states of the robot respectively at timesteps $t_2, dots, t_n$, where $t_1$ is the current time.

#figure(
  image("../../figures/out/robot-factor-graph.svg"),
  caption: [Here shown are two factor graphs, one for a green#sg robot, and one for a purple#sp robot. In this specific case the two robots are close to each other, and perfectly aligned. At the top, the planning horizon is shown in red#sr, #text(theme.maroon, $n$) times-steps into the future, #text(theme.maroon, ${t_1, t_2, dots, t_n}$). Variables are visualised as circles, and factors as squares.],
)<fig-robot-factor-graph>

== Belief Propagation <background-belief-propagation> // The Sum-Product Algorithm <background-sum-product-algorithm>

// NOTES:
// Sum-Product Algorithm @theodoridis_machine_2020
// The sum-product algorithm is a message passing algorithm used to perform exact inference on factor graphs. 
#acr("BP") is an algorithm for marginal inference, as opposed to exact inference. 

@robotweb@gbpplanner@gbp-visual-introduction

#jens[finish this section]

=== Asynchronous Message Passing <background-asynchronous-message-passing>

The process of updating#note.wording[inference] on a factor graph is done by passing messages between the variables and factors. @fig-message-passing visualises the two major steps; #boxed(color: theme.maroon)[Variable Iteration] and #boxed(color: theme.lavender)[Factor Iteration], each with two sub-steps; an internal update, and a message passing step.

#gridx(
  columns: (1em, 1fr),
  [], [
    #set enum(numbering: req-enum.with(prefix: "Step ", color: theme.maroon))
    + Variable update
    + Variable to factor message
    #set enum(start: 3, numbering: req-enum.with(prefix: "Step ", color: theme.lavender))
    + Factor update
    + Factor to variable message
  ]
)

#figure(
  image("../../figures/out/message-passing.svg"),
  caption: [The four steps of propagating messages in a factor graph. Firstly, the variables#sr are internally updated, and new messages are sent to neighbouring factors#sl, who then update internally, sending the updated messaages back to neighbouring variables#sr. \ _Note that this figure shows the #boxed(color: theme.maroon)[Variable Iteration] first, however, performing the #boxed(color: theme.lavender)[Factor Iteration] first is also a valid, the main idea is simply that they are alternating._],
)<fig-message-passing>
