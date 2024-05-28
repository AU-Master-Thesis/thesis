#import "../../../lib/mod.typ": *
=== Algorithm <s.m.algorithm>

// This section should explain the GBP inference algorithm as it has been implemented in the simulation tool.

// 1. Fixed update schedule
// 2. Chained systems
// 3. Manual stepping and pausing

// Introduce the Robot Mission concept?
#[
  #show regex("\b(UpdatePrior|CurrentlyConnected|Connect|Disconnect|InternalGBP|ExternalGBP)\b") : set text(theme.mauve, font: "JetBrainsMono NF")

  As explained in the background section #nameref(<s.b.ecs>, "Entity Component System"), an #acr("ECS") architecture has been used as the foundation for #acr("MAGICS") through the Bevy Engine@bevyengine. The #acr("GBP") inference process has been implemented as a series of 7 systems that are executed in a fixed update schedule. This schedule is one of the default schedules provided by Bevy with a configurable frequency#footnote[This happens in the #acr("MAGICS") source code in the #crates.gbpplanner-rs crate at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/simulation_loader.rs#L564", "src/simulation_loader.rs:564")], which is also exposed to #acr("MAGICS") through the `simulation` table in `config.toml`#footnote[Example at #repo(org: "AU-Master-Thesis", repo: "gbp-rs") at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/config/simulations/Intersection/config.toml#L79", "config/simulations/Intersection/config.toml:79")] file. These 7 systems are listed here and marked #boxed[*GBP-X*].

  #[
    #set enum(numbering: box-enum.with(prefix: "GBP-"))
    #grid(
      columns: (1fr, 1fr),
      [
        + `update_robot_neighbours`
        + `delete_interrobot_factors`
        + `create_interrobot_factors`
        + `update_failed_comms`
      ],
      [
        #set enum(start: 5)
        + `iterate_gbp`
        + `update_prior_of_horizon_state`
        + `update_prior_of_current_state`
      ],
    )
  ]

  The algorithm is written out in @a.m.algorithm, where `CurrentlyConnected` is a way to retrieve which robots are currently set as being connected to a specific robot, $R_i$. Before the main loop, find which robots are within communication distance at the current timestep, $N(R_i)$. Then in the main loop while the simulation is _running_, create an interrobot factor between all robots within communication distance if it doesn't already exist with `Connect`, and delete the interrobot factor if the robot is no longer within communication distance with `Disconnect`. After this, the internal and external #acr("GBP") iterations are run with `InternalGBP` and `ExternalGBP`, respectively.

  #algorithm(
    caption: [GBP For Robot $R_i$@gbpplanner]
  )[
    #let comment(content) = text(theme.overlay2, content)
    #show regex("\b(UpdatePrior|CurrentlyConnected|Connect|Disconnect|InternalGBP|ExternalGBP)\b") : set text(size: 0.85em)
    // #show regex("--(.*?)\b") : set text(theme.crust, font: "JetBrainsMono NF", size: 0.85em)
    #show regex("(while|for|do|end)") : set text(weight: "bold")
    // #set par(first-line-indent: 0em)
    #let ind() = h(2em)

    *Input:* $R_i$ \ \

    #comment[Retrieve the robots that were previously set to be connected to $R_i$] \
    $C(R_i) #la "CurrentlyConnected"(R_i)$ \ \

    $"UpdatePrior"(#m.x _0, delta_t)$ \
    $"UpdatePrior"(#m.x _(K-1), delta_t)$ \ \

    $N(R_i) #la {R_j | norm(R_i - R_j) < r_C}$ \ \

    while _running_ do \
    #ind()for $R_j in N(R_i) \\ C(R_i)$ do \
    #ind()#ind()$"Connect"(R_i, R_j)$ \
    #ind()end \
    #ind()for $R_j in C(R_i) \\ N(R_i)$ do \
    #ind()#ind()$"Disconnect"(R_i, R_j)$ \
    #ind()end \
    #ind()$"InternalGBP"(M_I)$ \
    #ind()$"ExternalGBP"(M_E)$ \
    #ind()end \
    end
  ]<a.m.algorithm>

  Following is an explanation of the systems, and their responsibilities, along with which part of the original #gbpplanner implementation they correspond to. Furthermore, each system is related to @a.m.algorithm when relevant:

  #let space = v(0.5em)
  #set par(first-line-indent: 0em)
  #set enum(numbering: box-enum.with(prefix: "GBP-"))
  + `update_robot_neighbours`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L1247", "src/planner/robot.rs:1247")] utilises the #acr("ECS") to mutably query for all entities that have a `RobotConnections` component, and then consequently update them with all robots within communication range.
    #space
    *Parity* with `Simulator::calculateRobotNeighbours` in #gbpplanner. Corresponds to the setting the internal data of `RobotConnection` to that of $N(R_i)$.

  + `delete_interrobot_factors`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L1271", "src/planner/robot.rs:1271")] removes all interrobot factors from the factor graph that are no longer relevant due to the updated robot connections.
    #space
    *Parity* with half of the responsibility of `Robot::updateInterrobotFactors` in #gbpplanner. This corresponds to the `Disconnect` part of the algorithm.

  + `create_interrobot_factors`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L1326", "src/planner/robot.rs:1326")] creates new interrobot factors for all robot connections that are not already represented in the factor graph.
    #space
    *Parity:* with the other half of the responsibility of `Robot::updateInterrobot``Factors` in #gbpplanner. This corresponds to the `Connect` part of the algorithm.

  + `update_failed_comms`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L1478", "src/planner/robot.rs:1478")] updates the communication status of all robots, based on the configurable parameter `communication_failure_rate` under the `robot``.communication` table in `config.toml`.
    #space
    *Parity* with `Simulator::setCommsFailure` in #gbpplanner. This doesn't have a correlary in @a.m.algorithm.

  + `iterate_gbp`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L1654", "src/planner/robot.rs:1654")] iterates the #acr("GBP") algorithm for all robots in the simulation. That is, it has the responsibilitity for the 4 inference steps; _variable update, variable to factor message passing, factor update, and factor to variable message passing_.
    #space
    *Parity* with `Simulator::iterateGBP` in #gbpplanner. This corresponds to the `InternalGBP` and `ExternalGBP` part of the algorithm.

  + `update_prior_of_horizon_state`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L2042", "src/planner/robot.rs:2042")] updates the prior of the horizon state for all robots in the simulation. This is the pose factor anchoring earlier mentioned in @s.m.factors.pose-factor.
    #space
    *Parity* with `Robot::updateHorizon` in #gbpplanner.

  + `update_prior_of_current_state`#footnote[Found in crate #crates.gbpplanner-rs at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/8960686facb7d38c0259141e5b22346c7d745271/crates/gbpplanner-rs/src/planner/robot.rs#L2174", "src/planner/robot.rs:2174")] updates the prior of the current state for all robots in the simulation. Again, this is where the effect of the pose factor anchoring takes place.
    #space
    *Parity* with `Robot::updateCurrent` in #gbpplanner.
]

#let r = (
  A: text(theme.lavender, weight: "bold", "A"),
  B: text(theme.mauve, weight: "bold", "B")
)

Through these steps the lifecycle of the interrobot factors has been allured to. This lifecycle is visualised in @f.interrobot-lifecycle, where two robots #r.A and #r.B approach each other. When they are within communication range, interrobot factors are created. The messaging happening through these factors is the communication that would happen wirelessly in a real-world implementation. Furthermore, when one of the robots' radio fails, the interrobot factors that are maintained by that robot are simply deactivated instead of removed. This has been done as an optimisation, instead of deallocating and reallocating. Finally, when the robots are no longer within communication range, the interrobot factors are deallocated.

#figure(
  block(breakable: false,
    include "interrobot-lifecycle.typ",
  ),
  caption: [
    #let comms = {
      let l1 = place(dy: -0.35em, line(length: 1em, stroke: (thickness: 2pt, paint: theme.teal, dash: "dashed", cap: "round")))
      let l2 = place(dy: -0.35em, line(length: 1em, stroke: (thickness: 2pt, paint: theme.surface0, dash: "dashed", cap: "round")))
      box(inset: (x: 2pt), outset: (y: 2pt), l1 + l2 + h(1.6em))
    }
    Interrobot factor, $f_i$, lifecycle. On A) the two robots, #r.A and #r.B, are approaching each other, but not within communication range#comms. On B) both robots are withing communication range, and interrobot factors are created symetrically between #r.A and #r.B. On C) and D) one of the two robots' radio has failed, resulting in the corresponding interrobot factors being inactive. On E) the robots are no longer within communication range, and the interrobot factors are removed.
  ]
)<f.interrobot-lifecycle>

==== Simulation Loader <s.m.simulation-loader>
#kristoffer[About the ability to load multiple simulations, and the underlying folder-structure. Probably should be somewhere else?]

==== Robot Mission <s.m.robot-mission>
#jens[Maybe this should be in the Global Planning section]
