#import "../../../lib/mod.typ": *
=== Tracking Factor $bold(f_t)$ <s.m.tracking-factor>

The design of the tracking factor mimics that of the interrobot factors, $f_i$. Similar to the interrobot factors, the tracking factor takes two points in space into account, the variables position, $x$, and the position to pull towards. As just mentioned, oppositely from the interrobot factors, the tracking factor wants these two positions to get closer together, where the interrobot factors push the two apart. These properties are achieved through the measurement function, $h_t(x)$, and the Jacobian, $J_t(x)$, as described in sections #numref(<s.m.tracking-factor.measure>) and #numref(<s.m.tracking-factor.jacobian>), respectively.

==== Measurement Function <s.m.tracking-factor.measure>

==== Jacobian <s.m.tracking-factor.jacobian>
