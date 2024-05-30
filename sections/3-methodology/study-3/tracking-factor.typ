#import "../../../lib/mod.typ": *

=== Tracking Factor $bold(f_t)$ <s.m.tracking-factor>

The design of the tracking factor mimics that of the interrobot factors, $f_i$. Similar to the interrobot factors, the tracking factor takes two points in space into account, the variables position, $x$, and the position to pull towards. As just mentioned, oppositely from the interrobot factors, the tracking factor wants these two positions to get closer together, where the interrobot factors push the two apart. These properties are achieved through the measurement function, $h_t(x)$, and the Jacobian, $J_t(x)$, as described in sections #numref(<s.m.tracking-factor.measure>) and #numref(<s.m.tracking-factor.jacobian>), respectively.

==== Measurement Function <s.m.tracking-factor.measure>


The measurement function, $h_t (#m.x, #m.P, i)$, takes in the variable state, $#m.x = [x#h(0.5em)y#h(0.5em)equation.overdot(x)#h(0.5em)equation.overdot(y)]^top$, the path, $#m.P$, and an index, $i$. Where $#m.P$ is the set of waypoints, $#m.P = {#m.p _1, #m.p _2, ..., #m.p _n}$, and $i$ is the index of which line segment $#m.l _i = #m.p _(i+1) - #m.p _(i)$ the tracking factor should be following. Lastly, let $#m.x _"pos"$ and $#m.x _"vel"$ be the position and velocity components of the variable state, respectively, see @eq.variable-components.

$
  #m.x _"pos" = mat(x, y)^top#h(2em)"and"#h(2em)#m.x _"vel" = mat(equation.overdot(x), equation.overdot(y))^top
$<eq.variable-components>

The main idea behind the tracking factor, is that it projects the variable's position onto the line segment that is should currently be following, and then uses the measurement of the distance between the projected point and the variable's position as the measurement. This idea needs further modifications, will be covered in the following explanation of how to arrive at the measurement function $h_t$. First let's define a projection function, $"proj"(#m.x, #m.p _"start", #m.p _"end")$, that projects a point, $#m.x$, onto a line segment defined by two points, $#m.p _"start"$ and $#m.p _"end"$, as shown in <eq.projection>.

$
  "proj"(#m.x, #m.p _"start", #m.p _"end") = #m.p _"start" +
  ((#m.x - #m.p _"start") dot (#m.p _"end" - #m.p _"start")) / norm(#m.p _"end" - #m.p _"start")^2
  (#m.p _"end" - #m.p _"start")
$<eq.projection>

There are two possible projections we want to consider, specifically when the variable approaches a waypoint, and needs to transition to the next line segment. A radius, $r_"switch"$, is defined as the distance within $#m.p _(i+1)$, the index $i$ should be incremented to consider the next line segment. As such, we have the two projections $#m.proj _i$ and $#m.proj _(i-1)$ to consider, see @eq.projections.

$
  #m.proj _i &= "proj"(#m.x, #m.p _i, #m.p _(i+1)) \
  #m.proj _(i-1) &= "proj"(#m.x, #m.p _(i-1), #m.p _i)
$<eq.projections>

Whether to consider the projection to the next line segment becomes the logical conditional statement, $q$, defined in @eq.switch.

$
  q = norm(#m.proj _i - #m.p _i) < r_"switch" and norm(#m.proj _(i-1) - #m.p _i) < r_"switch"
$<eq.switch>

Hereby, the point to measure the distance to $#m.x _"meas"$ becomes equation @eq.measurement-point. The first case of @eq.measurement-point happens when the variable is close to the waypoint, and the tracking factor will measure towards the actual waypoint itself by taking both projections into account. This behaviour is visualised in @f.m.tracking-factor, along with the conditional $q$ as a green area#swatch(theme.green.lighten(35%)).

$
  #m.x _"meas" = cases(
    #m.x _"pos" + 1/2 ((#m.proj _i - #m.x _"pos") + (#m.proj _(i-1) - #m.x _"pos")) &"if" q \
    #m.proj _i + #m.d dot norm(#m.x _"vel") / s_v &"otherwise"
  )
$<eq.measurement-point>

Where $#m.d = #m.l _i / norm(#m.l _i)$ is the normalised direction vector of the line segment $#m.l _i$. The addition of $#m.d dot norm(#m.x _"vel") / s_v$ in the second case of @eq.measurement-point is a way to ensure that the tracking factor always tries to also move the variable along the line segment, and not only perpendicularly towards it; which in turn helps alleviate local minima where the variable might get stuck #sym.dash.en _this happens especially when some tracking factors are tracking towards the corner, without having others pulling it along_. This pulling along is also shown in @f.m.tracking-factor. It is chosen that $s_v = 5$ in the denominator, which is somewhat arbitrary, but it does a good job of allowing the factor to pull slightly on the variable without pulling so much that the variable overtakes future variables; a large $s_v$ makes previous variables shoot far ahead overtaking future variables, thus resulting in the robot far exceeding the target speed. The last piece of the puzzle is to define the measurement function, $h_t$, as the distance between the variable's position and the measurement point, $#m.x _"meas"$, as shown in @eq.measurement.

$
  h_t(#m.x, #m.P, i) = "min"(1, norm(#m.x _"pos" - #m.x _"meas") / d_a)
$<eq.measurement>

Two modifications to the raw distance take place;
#[
  #set par(first-line-indent: 0em)
  #set enum(numbering: box-enum.with(prefix: "M-"))
  + *Modification:* The distance is normalised by $d_a$, which is a configurable parameter called `attraction_distance`#footnote[Example in the #source-link("https://github.com/AU-Master-Thesis/gbp-rs", "gbp-rs") repository at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/ac49ddb764078e34290708e0f60846e45055e9c1/config/simulations/Intersection/config.toml#L53", "/config/simulations/Intersection/config.toml:53")] under the `gbp.tracking` table in the `config.toml` file.

    #v(0.5em)

    *Reasoning:* This acts as a knob that can be turned for the user to control how quickly the attraction force should reach its maximum.

  + *Modification:* The distance is clamped to a maximum of $1$, after normalisation.

    #v(0.5em)

    *Reasoning:* This is a safety measure to ensure that the factor measurement is bounded, and as such helping to keep the factor graph inference stable.
]

==== Jacobian <s.m.tracking-factor.jacobian>
The Jacobian's, $jacobian_t$, responsibility is to encode the measurement strength of the tracking factor into a direction for the variable to move towards. First let's find the difference $#m.x _"diff"$

$
  #m.x _"diff" = #m.x _"meas" - #m.x _"pos"
$<eq.diff>

Where the Jacobian, $J_t$, is then defined as the normalised difference, $#m.x _"diff"$, where the normalisation factor is the current measurement value $h$, see @eq.jacobian.

$
  jacobian_(t,"pos") = #m.x _"diff" / h
$<eq.jacobian>

With a connection to a single variable, and $"DOFS" = 4$, the Jacobian, $J_t$, should be a $1 times 4$ matrix. Which can be obtained by concatenating the $1 times 2$ matrix, $jacobian_(t,"pos")$ with a zeros matrix of the same size, see @eq.jacobian-padding.

$
  jacobian_t = [jacobian_(t,"pos"), 0, 0] = mat(1/h (x_"meas" - x_"pos"), 1/h (y_"meas" - y_"pos"), 0, 0)
$<eq.jacobian-padding>

Where $#m.x _"meas" = [x_"meas"#h(0.5em)y_"meas"]^top$ and $#m.x _"pos" = [x#h(0.5em)y]^top$ is the positional component of the linearisation point as defined in @eq.variable-components. Looking at the interrobot factor Jacobian, $jacobian_i$, in @eq.jacobian-i, it is clear that they both utilise the normalised difference between two points, and the only difference is that, for the tracking factor, only one of the two points come from a variable, which can be moved, the other from the instantaneously static projection onto the path.
