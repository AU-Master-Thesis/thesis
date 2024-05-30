#import "../../../lib/mod.typ": *

#pagebreak()


#let variable-timesteps(lookahead_horizon, lookahead_multiple) = {
  let n = 1 + (0.5 * (-1.0 + calc.sqrt(1.0 + 8.0 * lookahead_horizon / lookahead_multiple)))
  let n = calc.floor(n)

  let timesteps = ()

  for i in range(lookahead_multiple * (n + 1)) {
    let section = int(i / lookahead_multiple)
    let f = (i - section * lookahead_multiple + lookahead_multiple / 2 * section) * (section + 1);

    if f >= lookahead_horizon {
      timesteps.push(lookahead_horizon)
      break
    }

    timesteps.push(f)
  }

  timesteps

}

=== Variable Structure <s.variable-structure>

Each variable is a separate structure holding internal state such as its belief expressed in the Gaussian moments form, aswell as a hashmap that buffers messages from connected factors. When the factorgraph is constructed, the variables are initialized such that the mean of their initial belief have them placed along the line segment from the robots spawn point to its first waypoint. Variables are not spaced evenly in time, but are instead spaced apart in a monotonically increasing order. The algorithm for this is parameterized over $l_h in RR_+$ and $l_m in ZZ_+$ called _lookahead horizon_ and  _lookahead multiple_ respectively.

- #[$l_h$ is the time horizon in seconds that the last variable also referred to as the _horizon_ variable should be placed at. It is a dependant quantity that is computed from $r_R$, $|v_("target")|$ and $t_(K-1)$ as shown in @equ.time-between-current-and-next-state@equ.lookahead-horizon.

  $ t_(0,1) = r_R / 2 |v_("target")|^(-1) $ <equ.time-between-current-and-next-state>

  $t_(0,1)$ is the time between the current state $v_0$ and the next state $v_(1)$. Is is defined as such to constrain the robot from moving more than half its radius $r_R "/" 2$ in a timestep $Delta_t$.

  $ l_h = t_(K-1) / t_(0,1) $ <equ.lookahead-horizon>

  $l_h$ is the ratio between $t_(K-1)$ and $t_(0,1)$ and represent the granularity/discretization of the timespan at which variables can be placed in.
]

- $l_m$ groups variables together into chunks with even relative distance in time. After each $l_m$ group of variables the size between each increases by $1$.

@f.variable-timesteps illustrates how the algorithm place the variables, and how the parameters influence the output. One thing of note is that $l_m - 1 = l_h$ achieves an even spacing of all variables. \
A thorough argument for this method of placing variables is not provided in the paper nor the source code. However, a plausible argument for this approach can be made based on the theory presented earlier in @s.b.factor-graphs. Firstly, variables close to the current state are placed with little distance between each other to ensure high maneuverability and fidelity. This arrangement ensures that the immediate future, has a higher influence on the trajectory optimized for. Secondly, variables spaced further into the future are less dense to prevent them from overwhelming the influence of near-term variables. This spacing accounts for the increasing uncertainty and broader maneuvers required as the robot plans further ahead. As the figure shows $l_m$ can be modified to control how closely variables are grouped. $l_m = 1$ gives an strictly monotonically increasing sequence. As $l_m$ increases the number of variables increases. The bottom sequence with $l_m = 3$ strikes a balance between certain immediate control and broader future planning.

// The middle sequence with lm=19lm​=19 demonstrates this, with larger gaps indicating less frequent updates for distant future states. This approach captures uncertainty without excessive computational load.
//
// The bottom sequence, with lm=3lm​=3, strikes a balance between detailed immediate control and broader future planning. This method ensures that the robot can coordinate path deviations and interactions with other robots using inter-robot factors effectively, without the burden of overly dense variable placement.
//
// This method ensures a practical trade-off between precision in the immediate future and computational efficiency for long-term planning, making it a robust choice for dynamic and uncertain environments. Despite the lack of a thorough explanation, the chosen approach appears to balance immediate responsiveness with long-term strategy effectively.
//
//
//
//
// which critically influences the trajectory, is modeled with greater precision. As illustrated in the top sequence with lm=1lm​=1, closely packed variables allow for detailed control and quick adjustments, accommodating sudden changes or obstacles effectively.
//
//
//
//
// A comment near the function generating the sequence explains that it was chosen on the simple basis that it seemed good enough. #todo[ref] \
//
// HERE
//

// An argument for why that is could go as follows. First Variables are placed like this to ensure that has more maneouvebility and fidelity close in time to the current state such that it is primarily the immediate future that affects the trajectory derived at. Secondly variables further into the future should not overwhelm the variables closest to the current state, but should represent information uncertainty about broader maneuvers needed in the future such as coordinating path deviations through interrobots factors with other robots.


// #k[
// The authors of the method do not thoroughly explain their choice of variable placement. However, a plausible argument for this approach can be made.
//
// Firstly, variables are placed densely near the current state to ensure high maneuverability and fidelity. This arrangement ensures that the immediate future, which critically influences the trajectory, is modeled with greater precision. As illustrated in the top sequence with lm=1lm​=1, closely packed variables allow for detailed control and quick adjustments, accommodating sudden changes or obstacles effectively.
//
// Secondly, variables spaced further into the future are less dense to prevent them from overwhelming the influence of near-term variables. This spacing accounts for the increasing uncertainty and broader maneuvers required as the robot plans further ahead. The middle sequence with lm=19lm​=19 demonstrates this, with larger gaps indicating less frequent updates for distant future states. This approach captures uncertainty without excessive computational load.
//
// The bottom sequence, with lm=3lm​=3, strikes a balance between detailed immediate control and broader future planning. This method ensures that the robot can coordinate path deviations and interactions with other robots using inter-robot factors effectively, without the burden of overly dense variable placement.
//
// This method ensures a practical trade-off between precision in the immediate future and computational efficiency for long-term planning, making it a robust choice for dynamic and uncertain environments. Despite the lack of a thorough explanation, the chosen approach appears to balance immediate responsiveness with long-term strategy effectively.
//
// ]



// Likewise this formulation does not make it possible to change the number of variables $|V|$ independent of the parameters $r_R, |v_("target")|, t_(K-1)$ and $l_m$.


// #k[argue why this way of placing the variables are a good way of doing it.]
//
// #line(length: 100%, stroke: 1em + red)
//



// maximum possible number of variables is $l_h$
//
// Meaning that the number of variables are formulated/defined to be a dependent variable on the $r_R$, $|v_max|$ and $t_(K-1)$
//
// $ |V| = 2 $ <equ.number-of-variables>




// spacing should sort of increase exponentially

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

// Variable Timesteps

// The choice was selected as being "good enough"




  // Cap max speed, since it should be <= ROBOT_RADIUS/2.f / TIMESTEP:
  // In one timestep a robot should not move more than half of its radius

#figure(
  std-block(image("../../../figures/out/variable-timesteps.svg")),
  caption: [

  Three different results of the variable placement algorithm from $0$ to $t_(K-1) = 20$ in seconds, with $t_(0,1) = 1s$. The top sequence is generated with $l_m=1$. The middle with $l_m = 19$ and the bottom one with $l_m = 3$

]
) <f.variable-timesteps>

// #k[does $l_m = 1$ give even spacing?]

// #k[describe as an algorithm]

#par(first-line-indent: 0pt)[The Settings Panel @s.m.simulation-tool provide slider widgets to manipulate both $t_(K-1)$ and $l_m$. With this a user of the simulation can quickly experiment with the parameters and find a combination that suit the complexity of the simulated scenario.]




// #kristoffer[
//   Explain how we have added a setting to decouple the number of variables from the velocity and time horizon of the robot.
// ]
