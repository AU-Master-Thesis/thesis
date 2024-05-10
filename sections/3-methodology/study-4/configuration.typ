#import "../../../lib/mod.typ": *

=== Configuration <s.m.s4.configuration>

To make the developed software more flexible and easier to use, several configuration formats have been developed. The main configuration file is written in `TOML`, and is used to define all the general parameters for the simulation, visualisation, and #acr("UI").

The most important sections of the main configuration file are: `GBP`, `Robot`, `Simulation`, `Visualisation`. The smaller sections are described in the code documentation itself.@repo
#set enum(numbering: box-enum.with(prefix: "Section "))
+ `GBP:` Outlines all initial factor standard deviations, $sigma$, used in the #acr("GBP") message passing, alogn with the iteration schedule to use and how many of _internal_ vs _external_ iterations to run.
+ `Robot:` Defines each robot's properties, such as size, target speed, communication radius and failure rate, and degrees of freedom. Additionally, some properties for the structure of the underlying factor are in this section; i.e. the planning-horizon, whether to use symmetric interrobot factors, and scaling of the safety distance between robots.
+ `Simulation:` Contains the parameters for the simulation itself, such as the maximum simulation time, the #acr("RNG") seed, and the fixed time-step frequency to run the #acr("GBP") algorithm at. More are described in @repo.
+ `Visualisation:` Contains the parameters for the visual elements. This includes which properties to draw to the screen like communication radius, interrobot connections, planning horizon, waypoints, etc. Furthermore, some scaling factors, i.e. for the variable uncertainties, to make them visible on the screen, are defined here. Again, more are described in @repo.

#todo[talk about design of different config format design, especially `formation` and `environment`

show examples of them, and how they allow for flexibly and declaratively define new simulation scenarios

  ```yaml
  formations:
  - repeat-every:
      secs: 8
      nanos: 0
    delay:
      secs: 2
      nanos: 0
    robots: 1
    initial-position:
      shape: !line-segment
      - x: 0.45
        y: 0.0
      - x: 0.55
        y: 0.0
      placement-strategy: !random
        attempts: 1000
    waypoints:
    - shape: !line-segment
      - x: 0.45
        y: 1.25
      - x: 0.55
        y: 1.25
      projection-strategy: identity
  ```
]
