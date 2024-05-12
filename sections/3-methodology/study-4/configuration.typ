#import "../../../lib/mod.typ": *

=== Configuration <s.m.s4.configuration>

To make the developed software more flexible and easier to use, several configuration formats have been developed. The main configuration file, `configuration.toml`, uses `TOML`, and is used to define all the general parameters for the simulation, visualisation, and #acr("UI"). The most important sections of the main configuration file are: `GBP`, `Robot`, `Simulation`, `Visualisation`. The smaller sections are described in the code documentation itself.@repo
#set enum(numbering: box-enum.with(prefix: "Section "))
+ `GBP:` Outlines all initial factor standard deviations, $sigma$, used in the #acr("GBP") message passing, alogn with the iteration schedule to use and how many of _internal_ vs _external_ iterations to run.
+ `Robot:` Defines each robot's properties, such as size, target speed, communication radius and failure rate, and degrees of freedom. Additionally, some properties for the structure of the underlying factor are in this section; i.e. the planning-horizon, whether to use symmetric interrobot factors, and scaling of the safety distance between robots.
+ `Simulation:` Contains the parameters for the simulation itself, such as the maximum simulation time, the #acr("RNG") seed, and the fixed time-step frequency to run the #acr("GBP") algorithm at. More are described in @repo.
+ `Visualisation:` Contains the parameters for the visual elements. This includes which properties to draw to the screen like communication radius, interrobot connections, planning horizon, waypoints, etc. Furthermore, some scaling factors, i.e. for the variable uncertainties, to make them visible on the screen, are defined here. Again, more are described in @repo.

==== Environment Configuration <s.m.s4.configuration.environment>
A datastructure for describing the static environment has been developed, and includes two main parts; the overall environment, and the option to specifiy several placeable shapes.

#let unicodes = (
  ([─], [U+2500]),
  ([│], [U+2502]),
  ([┌], [U+250C]),
  ([┐], [U+2510]),
  ([└], [U+2514]),
  ([┘], [U+2518]),
  ([├], [U+251C]),
  ([┤], [U+2524]),
  ([┬], [U+252C]),
  ([┴], [U+2534]),
  ([┼], [U+253C]),
  ([], []),
  ([╴], [U+2574]),
  ([╵], [U+2575]),
  ([╶], [U+2576]),
  ([╷], [U+2577]),
)

#let unicode-fig = [
  #v(1.5em)
  #figure(
    tablec(
      columns: 4,
      header: table.header(
        [Character], [Unicode], [Character], [Unicode]
      ),
      ..unicodes.flatten()
    ),
    caption: [Supported Unicode characters and their \ codes for environment generation.]
  )<t.unicode-list>
]

#let b = [
  ===== The Main Environment

  This section of the configuration file is a matrix of strings. Each character in the matrix represents a tile in the environment. The supported characters are listed in @t.unicode-list. The environment is generated from this matrix, where each character is a aquare tile, with a configurable side-length, and the coloured-in parts of the characters are the free paths and the rest are walls. The path-widht is configurable as a percentage of the tile side-length.
]

#grid(
  columns: 2,
  column-gutter: 1em,
  b,
  unicode-fig,
)
#v(-0.5em)
The environment shown in @f.m.maze-env is built from the character matrix, in @f.m.maze-env#text(accent, "A"). Even though each character is taller than it is wide when written out in most fonts, the map-generation code produces one _square *tile*_ for each character. This makes up for the seeming descrepency in aspect ratio between the character grid in @f.m.maze-env#text(accent, "A"), and the actual environment in @f.m.maze-env#text(accent, "B").

The resulting grid of _tiles_ in @f.m.maze-env#text(accent, "B") is, 5$times$8, where a 2$times$1 segment is highlighted#sg. In @f.m.maze-env#text(accent, "C") the highlighted section is shown bigger, where, in red#sr, the resulting #acr("AABB") colliders are shown. These colliders are generated on a per-tile basis, which means that the there are seams between the tiles, where the colliders meet. One could argue that these seams could be elliminated to optimise computational efficiency, as less intersection tests would have to be made in the #acr("RRT*") algorithm.

#figure(
  {
    set par(justify: false)
    set text(theme.text)
    grid(
      columns: (auto, 8em, 2.4125fr, 1fr, auto),
      [],
      std-block[
        #set par(leading: 0.25em)
        #set text(size: 14pt)
        #let sp = 6.375em
        #let sp-top = 3.75em
        #v(sp-top)
        ```
        ┌─┼─┬─┐┌
        ┼─┘┌┼┬┼┘
        ┴┬─┴┼┘│
        ┌┴┐┌┼─┴┬
        ├─┴┘└──┘
        ```
        #v(sp - sp-top)
        #set text(size: 10pt)
        A: Character Matrix
      ],
      std-block[
        #image("../../../figures/out/maze-env.svg")
        #v(0.5em)
        B: Generated Environment Tiles
      ],
      std-block[
        #image("../../../figures/out/maze-env-crop.svg")
        #v(0.5em)
        C: Highlighted Tiles
      ],
      [],
    )
  },
  kind: image,
  supplement: "Figure",
  caption: [An example of a maze-like environment.],
)<f.m.maze-env>

// The environment is generated from this matrix, where each character is a tile, and the environment is a grid of tiles. The environment is then used to generate the colliders for the robots to avoid, and the visual representation of the environment.

#let param-fig = [
  #figure(
    {
      tablec(
        columns: (auto, 1fr, auto),
        align: (left, left, left),
        header: table.header(
          [Shape], [Parameters], [Symbols]
        ),
        [Circle], [radius], $r$,
        [Rectangle], [height, width], $h,w$,
        [Regular polygon], [side-length, number of sides], $s,n$,
        [Triangle], [base-length, height, mid-point], $b,h,m$,
      )
    },
    caption: [Supported shapes for the environment generation.],
  )<t.environment-shapes>
]

#let b = [
  Another section in the environment configuration is the `obstacles` list. This is a list of shapes that are completely configurable within each tile. That is, the shapes can be placed anywhere within the tile, and have any size.#h(0.155em) The#h(0.155em) map-generator#h(0.155em) supports#h(0.155em) the
]

#grid(
  columns: (3fr, 4fr),
  column-gutter: 1em,
  b,
  param-fig,
)
#v(-0.5em)
shapes listed in @t.environment-shapes. The list in @t.environment-shapes also details all configurable parameters for each shape. Furthermore, which tile to place the shape in is given as a tile-$x$ and $y$ coordinate, to index which tile to place the obstacle in, along with a within-tile 2D translation. Important to note is that the parameters for the shapes are given in the local coordinate system of the tile, and as scalable percentage values of the tile side-length. As such, the placed obstacles are scaled along with the tile size, which produces a consistent environment, regardless of the size of the tiles. This way it's the tile-size that acts as a global scale. Another approach would be to have absolute coordinates for all these parameters, however, this is a more frictionfull approach, as understanding which tile you're attempting to place an obstacle inside will be harder to understand, along with the obstacles placement in relation to each other. Basically, this approach splits the global coordinate into a grid of local coordinates, which are easier to keep track of when a user is designing the environment.


==== Formation Configuration <s.m.s4.configuration.formation>
The formation configuration is used to define how the robots are spawned in the environment. A great deal of care has gone into making this a highly flexible and declarative way to define new ways to spawn robots, and define their waypoints. The formation configuration is a list of formations, where each formation is a set of parameters for how to spawn the robots, and how to layout their waypoints.

Formations are described with the concept of _ditribution shapes_. These shapes are an abstract way of representing dynamically placed points, but within some constraints. Say the shape is a line from $(0,0)$ to $(1,0)$, and we want this line to desribe how to place 5 points. To know where to place these points, we need a technique to define where along the line, the points should be placed. The placement strategy could be random, which is self-explanatory, or it could be an even-spacing. These ideas are visualised in @f.m.formation-shapes.

#figure(
  [],
  caption: [Different formation shapes and placement strategies.],
)<f.m.formation-shapes>

Now that we understand _distribution shapes_, we can look at their use-cases. These shapes are used in a formation, to describe how to place initially place the robots when spawned into the environment. Thereafter, each formation has a list of waypoints, which is a list of these _distribution shapes_ and _projection strategies_. The _projection strategies_ are used to describe how to map the initial spawning locations of the robots, to the new waypoints. A couple strategies have been implemented, namely; `identity`, `cross`. A possible formation configuration is shown in @f.m.formation-config.

#listing(
  [
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
  ],
  caption: [Formation configuration example.],
)<f.m.formation-config>
