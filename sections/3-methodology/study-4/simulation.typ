#import "../../../lib/mod.typ": *

=== Simulation Tool <s.m.s4.simulation-tool>

#jens[Talk about the Bevy simulation tool and interactivity]

==== Live Configuration <s.m.s4.settings>

#jens[Live configuration editing allows for rapid testing]

==== Hot Loading Scenarios <s.m.s4.hot-loading>

#kristoffer[
  Simulation loader
]

==== Time Control <s.m.s4.time-control>

#todo[
  Controlling time
  + Pause and play
  + Speed control
  + Manual simulation stepping
]

==== Visualisation <s.m.s4.visualisation>

#jens[Something about making debugging easier and most importantly understanding of the underlying theory]

==== Viewport <s.m.s4.viewport>

#todo[
  Viewport provides
  + Visualisation
  + 2D and 3D interaction
  + Inspect elements
]

==== Export Formats <s.m.s4.export-formats>

To work with the simulated environments quantatatively and get more visual intuition about the state of the system the simulator is equipped with three features to extract data from it:

- Screenshot of the simulation. The UI exposes a button to take a screenshot of the viewport.

- Graphviz representation of all factorgraphs. Graphviz is a common format and tool to visualise various graph structures. It's based on a textual format that the Graphviz compiler `dot` uses to generate images from@graphviz. The `FactorGraph` structure can be introspected to query it for all its nodes an external connections. This information is then transpiled into a `factorgraphs.dot` then written to disk. If `dot` is installed on the system, it is used to compile the transpiled representation into an PNG image. That can be viewed in a traditional image viewer#footnote([This was invaluable during the development to visually assure that construction of the factorgraphs was correct.]). See @appendix.graphviz-representation-of-factorgraphs for examples of the generated output.

- Historical data aswell as parameters of each robot in the running scenario. To make it easy to compare the effects of different parameters across different environments data is recorded for each robot.
  - A count of every message sent and received during message passing is recorded, further labelled if the message was sent across an internal or an external factorgraph edge.
  - The number of collisions a robot has had with other robots and environment obstacles.
  - The position and linear velocity across $delta_t$ seconds is sampled and recorded with an interval of $20 H z$.
  - A description of the route a robot took. Containing the list of waypoints it has visited. When the robot started its route. And if it has finished its route. How long it took.
The data is automatically exported when the scenario has finished i.e. all robots have finished their route. Alternatively the data can be exported from the settings UI by pressing the "metrics" button in the "Export" section. See @appendix.json-schema-for-exported-data for a typed schema of the entire #acr("JSON") object exported.
// super::tracking::PositionTracker::new(1000, Duration::from_millis(50)),
// super::tracking::VelocityTracker::new(1000, Duration::from_millis(50)),

// #set enum(numbering: box-enum.with(prefix: "Section "))
// 1. Graphviz DOT
