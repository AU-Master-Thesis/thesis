#import "../../lib.typ": *
== Factor Graphs

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

A factor graph is a bipartite graph, where the nodes are divided into two disjoint sets; variables and factors. The edges between nodes each connect one from each set, and represent the dependencies between the variables and factors. Mathematically the factor graph represents the factorisation of a joint function, where the factors are functions that determine the probability of the variables.@loeliger_introduction_2004@alevizos_factor_2012

#example[
  An example factor graph is visualised in @fig-factor-graph. Writing out the visualised factor graph produces:

  $
    P(v_1,v_2,v_3,v_4) = 1/Z f_1(v_1,v_2,v_3) f_2(v_3,v_4) f_3(v_3,v_4) f_4(v_4)
  $

  #figure(
    image("../../figures/out/factor-graph.svg", width: 60%),
    caption: [A factor graph is a bipartite graph, where the nodes are divided into two sets; variables and factors. Variables are represented as red circles#sr, and factors as blue squares#sl. The edges between the nodes represent the dependencies between the variables and factors.],
  )<fig-factor-graph>
]

The factor graph is a generalisation of constraint graphs, and enables efficient computation of marginal distributions through the sum-product algorithm.@loeliger_introduction_2004@alevizos_factor_2012

#todo[What is the sum-product algorithm?]
#todo[More general factor graph theory]

// Below is factor graph notions in terms of the multi-agent robotic system we have developed
In @fig-robot-factor-graph two joint factor graphs are visualised. The first variables in each factor graph $v_1$#note.wording[#variable(theme.green, $v_1$)], represent the location of a green#sg and purple#sp robot respectively. Each robot has a corresponding factorgraph, where the figure shows how the two factor graphs are connected with interrobot factors $f_i$ when they are close enough to each other. Variables $v_2, dots, v_n$ represent the future predicted#note.wording[planned] states of the robot respectively at timesteps $t_2, dots, t_n$, where $t_1$ is the current time.

#figure(
  image("../../figures/out/robot-factor-graph.svg"),
  caption: [Here shown are two factor graphs, one for a green#sg robot, and one for a purple#sp robot. In this specific case the two robots are close to each other, and perfectly aligned. At the top, the planning horizon is shown in red#sr, #text(theme.maroon, $n$) times-steps into the future, #text(theme.maroon, ${t_1, t_2, dots, t_n}$). Variables are visualised as circles, and factors as squares.],
)<fig-robot-factor-graph>

=== The Sum-Product Algorithm <background-sum-product-algorithm>

// Sum-Product Algorithm @theodoridis_machine_2020

=== Asynchronoous Message Passing <background-asynchronous-message-passing>

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