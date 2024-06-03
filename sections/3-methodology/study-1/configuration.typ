#import "../../../lib/mod.typ": *

=== Configuration <s.m.configuration>

To make the developed software more flexible and easier to use, several configuration formats have been developed. The main configuration file, `config.toml`, uses #acr("TOML"), and is used to define all the general parameters for the simulation, visualisation, and #acr("UI"). The most important sections of the main configuration file are: `GBP`, `Robot`, `Simulation`, `Visualisation`. The smaller sections are described in the code documentation itself.@repo
#set enum(numbering: box-enum.with(prefix: "Section "))
+ `GBP:` Outlines all initial factor standard deviations, $sigma$, used in the #acr("GBP") message passing, alogn with the iteration schedule to use and how many of _internal_ vs _external_ iterations to run.
+ `Robot:` Defines each robot's properties, such as size, target speed, communication radius and failure rate, and degrees of freedom. Additionally, some properties for the structure of the underlying factor are in this section; i.e. the planning-horizon, whether to use symmetric interrobot factors, and scaling of the safety distance between robots.
+ `Simulation:` Contains the parameters for the simulation itself, such as the maximum simulation time, the #acr("RNG") seed, and the fixed time-step frequency to run the #acr("GBP") algorithm at. More are described in @repo.
+ `Visualisation:` Contains the parameters for the visual elements. This includes which properties to draw to the screen like communication radius, interrobot connections, planning horizon, waypoints, etc. Furthermore, some scaling factors, i.e. for the variable uncertainties, to make them visible on the screen, are defined here. Again, more are described in @repo.


==== Environment Configuration <s.m.configuration.environment>
A datastructure for describing the static environment has been developed, and includes two main parts; the overall environment, and the option to specify several placeable shapes.

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
  ([█], [U+2588]),
  ([╴], [U+2574]),
  ([╵], [U+2575]),
  ([╶], [U+2576]),
  ([╷], [U+2577]),
).map(it => {
  (
    text(font: "JetBrainsMono NF", it.at(0)),
    text(font: "JetBrainsMono NF", it.at(1))
  )
})

#let unicode-fig = [
  #v(1em)
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
  ===== The Main Environment<s.m.configuration.environment.main>

  This section of the configuration file is a matrix of strings. Each character in the matrix represents a tile in the environment. The supported characters are listed in @t.unicode-list. The environment is generated from this matrix, where each character is a aquare tile, with a configurable side-length, and the coloured-in parts of the characters are the free paths and the rest are walls. The path-width is configurable as a percentage of the tile side-length.

  The#h(1fr)environment#h(1fr)shown#h(1fr)in#h(1fr)@f.m.maze-env#h(1fr)is#h(1fr)built
]

#grid(
  columns: 2,
  column-gutter: 1em,
  b,
  unicode-fig,
)
#v(-0.60em)
from the character matrix, in @f.m.maze-env#text(accent, "A"). Even though each character is taller than it is wide when written out in most fonts, the map-generation code produces one _square *tile*_ for each character. This makes up for the seeming descrepency in aspect ratio between the character grid in @f.m.maze-env#text(accent, "A"), and the actual environment in @f.m.maze-env#text(accent, "B"). A few special case characters are `U+2588 █`, and a space, where, the former represents free space, and the latter represents a filled-in tile, similarly to how the white-space in the other path characters are the actual obstacles.

The resulting grid of _tiles_ in @f.m.maze-env#text(accent, "B") is, 5$times$8, where a 2$times$1 segment is highlighted#sg. In @f.m.maze-env#text(accent, "C") the highlighted section is shown bigger, where, in red#sr, the resulting #acr("AABB") colliders are shown. These colliders are generated on a per-tile basis, which means that the there are seams between the tiles, where the colliders meet. One could argue that these seams could be eliminated to optimise computational efficiency, as less intersection tests would have to be made in the #acr("RRT*") algorithm.

#figure(
  {
    set par(justify: false)
    set text(theme.text)
    grid(
      columns: (auto, 8em, 2.4125fr, 1fr, auto),
      [],
      std-block(breakable: false)[
        #set par(leading: 0.25em)
        #set text(size: 14pt)
        // #let sp = 6.375em
        #let sp = 5.42em
        #let sp-top = 2.5em
        // #v(sp-top)
        #box(
          fill: rgb(1, 1, 1, 0),
          height: sp-top,
          outset: 0em,
          inset: 0em,
        )
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
  caption: [
    #let outline = {
      let l = place(dy: -0.35em, line(length: 1.6em, stroke: (thickness: 2pt, paint: theme.green, dash: "dashed", cap: "round")))
      box(inset: (x: 2pt), outset: (y: 2pt), l + h(1.6em))
    }
    An example of a maze-like environment. A) Shows the character matrix used to generate the environment. B) Shows the generated environment tile grid with all obstacles in blue#sl, where two tiles are highlighted#outline. In C) the highlighted tiles are shown bigger, with the resulting AABB colliders in red#sr.
  ],
)<f.m.maze-env>

// The environment is generated from this matrix, where each character is a tile, and the environment is a grid of tiles. The environment is then used to generate the colliders for the robots to avoid, and the visual representation of the environment.

#let param-fig = [
  #figure(
    {
      v(1.5em)
      tablec(
        columns: (auto, 1fr, auto),
        alignment: (left, left, left),
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
  ===== Placeable Obstacles<s.m.configuration.environment.obstacles>

  Another section in the environment configuration is the `obstacles` list. This is a list of shapes that are completely configurable within each tile. That#h(1fr)is,#h(1fr)the#h(1fr)shapes#h(1fr)can#h(1fr)be#h(1fr)placed#h(1fr)any-
]

#grid(
  columns: (3fr, 4fr),
  column-gutter: 1em,
  b,
  param-fig,
)
#v(-0.5em)
where within the tile, and have any size. The map-generator supports the shapes listed in @t.environment-shapes. @t.environment-shapes also details all configurable parameters for each shape.

#figure(
  std-block(
    grid(
      columns: 2,
      sourcecode[
        ```yaml
        tiles:
          grid:
          - █
          settings:
            tile-size: 100.0
            path-width: 0.1
            obstacle-height: 1.0
            sdf:
              resolution: 200
              expansion: 0.025
              blur: 0.01
        obstacles:
        - shape: !regular-polygon
            sides: 4
            radius: 0.0525
          translation:
            x: 0.625
            y: 0.60125
          rotation: 0.0
          tile-coordinates:
            row: 0
            col: 0
        - shape: !regular-polygon
            sides: 4
            radius: 0.035
          translation:
            x: 0.44125
            y: 0.57125
          rotation: 0.0
          tile-coordinates:
            row: 0
            col: 0
        - shape: !regular-polygon
            sides: 4
            radius: 0.0225
          translation:
            x: 0.4835
            y: 0.428
        ```
      ],
      sourcecode(
        numbers-start: 39
      )[
        ```yaml
          rotation: 0.0
          tile-coordinates:
            row: 0
            col: 0
        - shape: !rectangle
            width: 0.0875
            height: 0.035
          translation:
            x: 0.589
            y: 0.3965
          rotation: 0.0
          tile-coordinates:
            row: 0
            col: 0
        - shape: !triangle
            angles:
              A: 1.22
              B: 1.22
            radius: 0.025
          rotation: 0.0
          translation:
            x: 0.5575
            y: 0.5145
          tile-coordinates:
            row: 0
            col: 0
        - shape: !triangle
            angles:
              A: 0.6981317007977318
              B: 1.9198621771937625
            radius: 0.01
          rotation: 5.2
          translation:
            x: 0.38
            y: 0.432
          tile-coordinates:
            row: 0
            col: 0
        ```
      ]
    )
  ),
  kind: "listing",
  supplement: [Listing],
  caption: [Example of an environment configuration with several placeable shapes. This configuration belongs to the *Environment Obstacles Experiment* scenario. It uses the _Circle_, _Rectangle_, _Regular polygon_, and _Triangle_ shapes.],
)<lst.env-obstacle-config>

Furthermore, which tile to place the shape in is given as a tile-$x$ and $y$ coordinate, to index which tile to place the obstacle in, along with a within-tile 2D translation. Important to note is that the parameters for the shapes are given in the local coordinate system of the tile, and as scalable percentage values of the tile side-length. As such, the placed obstacles are scaled along with the tile size, which produces a consistent environment, regardless of the size of the tiles. This way it's the tile-size that acts as a global scale. Another approach would be to have absolute coordinates for all these parameters, however, this is a more frictionfull approach, as understanding which tile you're attempting to place an obstacle inside will be harder to understand, along with the obstacles placement in relation to each other. Basically, this approach splits the global coordinate into a grid of local coordinates, which are easier to keep track of when a user is designing the environment. And example of an environment configuration with multiple placeable shapes is shown in @lst.env-obstacle-config.


==== Formation Configuration <s.m.configuration.formation>
The formation configuration is used to define how the robots are spawned in the environment. A great deal of care has gone into making this a highly flexible and declarative way to define new ways to spawn robots, and define their waypoints. The formation configuration is a list of formations, where each formation is a set of parameters for how to spawn the robots, and how to layout their waypoints.

Formations are described with the concept of _distribution shapes_. These shapes are an abstract way of representing dynamically placed points, but within some constraints. Say the shape is a line from $(0,0)$ to $(1,0)$, and we want this line to describe how to place 5 points. To know where to place these points, we need a technique to define where along the line, the points should be placed. Two techniques have been implemented; `random` and `even`. These two strategies inform whether to place the points with even spacing as in @f.m.formation-shapes#text(accent, "A"), or randomly as in @f.m.formation-shapes#text(accent, "B"). Note, that with the `random` strategy, each robot's size is taken into account, as, when spawned they cannot be intersecting with each other.

#figure(
  {
    set text(theme.text)
    grid(
      columns: 2,
      std-block[
        #image("../../../figures/out/distribution-shapes-even.svg", height: 12em, fit: "contain") \

        A: Even Distribution
      ],
      std-block[
        #image("../../../figures/out/distribution-shapes-random.svg", height: 12em, fit: "contain") \

        B: Random Distribution
      ],
    )
  },
  caption: [Different formation shapes and placement strategies. Both #text(accent, "A") and #text(accent, "B") show a line and a circle shape, where the points in #text(accent, "A") are placed evenly, and in #text(accent, "B") are placed randomly.],
)<f.m.formation-shapes>

Now that we understand _distribution shapes_, we can look at their use-cases. These shapes are used in a formation, to describe how to place initially place the robots when spawned into the environment. Thereafter, each formation has a list of waypoints, which is a list of these _distribution shapes_ and _projection strategies_. The _projection strategies_ are used to describe how to map the initial spawning locations of the robots, to the new waypoints. A couple strategies have been implemented, namely; `identity`, `cross`. A possible formation configuration is shown in @f.m.formation-config.

For each formation it is additionally possible to define when each waypoint is considered reached with the `waypoint-reached-when-intersects` key, and when the formation is considered finished with the `finished-when-intersects` key. Both of these take either `horizon`, `current`, or `!variable n`, where `n` is which variable in the factor graph to consider.

Lastly, some timing options are available; `repeat-every` and `delay`. The `repeat-every` key defines how often to spawn the amount of robots defined by the `robots` key on the _distribution shape_ given by the `initial-position` key. The `delay` sets an initial time offset before the first spawn event takes place.

#figure(
  std-block(
    grid(
      columns: 2,
      sourcecode[
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
        ```
      ],
      sourcecode(
        numbers-start: 12,
      )[
        ```yaml
              y: 0.0
            - x: 0.55
              y: 0.0
            placement-strategy: !even
          waypoints:
          - shape: !line-segment
            - x: 0.45
              y: 1.25
            - x: 0.55
              y: 1.25
            projection-strategy: cross
        ```
      ]
    )
  ),
  caption: [Formation configuration example spawning a single robot every 8 seconds with an initial delay of 2 seconds. Here, the `line-segment` _distribution shape_ is used, along with the `even` _placement strategy_, and `cross` _projection strategy_.],
)<f.m.formation-config>


#par(first-line-indent: 0pt)[For a complete example of each configuration format see the three files; #configs.config, #configs.environment, and #configs.formation used in the _Environment Obstacles_ scenario,experimented with later on in @s.r.scenarios.environment-obstacles.]

// #source-link("https://github.com/aalpatya/gbpplanner/blob/fd719ce6b57c443bc0484fa6bb751867ed0c48f4/config/circle_cluttered.json", "config/circle_cluttered.json")

=== Signed Distance Field <s.m.sdf>
As described above in @s.m.configuration.environment, the environment is generated from a matrix of characters, and a list of placeable obstacles. The advantage of being able to describe the environment in a constrained text format comes from the declarative nature of the format. You simply describe the geometrical shapes from their underlying data, and where to place them, and as such there will never be any dispute as to how that environment should look within the constraints of the format. This also provides a simple and compact single source of truth for the environment, which can be read for multiple purposes.

The simulation tool, described in @s.m.simulation-tool, displays the environment in the _viewport_ as 3D meshes, showing the user what the world looks like. Furthermore, the tool also uses the environment configuration to automatically generate an #acr("SDF") file, which is then used by the obstacle factors, refer to #nameref(<s.m.factors.obstacle-factor>, [Obstacle Factor $f_o$]), as a way to measure the distance to nearest obstacle.

#figure(
  {
    set text(theme.text)
    let cut-amount = 8em
    grid(
      columns: 3,
      std-block[
        #box(
          clip: true,
          pad(
            x: -cut-amount,
            y: -cut-amount,
              image("../../../figures/img/img.png")
          )
        )

        A: Rasterised Environment
      ],
      std-block[
        #box(
          clip: true,
          pad(
            x: -cut-amount,
            y: -cut-amount,
              image("../../../figures/img/img_exp.png")
          )
        )

        B: Expanded Environment
      ],
      std-block[
        #box(
          clip: true,
          pad(
            x: -cut-amount,
            y: -cut-amount,
              image("../../../figures/img/sdf.png")
          )
        )

        C: Blurred
      ],
    )
  },
  caption: [An example of an automatically generated SDF file. A) Rasterise the environment into a black and white image. B) Expand the obstacles to make the eventual blur eat less into the obstacles. C) Blur the image to create the final SDF.],
)<f.m.sdf>

Furthermore, this single source of truth, allows the simulation tool to visualise the true environment as meshes; generated from the same configuration file. As explained later, in , the user can choose to toggle visibility of both this _generated map_ mesh, and the #acr("SDF") image, which allows the user to understand both the actual environment and how the factors are measuring the environment. Furthermore, true collisions between the robots and the environment are calculated using the `parry2d`@parry2d library, which also uses the environment configuration to generate all the necessary colliders.

// ==== Signed Distance Field <s.m.sdf.sdf>

// Automatic generation of SDF image
// 1. Rasterise the environment into a black and white image.
// 2. Expand the obstacles to make the eventual blur eat less into the obstacles.
// 3. Blur the image to create the final SDF.

As shown in @f.m.sdf, the process of generating the #acr("SDF") image is done in three steps:
#set enum(numbering: box-enum.with(prefix: "Step "))
+ *Rasterisation:* The rasterisation of the environment happens by creating a white image with resolution calculated by @eq.sdf-rasterisation:

  $
    "width" = r_t times c#h(1em)"and"#h(1em)"height" = r_t times r
  $<eq.sdf-rasterisation>

  where $r_t$ is the tile-resolution from `environment.yaml`, and $c$ and $r$ are the number of columns and rows in the environment matrix respectively. Now going through each pixel of the environment, it is determined whether to make it black if it is either a part of the environment from the character matrix, or if it is part of an obstacle from the `obstacles` list. See @f.m.sdf#text(accent, "A") for the resulting rasterisation of the `environment.yaml` written in @lst.env-obstacle-config, but without any expansion.

+ *Expansion:* The expansion of the obstacles is done, not by simply dilating the black pixels, but by expanding the underlying data of each of the placeable shapes providing the obstacles. This method provides a more accurate representation of the obstacles as if they were bigger, where a dilation would round over corners that would otherwise be sharp, which is an important detail to retain. See @f.m.sdf#text(accent, "B") for an example of the same `environment.yaml`, but with an expansion of #todo[how much?].

+ *Blurring:* The final step is to blur the image, which is done using a Gaussian blur. This step provides the #acr("SDF") aspects of the result with a smooth black-to-white, obstacle-to-free transition #gradient-box(black, white, width: 2em). The result of the blurring can be seen in @f.m.sdf#text(accent, "C"). The blurring is usually done with a non-zero expansion, as this provides a buffer between the obstacles and the free space. However, one should note that the resulting #acr("SDF") is _not_ an accurate representation of euclidean distances, but rather a sufficient approximation for the purposes of the simulation. Furthermore, one could argue that and accurate #acr("SDF") would be harmful, as we don't want the robots to react to any obstacles that they are far away from either way. Currently, avoiding this is encoded into the image here, but if an accurate #acr("SDF") is desired this behaviour should be transferred to the measurement function of the obstacles factor.
