#import "../../../lib/mod.typ": *
=== Variable Structure <s.variable-structure>

- Mention that the pose factor is a special case that is embedded in the variable structure, for simplicity

- maintains two sets of ids, one for any robot within communication radius, and one for any robot connected with.

- Fixed number of variable settings
- Trait

Variable Timesteps

#figure(
  image("../../../figures/out/variable-timesteps.svg"),
  caption: [Variable timesteps, #kristoffer[explain figure, and review design, use same variable names as rest of document]]
) <f.variable-timesteps>

#kristoffer[
  Explain how we have added a setting to decouple the number of variables from the velocity and time horizon of the robot.
]
