#import "../../../lib/mod.typ": *

#pagebreak()

=== Variable Structure <s.variable-structure>

Each variable is a separate structure holding internal state such as its belief expressed in the Gaussian moments form, aswell as a hashmap that buffers messages from connected factors. When the factorgraph is constructed, the variables are initialized such that the mean of their initial belief have them placed along the line segment from the robots spawn point to its first waypoint. Variables are not spaced evenly in time, but are instead spaced apart in a monotonically increasing order. The algorithm for this is parameterized over $l_h in RR_+$ and $l_m in ZZ_+$ called _lookahead horizon_ and  _lookahead multiple_ respectively.

- $l_h$ ...

$ t_(0,1) = r_R / 2 |v_("max")|^(-1) $ <equ.time-between-current-and-next-state>

$ l_h = t_(K-1) / t_(0,1) $ <equ.lookahead-horizon>

- $l_m$ groups variables together into chunks with even distance in time. @f.variable-timesteps illustrates how the algorithm place the variables, and how the parameters influence the output.


Meaning that the number of variables are formulated/defined to be a dependent variable on the $r_R$, $|v_max|$ and $t_(K-1)$

$ |V| = 2 $ <equ.number-of-variables>


  // T0 = ROBOT_RADIUS / 2.f /
  //      MAX_SPEED; // Time between current state and next state of planned path



// eg. variables are in groups of size lookahead_multiple.
// the spacing within a group increases by one each time (1 for the first
// group, 2 for the second ...) Seems convoluted, but the reasoning was:
//      the first variable should always be at 1 timestep from the current
//      state (0). the first few variables should be close together in time
//      the variables should all be at integer timesteps, but the spacing
//      should sort of increase exponentially.


  // T0 = ROBOT_RADIUS / 2.f /
  //      MAX_SPEED; // Time between current state and next state of planned path

// - The first and last variable are special in that they are anchored. and has a different number of connected factors.

// - maintains two sets of ids, one for any robot within communication radius, and one for any robot connected with.

// - Fixed number of variable settings

Variable Timesteps

The choice was selected as being "good enough"




  // Cap max speed, since it should be <= ROBOT_RADIUS/2.f / TIMESTEP:
  // In one timestep a robot should not move more than half of its radius

#figure(
  std-block(image("../../../figures/out/variable-timesteps.svg")),
  caption: [

  Placement of variables in time from $0s$ to $t_(K-1)s$.

  Variable timesteps,

  #kristoffer[explain figure, and review design, use same variable names as rest of document]]
) <f.variable-timesteps>

#k[does $l_m = 1$ give even spacing?]

#k[argue why this way of placing the variables are a good way of doing it.]

#k[describe as an algorithm]


#par(first-line-indent: 0pt)[The Settings Panel provide slider widgets to manipulate both $t_(K-1)$ and $l_m$. With this a user of the simulation can quickly experiment with the parameters and find a combination that suit the complexity of the simulated scenario.]




// #kristoffer[
//   Explain how we have added a setting to decouple the number of variables from the velocity and time horizon of the robot.
// ]
