#import "../../../lib/mod.typ": *

=== Simulation Tool <s.m.simulation-tool>

#todo[update all sim screenshots]

#jonas[A lot of the subsections here are 50% done. As in they explain the context and such but not details. Let us know if what is here is enough and it would be too much to go deeper, or if you're missing something.]

// Hypothesis 4:
// Extensive tooling will create a great environment for others to understand the software
// and extend it further. Furthermore, such tooling will make it easier to reproduce and
// engage with the developed solution software.

As described in hypothesis #study.H-1.box, this thesis poses the idea the extensive tooling will help facilitate reproduction of the results and further development of the software. The developed simulation tool is a key component in this regard. The simulation tool presents a #acr("GUI") to interact with the live simulation. The tool is built with the Bevy@bevyengine game engine, which allows for rapid prototyping and development of interactive applications. The tool is designed to be used by researchers and developers to understand the underlying theory of factor graphs and their application in multi-agent planning scenarios. The tool is equipped with several features to facilitate this goal, where the most important features are described in sections #numref(<s.m.s4.settings>)-#numref(<s.m.s4.export-formats>). The tool is open-source and available on the thesis' #gbp-rs()@repo. The simulation tool is shown in @f.m.simulation-tool, where the #panel.viewport and #panel.settings are visible. The user also has access to a #panel.bindings, by pressing `H`, which shows the keybindings for the tool and enables the user to change them. Lastly, a floating #panel.metrics can be opened with `D`, which shows live metrics and diagnostics for the current simulation.

#figure(
  // std-block(todo[screenshot of settings panel, or at least a part of it]),
  std-block[
    #set text(theme.text)
    #show table.cell : it => {
      if it.x == 0 {
        set text(theme.lavender)
        it
      }
      else {
        set text(theme.maroon)
        it
      }
    }

    #image("../../../figures/img/tool-settings-latte.png")
    #v(-2em)
    #table(
      columns: (1fr, 36%),
      row-gutter: 0em,
      column-gutter: -1em,
      stroke: none,
      layout(size => {
        $underbrace(#h(size.width))$
      }),
      layout(size => {
        $underbrace(#h(size.width))$
      }),
      panel.viewport, panel.settings
    )
  ],
  caption: [Screenshot of the simulation tool with the #panel.settings open. On the left hand side, the #panel.viewport is shown. The settings panel is scrollable, hence only a part of it is is visible here.],
)<f.m.simulation-tool>

==== Live Configuration <s.m.s4.settings>

Most of the configurable settings described in #nameref(<s.m.configuration>, "Configuration") section can be changed live during the simulation. Pressing `L` in the simulation tool will expose a side-panel with all the settings, see #panel.settings in @f.m.simulation-tool; hereunder, the mutable configuration settings, e.g. amount of internal and external #acr("GBP") iterations to compute, communication failure rate and radius, and which visualisations to draw. A screenshot of the side-panel is shown in @f.m.simulation-tool, which includes all these and more useful options.
Some of the sections in the settings panel are off-screen in @f.m.simulation-tool, but they are accessible by scrolling down. The significant#note.wording[different word?] sections are described in the following sections.

#jens[Live configuration editing allows for rapid testing]

==== Hot Loading Scenarios <s.m.s4.hot-loading>

Do not confuse this for hot reloading, but the simulation tool allows for hot loading of scenarios. This means that the simulation scenarios that are described later in #nameref(<s.r.scenarios>, "Scenarios") can be selected through a drop-down at any time during the simulation. This will reset the simulation and load the new scenario, loading the corresponding `configuration.toml`, `environment.yaml`, and `formation.yaml`. The dropdown menu contains all scenarios listed under @s.r.scenarios along with other miscelleanous scenarios.

// The dropdown menu can be seen in @f.m.simulation-tool-scenario-dropdown.

// #figure(
//   // std-block(todo[screenshot of dropdown menu]),
//   std-block(image("../../../figures/img/tool-settings-scenarios-latte.png", width: 50%)),
//   caption: [The scenario dropdown in the simulation tool.],
// )<f.m.simulation-tool-scenario-dropdown>

#kristoffer[
  Simulation loader
]

==== Time Control <s.m.s4.time-control>

The simulation tool allows for control of the simulated time. In @f.m.simulation-tool-time-control the time controls are shown under the #text(theme.lavender, "Simulation") section in the settings panel. Here the user can see the simulation time, and the frequency at which the fixed #acr("GBP") simulation steps are computed. Additionally, the user has access to a pause/play button to stop and start the simulation, and a manual step button to step through the simulation $n$ fixed timesteps at a time. As a default $n=1$. The user can only use the manual stepping when the simulation is paused.

#figure(
  // std-block(todo[screenshot of time control]),
  std-block(width: 60%, height: auto, image("../../../figures/img/tool-settings-simulation-latte.png")),
  caption: [The time control section in the simulation tool. From left to right, top to bottom: Reload current scenario, scenario dropdown selctor, simulation time, simulation frequency, simulation speed, manual step, play/pause.],
)<f.m.simulation-tool-time-control>

==== Visualisation <s.m.s4.visualisation>

// robots                             = true
// communication-graph                = false
// predicted-trajectories             = true
// waypoints                          = true
// uncertainty                        = false
// paths                              = true
// generated-map                      = true
// sdf                                = true
// communication-radius               = false
// obstacle-factors                   = true
// tracking                           = false
// interrobot-factors                 = false
// interrobot-factors-safety-distance = false
// robot-colliders                    = false
// environment-colliders              = true
// robot-robot-collisions             = true
// robot-environment-collisions       = true

The simulation tool supports visualisations of most aspects of the simulation. All possible visualisations are listed and described in @table.simulation-visualisations. The visualisations can be toggled on and off in the settings panel, as shown in @f.m.simulation-tool. The visualisations are updated in real-time as the simulation progresses.


#let edges = (
  on: box(line(length: 10pt, stroke: theme.green), height: 0.25em),
  off: box(line(length: 10pt, stroke: theme.red), height: 0.25em),
)

#figure(
  tablec(
    columns: 2,
    align: left,
    header: table.header(
      [Settings], [Description]
    ),
    [Robots], table.vline(), [A large sphere at the estimated position of each robot.],
    [Communication graph], [A graph that shows an edge between all currently communicating robots. Each edge is colored dependent on the robots radio state. If the antenna is active then half of the edge from the robot to the center is green#sg, and red#sr if turned off. For three robots $R_a, R_b, R_c$, this could look like

    #align(center, [$R_a$ #edges.on #edges.off $R_b$ #edges.off #edges.off $R_c$])
  ],
    [Predicted trajectories], [All of each robot's factor graph variables, visualised as small spheres with a line between.],
    [Waypoints], [A small sphere at each waypoint for each robot.],
    [Uncertainty], [A 2D ellipse for each variable in each robot's factor graph, visualising the covariance of the internal Gaussian belief.],
    [Paths], [Lines tracing out each robot's driven path.],
    [Generated map], [A 3D representation of the map generated from the environment configuration.],
    [Signed distance field], [The 2D #acr("SDF") image used for collision detection. White#swatch(white) where the environment is free, black#swatch(black) where it's occupied.],
    [Communication radius], [A circle around each robot representing the communication radius. The circle is teal#stl when the radio is active, and red#sr when it's inactive.],
    [Obstacle factors], [A line from each variable to the linearisation point of their respective obstacle factors, and a circle in this point. Both the line and circle is colours according to the factor's measurement on a green#sg to yellow#sy to red#sr gradient; #box(inset: (x: 2pt), outset: (y: 2pt), radius: 3pt, height: 0.5em, width: 10em, fill: gradient.linear(theme.green, theme.yellow, theme.red)).],
    [Tracking], [The measurement of the tracking factors and the line segments between each waypoint, that are being measured.],
    [Interrobot factors], [Two lines from each variable in one robot to each variable in another robot if they are currently communicating. The line is green#sg if the communication is active in that direction, and grey#sgr3 if it's inactive.],
    [Interrobot factors safety distance], [A circle around each variable, visualisation the internally used safety distance for the interrobot factors.],
    [Robot colliders], [A sphere in red#sr around each robot representing the collision radius.],
    [Environment colliders], [An outline in red#sr around each obstacle in the environment, that collision are being detected against.],
    [Robot-robot collisions], [An #acr("AABB") intersection, visualising each robot to robot collision and its magnitude. Shown as semi-transparent cuboids in red#sr.],
    [Robot-environment collisions], [An #acr("AABB") intersection, visualising each robot to environment collision and its magnitude. Shown as semi-transparent cuboids in red#sr.],
  ),
  caption: [
  #todo[write caption]
]
) <table.simulation-visualisations>

#jens[Something about making debugging easier and most importantly understanding of the underlying theory]

==== Viewport <s.m.s4.viewport>

The viewport is where the action happens. This is what the user is represented with when the simulation tool is initially loaded. All visualisations described in the previous section #numref(<s.m.s4.visualisation>) are drawn in the viewport. Technically, the viewport is the user's eyes in the simulated environment, which happens through a camera in a 3D scene. The camera is a perspective camera, which is initially placed directly above the center of the environment, looking at it from a top-down perspective. The user can directly interact with the viewport, both through the keybindings, but also the mouse. The user can choose to stay in this top-down, pseudo-2D perspective, which gives a great overview, or switch the camera to orbital controls, which allows the user to rotate around the environment and zoom in and out. The #panel.viewport is shown in @f.m.simulation-tool. Through the viewport, the user gets a live update of the #acr("GBP") mathematical simulation happening under the surface.

Additionally to providing a visual representation of the underlying mathematics, the user can use the interface to extract information. Most objects in the viewport are clickable, and when clicked, relevant information and measurements are printed out into the console. This is both a useful tool for rapid development and debugging, but also to aid in understanding the computations and theory in the background.

==== Introspection Tools <s.m.s4.debugging-tools>

All entities in the simuliation with a mesh can be clicked on to introspect their current state. This functionality aids in discoverabiliy when trying out different parameters and environments. When clicked data structured as `YAML` will be outputted to stdout with colored keys for easy navigation, and can be viewed in the attached console:

- *Robot* All data related to the robot is printed out. Such as its position, linear velocity, active connections, number of collisions, messages set and received and the structure of its factorgraph.
- *Variable* When clicked the variables belief will be printed, together with a list of all its connected factors. Each factor provides a custom representation of its internal state through the `Display` trait. As variables can have a lot of neighbours it might not of interest to inspect the state of all factors, due to visual clutter. As such the #panel.settings and `config.toml` provide a section of toggles to precisely choose what state to include in the output. This was found to be useful when developing the tracking factor extension.

- *Obstacle* All obstacles keep a log over which robots that have collided with it. A list of the robots that have collided with this obstacle is outputted, together with the #acr("AABB") of their collision.

Example outputs of each of these are shown in @appendix.introspection-outputs.

==== Export Formats <s.m.s4.export-formats>

To work with the simulated environments *qualitatively* and *quantatatively* and get more visual intuition about the state of the system the simulator is equipped with three features to extract data from it.

#[
  #v(1em)
  #set par(first-line-indent: 0em)
  *Qualitative:*
  - *Screenshot* of the simulation. The UI exposes a button, and a keybinding, default `Ctrl+S`, to take a screenshot of the viewport.

  - *Graphviz* representation of all factorgraphs. Graphviz is a common format and tool to visualise various graph structures. It's based on a textual format that the Graphviz compiler `dot` uses to generate images from@graphviz. The `FactorGraph` structure can be introspected to query it for all its nodes an external connections. This information is then transpiled into a `factorgraphs.dot` file written to disk. If `dot` is installed on the system, it is used to compile the transpiled representation into an #acr("PNG") image. That can be viewed in a traditional image viewer#footnote([This was invaluable during the development to visually assure that construction of the factorgraphs was correct.]). See @appendix.graphviz-representation-of-factorgraphs for examples of the generated output.

  *Quantitative:*
  #kristoffer[Is this as it should be with metrics and such?]
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
]
