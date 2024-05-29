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


= Variable Timestep Placement <appendix.variable-timestep-placement>

#listing(
```rust
#[derive(Debug)]
struct VariableTimestepPlacementParamsError {
  NLessThan2,
  HorizonNotPositive,
}

impl std::fmt::Display for VariableTimestepPlacementParamsError {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    match self {
      Self::NLessThan2 => write!(f, ""),
      Self::HorizonNotPositive => write!(f, ""),
    }
  }
}

impl std::error::Error for VariableTimestepPlacementParamsError {}

struct VariableTimestepPlacementParams {
  pub (self) n: usize,
  pub (self) horizon: f32,
  pub (self) lookahead_multiple: NonZeroUsize,
}

impl VariableTimestepPlacementParams {
  pub fn new(n: usize, horizon: f32) -> Result<Self, VariableTimestepPlacementParamsError> {
    if n < 2 {
      Err()
    } else if horizon <= 0.0 {
      Err()
    } else {
      Ok(Self {
        n,
        horizon,
        lookahead_multiple: 3.try_into().unwrap()
      })
    }
  }

  pub fn with_lookahead_multiple(self, lookahead_multiple: NonZeroUsize) -> Self {
    self.lookahead_multiple = lookahead_multiple;
    self
  }
}

trait VariableTimestepPlacement {
  // provided method
  fn place(params: VariableTimestepPlacementParams) -> Vec<f32> {
    let mut timesteps = vec![0.0; params.n];
    Self::place_into(params, &mut timesteps);
    assert_eq!(0, timesteps[0]);
    assert_eq!(params.horizon, timesteps[params.n - 1]);
    timesteps
  }

  /// Guarantees:
  /// `params.n == timesteps.len()`
  fn place_into(params: VariableTimestepPlacementParams, timesteps: &mut[f32]);
}
```,
  caption: [`VariableTimestepPlacement` trait used to provide an interface for placing variable nodes between the current variable $v_0$ and the horizon $v_("horizon")$. The ith index in the vector returned by the `VariableTimestepPlacement::place` is interpreted as the time in seconds the variable should be placed into the future, capped at $t_("horizon")$]
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
    [$sigma_d$], [sigma value of Dynamic factor], [$m$],
    [$sigma_p$], [sigma value of Pose factor], [$m$],
    [$sigma_r$], [sigma value of Range factor], [$m$],
    [$sigma_o$], [sigma value of Obstacle factor], [$m$],
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
  &<=>  t = (100 m) / (7.5 m / s) = 13 + 1/3 s
$

= Graphviz Representation of FactorGraphs <appendix.graphviz-representation-of-factorgraphs>

Example of outputs generated by the Graphviz integration.

#let colors = (
  interrobot: rgb("#95C486"),
  dynamic: rgb("#7C9CDC"),
  obstacle: rgb("#D68A90"),
  tracking: rgb("#DC9151")
)

#let factor-node(c, t) = {
  let width = 1.5em
  box(rect(fill: c.lighten(30%), stroke: c, width: width, height: width, outset: 0pt, inset: 0.35em, [#t]), baseline: 0.5em)
}

#let variable-node(content) = {
  box(circle(stroke: theme.overlay0)[
   #set align(center + horizon)
    #content
  ], baseline: 1em)
  // box(circle(radius: width, stroke: theme.overlay0, content), baseline: 0.5em)
}

#{

  let b(content) = block(
    width: 50%,
    content
  )

  set align(center)
  grid(
    align: left,
    columns: 2,
    rows: 3,
    b[#factor-node(colors.interrobot, $f_i$) interrobot factor],
    b[#factor-node(colors.dynamic, $f_d$) dynamic factor],
    b[#factor-node(colors.tracking, $f_t$) tracking factor],
    b[#factor-node(colors.obstacle, $f_o$) obstacle factor] ,
    [#variable-node[$v_n$] variable],
    []
  )
}


// #factor-node(colors.interrobot, $f_i$) \
// #factor-node(colors.dynamic, $f_d$) \
// #factor-node(colors.tracking, $f_t$) \
// #factor-node(colors.obstacle, $f_o$)

// #std-block(image("../figures/img/graphviz-export-single-factorgraph.svg", width: 100%))
#figure(
  std-block(image("../figures/img/graphviz-export-single-factorgraph.png")),
  caption: [
    Graphviz representation of a single factorgraph. Circles are variables where $v_0$ is the current variable at the robots position at time $t$, and $v_13$ is the horizon variable.
  ]
)

#let interrobot-edge(c, n: 3) = {
  box(grid(columns: n, column-gutter: 0.25em, ..range(n).map(_ => line(stroke: c, length: 6pt))), baseline: -0.25em)
}

#figure(
  std-block(image("../figures/img/graphviz-export-multiple-factorgraphs.png")),
  caption: [
  Graphviz representation of multiple factorgraphs. Note the position of the variables does not reflect their actual position in the simulation. Red dashed #interrobot-edge(rgb("#d20f39")) edges repreent interrobot edges, where that are disabled due to the radio being turned of on the robot which owns the factor. Green dashed #interrobot-edge(rgb("#40a02b")) edges are active interrobot edges.
  ]
)

= JSON Schema for exported data <appendix.json-schema-for-exported-data>


#listing(
  [

```json
{
  "scenario": <string>,
  "delta_t": <float>,
  "makespan": <float>,
  "prng_seed": <int>,
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
      "mission": {
        "waypoints": [ [ <float>, <float> ], ... ],
        "started_at": <float>,
        "finished_at": <float> | null,
        "routes": [
          {
            "started_at": <float>,
            "finished_at": <float> | null,
            "waypoints": [ [ <float>, <float> ], ... ]
          },
          ...
        ]
      },
      "planning-strategy": "only-local" | "rtt-star"
      "color": <color>
  },
    "robot2": { ... }
  },
  "config": <config>
}
```
  ],
  caption: [JSON Schema for exported data. `...` denotes one or more repetitions of the the array or object just before it.],
)


#pagebreak()

== Introspection outputs <appendix.introspection-outputs>

#grid(
  rows: 2,
  // rows: (1fr, 1fr, 8fr),
  // figure(
  //   scale(x: 100%, y: 60%, std-block(image("../figures/img/introspection-of-robot-robot-collision.png"))),
  //   caption: [Example output of clicking on an obstacle.]
  // ),

  grid(
  columns: (46.5%, auto),
  // columns: (42.5%, auto),
  figure(
    std-block(image("../figures/img/introspection-of-robot-state.png")),
    caption: [Screenshot of output from clicking on a robot.]
  ),
  grid(
    rows: 2,
    figure(
      std-block(image("../figures/img/introspection-of-variable-state.png")),
      caption: [Screenshot of output of clicking on a variable.]
    ),
    figure(
      std-block(image("../figures/img/introspection-of-variable-state-settings.png")),
      caption: [UI settings used when clicked on variable in the output above.]
    )
  ),

  ),
)

#figure(
  block(
    breakable: false,
    stack(dir: ttb,
      std-block(image("../figures/img/introspection-of-collider-state.png", fit: "contain")),
      v(0.5em),
      std-block(align(left, image("../figures/img/introspection-of-robot-robot-collision.png", fit: "contain"))),
    )
  ),
  caption: [
    Screenshot of output of clicking on an obstacle and robot robot collision residue.
  ]
)

#pagebreak()

== #acr("LDJ") Metric computation <appendix.ldj-metric-computation>


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
  caption: [
  Code used to compute the Log Dimensionless Jerk (LDJ) metric.
  The script can also be found in the accompanying source code@repo under #github("AU-Master-Thesis", "gbp-rs", path: "./scripts/ldj.py")
]
)

#pagebreak()

== Perpendicular Path Deviation Metric Code <appendix.perpendicular-path-deviation-metric-code>

#listing([
  ```py
import collections
import itertools
from dataclasses import dataclass
import numpy as np


def sliding_window(iterable: Iterable, n: int):
    "Collect data into overlapping fixed-length chunks or blocks."
    # sliding_window('ABCDEFG', 4) → ABCD BCDE CDEF DEFG
    iterator = iter(iterable)
    window = collections.deque(itertools.islice(iterator, n - 1), maxlen=n)
    for x in iterator:
        window.append(x)
        yield tuple(window)


@dataclass
class Line:
    a: float
    b: float


def line_from_line_segment(x1: float, y1: float, x2: float, y2: float) -> Line:
    a = (y2 - y1) / (x2 - x1)
    b = y1 - (a * x1)
    return Line(a=a, b=b)


def projection_onto_line(point: np.ndarray, line: Line) -> np.ndarray:
    assert len(point) == 2
    x1, y1 = point
    xp: float = (x1 + line.a * (y1 - line.b)) / (line.a * line.a + 1)
    projection = np.array([xp, line.a * xp + line.b])
    assert len(projection) == 2

    return projection


def closest_projection(point: np.ndarray, lines: list[Line]) -> np.ndarray:
    assert len(point) == 2
    projections = [projection_onto_line(point, line) for line in lines]
    closest_projection = min(projections, key=lambda proj: np.linalg.norm(proj - point))

    return closest_projection


lines: list[Line] = [
  line_from_line_segment(*start, *end) for start, end in sliding_window(waypoints, 2)
]

closest_projections: list[np.ndarray] = [
  closest_projection(point, lines) for point in positions
]

error: float = np.sum(np.linalg.norm(positions - closest_projections, axis=1))
rmse: float = np.sqrt(error / len(positions))
  ```
],
  caption: [
  Code used to compute the Perpendicular Path Deviation Metric.
  The script can also be found in the accompanying source code@repo under #github("AU-Master-Thesis", "gbp-rs", path: "./scripts/perpendicular-path-deviation.py")
]
)


#pagebreak()


// == Perpendicular Path Deviation Metric Code <appendix.perpendicular-path-deviation-metric-code>
== Visualisation Modules <appendix.visualisation-modules>

#k[
  insert screenshots of each visualisation component
]
