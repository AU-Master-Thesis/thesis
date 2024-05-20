#import "../lib/mod.typ": *

// == Appendix <s.appendix>

= Internal External Iteration Schedules <appendix.iteration-schedules>

#listing(
```rust
#[derive(Clone, Copy PartialEq, Eq)]
pub struct GbpScheduleAtIteration {
    pub internal: bool,
    pub external: bool,
}

#[derive(Clone, Copy)]
pub struct GbpScheduleParams {
    pub internal: u8,
    pub external: u8,
}

pub trait GbpScheduleIterator: std::iter::Iterator<Item = GbpScheduleAtIteration> {}

pub trait GbpSchedule {
    fn schedule(params: GbpScheduleParams) -> impl GbpScheduleIterator;
}
```,
  caption: [The schedule for the internal and external message passing iterations modelled by the trait `GbpSchedule`. Every implementor must implement a static method called `schedule(params: GbpScheduleParams)` that returns an iterator of `GbpScheduleAtIteration` structs. The boolean fields `.internal` and `.external` are interpreted such that `true` means that a message pass of that kind should be executed this iteration step.]
)


= Reproduction Experiment Parameters <appendix.reproduction-experiment-parameters>

#figure(
  tablec(
    columns: (1fr, 3fr, 1fr),
    align: (center, left, center),
    header: table.header([*Parameter*], [*Description*], [*Unit* / *Domain*]),
    [$C_("radius")$], [Radius of the circle that the robots spawn in circle scenarios like @s.r.scenarios.circle], [$m$],
    [$r_R$], [Robot radius], [$m$],
    [$r_C$], [Robot communication radius], [$m$],
    [$|v_0|$], [Initial speed], [$m"/"s$],
    [$N_r$], [Number of robots], [$NN_1$],
    [$s$], [prng seed], [$NN_0$],
    [$delta_t$], [Time passed between each simulation step], [$s$],
    [$M_i$], [Internal #acr("GBP") message passing iterations], [$NN_0$],
    [$M_r$], [External inter-robot #acr("GBP") messages], [$NN_0$],
    [$gamma$], [probability for the communication module to be toggled on/off], [$percent$],
    [$t_K-1$], [Extend of time horizon. The time it should take for the current variable to reach the horizon variable], [$s$],
    [$|V|$], [Number of variables in each factorgraph], [$NN_1 \\ {1}$],
    [$sigma_d$], [sigma value of Dynamic factor], [#todo[...]],
    [$sigma_p$], [sigma value of Pose factor], [#todo[...]],
    [$sigma_r$], [sigma value of Range factor], [#todo[...]],
    [$sigma_o$], [sigma value of Obstacle factor], [#todo[...]],
    [$d_r$], [Inter-robot safety distance. When two variables connected by a interrobot factor are within this distance, the factor will send factor messages to alternate the course of both robot's path.], [$C_("radius")$],
    [$Q_("in")$], [Rate at which robots enter the central section in the Junction scenario (see @s.r.scenarios.junction)], [$"robots""/"s$],
    [$Q_("out")$], [Rate at which robots exit the central section in the Junction scenario (see @s.r.scenarios.junction)], [$"robots""/"s$],
  ),
  caption: [Experiment parameters for all reproduction scenarios. See @s.r.scenarios for an writeup of the scenarios.]
) <t.appendix.reproduction-experiment-parameters>


= Interpretation of parameters <appendix.interpretation-of-parameters>

#set par(first-line-indent: 0em)

- $|v_(0)| = v_i = 15 m"/"s$

- $|v_("final")| = v_f = 0 m"/"s$

- $j(t) = (d a(t))/(d t) = 0 m"/"s^3$

- $C_("radius") = 50 m$

- $d = 2 C_("radius") = 100 m$

Use the following equations for velocity and displacement under constant acceleration@essential-university-physics:


$ v_f = v_i + a t $ <equ.kinematic-velocity>

$ d = v_i t + 1/2 a t^2 $ <equ.kinematic-distance>

Isolate $a$ in @equ.kinematic-velocity

#let a = $-15/t m / s$
$ 0 m/s = 15 m/s + a t  <=> a = #a $

Substituting $a$ into @equ.kinematic-distance to get:

$
  100 m &= 15 m/s  t + 1/2 (#a) t^2 \

  &= 15 m/s t - 7.5 m/s t \
  &= 7.5 m / s t \
  &<=>  t = (100 m) / (7.5 m / s) = 13 1/3 s
$

= Graphviz Representation of FactorGraphs <appendix.graphviz-representation-of-factorgraphs>

#kristoffer[Insert one or two images of the compiled graphviz output]

= JSON Schema for exported data <appendix.json-schema-for-exported-data>


#kristoffer[update with new velocity timestamp info]

#listing(
  [

```json
{
  "name": <string>,
  "delta_t": <float>,
  "makespan": <float>,
  "gpp": {
    "iterations": {
      "internal": <int>,
      "external": <int>
    },
  },
  "robots": {
    "robot1": {
      "radius": <float>,
      "positions": [ [ <float>, <float> ], ... ],
      "velocities": [ [ <float>, <float> ], ... ],
      "messages": {
        "sent": { "internal": <int>, "external": <int> },
        "received": { "internal": <int>, "external": <int> }
      },
      "collisions": { "robots": <int>, "environment": <int> },
      "route": {
        "started_at": <float>,
        "finished_at": <float> | null,
        "duration": <float>,
        "waypoints": [ [ <float>, <float> ], ... ]
      }
  },
    "robot2": { ... }
  }
}
```
  ],
  caption: [JSON Schema for exported data. `...` denotes one or more repetitions of the the array or object just before it.],
)


== #acr("LDJ") Metric computation <appendix.ldj-metric-computation>

#kristoffer[
  Insert the code for how the metric is computed here. When we are sure about how to compute it
]

#listing(
  [```py
import numpy as np
from scipy.integrate import simpson

def ldj(velocities: np.ndarray, timesteps: np.ndarray) -> float:
    """ Calculate the Log Dimensionless Jerk (LDJ) metric. """
    assert len(velocities) > 0
    assert velocities.shape == (len(velocities), 2)
    assert len(timesteps) == len(velocities)
    assert np.all(np.diff(timesteps) > 0)
    assert timesteps.shape == (len(timesteps),)

    t_start: float = timesteps[0]
    t_final: float = timesteps[-1]
    assert t_start < t_final

    dt: float = np.mean(np.diff(timesteps))

    vx = velocities[:, 0]
    vy = velocities[:, 1]
    # Estimate acceleration components
    ax = np.gradient(vx, dt)
    ay = np.gradient(vy, dt)

    # Estimate jerk components
    jx = np.gradient(ax, dt)
    jy = np.gradient(ay, dt)

    # Square of the jerk magnitude
    squared_jerk = jx**2 + jy**2

    time_samples = np.linspace(t_start, t_final, len(velocities))

    # Numerical integration of the squared jerk using Simpson's rule
    integral_squared_jerk = simpson(squared_jerk, x=time_samples)

    # LDJ calculation
    v_max = np.max(np.sqrt(vx**2 + vy**2))  # Max speed (magnitude of velocity vector)

    ldj = -np.log((t_final - t_start)**3 / v_max**2 * integral_squared_jerk)

    return ldj

  ```],
  caption: [The script can also be found in the accompanying source code@repo under #github("AU-Master-Thesis", "gbp-rs", path: "./scripts/ldj.py")]
)


#todo[insert code for other non-trivial metrics, like perpendicular distance]
