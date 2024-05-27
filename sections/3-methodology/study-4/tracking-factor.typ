#import "../../../lib/mod.typ": *
=== Tracking Factor $bold(f_t)$ <s.m.tracking-factor>

The design of the tracking factor mimics that of the interrobot factors, $f_i$. Similar to the interrobot factors, the tracking factor takes two points in space into account, the variables position, $x$, and the position to pull towards. As just mentioned, oppositely from the interrobot factors, the tracking factor wants these two positions to get closer together, where the interrobot factors push the two apart. These properties are achieved through the measurement function, $h_t(x)$, and the Jacobian, $J_t(x)$, as described in sections #numref(<s.m.tracking-factor.measure>) and #numref(<s.m.tracking-factor.jacobian>), respectively.

==== Measurement Function <s.m.tracking-factor.measure>

#let m = (
  x: $bold(upright(x))$,
  P: $bold(upright(P))$,
  p: $bold(upright(p))$,
  proj: $bold(upright("proj"))$,
  d: $bold(upright(d))$,
  l: $bold(upright(l))$,
)
The measurement function, $h_t (#m.x, #m.P, i)$, takes in the variable state, $#m.x = [x, y, equation.overdot(x), equation.overdot(y)]^top$, the path, $#m.P$, and an index, $i$. Where $#m.P$ is the set of waypoints, $#m.P = {#m.p _1, #m.p _2, ..., #m.p _n}$, and $i$ is the index of which line segment $#m.l _i = #m.p _(i+1) - #m.p _(i)$ the tracking factor should be following.

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

Hereby, the point to measure the distance to $x_"meas"$ becomes @eq.measurement-point.

$
  x_"meas" = cases(
    #m.x _"pos" + 1/2 ((#m.proj _i - #m.x _"pos") + (#m.proj _(i-1) - #m.x _"pos")) &"if" q \
    #m.proj _i + #m.d dot norm(#m.x _"vel") / 5 &"otherwise"
  )
$<eq.measurement-point>

Where $#m.d = #m.l _i / norm(#m.l _i)$ is the normalised direction vector of the line segment $#m.l _i$, and $#m.x _"pos" = [x, y]$ and $#m.x _"vel" = [equation.overdot(x), equation.overdot(y)]$ are the position and velocity components of the variable state, respectively. The addition of $#m.d dot norm(#m.x _"vel") / 5$ in the second case of @eq.measurement-point is a way to ensure that the tracking factor always tries to also move the variable along the line segment, and not only perpendicularly towards it; which in turn helps alleviate local minima where the variable gets stuck. The choice of $5$ in the denominator is arbitrary, but does a good job of allowing the factor to pull slightly on the variable without pulling so much that the variable overtakes future variables, shooting too far ahead and far exceeding the target speed of the robot. The last piece of the puzzle is to define the measurement function, $h_t$, as the distance between the variable's position and the measurement point, $x_"meas"$, as shown in @eq.measurement.

$
  h_t(#m.x, #m.P, i) = "min"(1, norm(#m.x - x_"meas") / d_a)
$<eq.measurement>

Two modifications to the raw distance take place;
#[
  #set enum(numbering: box-enum.with(prefix: "M-"))
  + The distance is normalised by $d_a$, which is a configurable parameter called `attraction_distance`#footnote[Example in the #source-link("https://github.com/AU-Master-Thesis/gbp-rs", "gbp-rs") repository at #source-link("https://github.com/AU-Master-Thesis/gbp-rs/blob/ac49ddb764078e34290708e0f60846e45055e9c1/config/simulations/Intersection/config.toml#L53", "/config/simulations/Intersection/config.toml")] under the `gbp.tracking` table in the `config.toml` file.
]

==== Jacobian <s.m.tracking-factor.jacobian>
