#import "../../../lib/mod.typ": *

== #study.H-4.full.n <s.m.study-4>

#jonas[Put the path tracking here separate from the global planning stuff?]

To achieve a level of adherence to the path given to each robot, the  factor graph structure has been utilised. A new factor, namely the tracking factor, $f_t$, has been designed to reach this goal. The tracking factor is designed to attach to each variable in the prediction horizon, except for the first and last that already have anchoring pose factors, as these cannot be influenced either way. In @s.m.tracking-factor, the design of the tracking factor is explained in detail, and @s.m.expectations outlines the expected outcome of the tracking factor.

#include "tracking-factor.typ"
#include "expectation.typ"
