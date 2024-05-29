#import "../../../lib/mod.typ": *

== #study.H-4.full.n <s.m.study-4>

// #jonas[Put the path tracking here separate from the global planning stuff?]

To achieve a level of adherence to the path given to each robot, the  factor graph structure has been utilised. A new factor, namely the tracking factor, $f_t$, has been designed to reach this goal. The tracking factor is designed to attach to each variable in the prediction horizon, except for the first and last that already have anchoring pose factors, as these cannot be influenced either way. In @s.m.tracking-factor, the design of the tracking factor is explained in detail. Let's outline the expectations for the effects of this factor: \ \

#[
  #let m = (
    x: $bold(upright(x))$,
    P: $bold(upright(P))$,
    p: $bold(upright(p))$,
    proj: $bold(upright("proj"))$,
    d: $bold(upright(d))$,
    l: $bold(upright(l))$,
  )
  #set par(first-line-indent: 0em)
  *Expectation:* As a result of the design of the tracking factor $f_t$, it is expected that the variables will be consistently pulled towards the path $#m.P$, similar, but opposite to how the interrobot factor $f_i$ pushes the variables apart. The tracking factor $f_t$ will encourage the variables to adhere closely to the prescribed path $#m.P$, resulting in reduced path deviation, especially around corners where variables are prone to cutting corners. Additionally, $f_t$ will help the variables maintain a more consistent speed by pulling them towards the path and reducing the time spent correcting deviations. Consequently, the implementation of $f_t$ should result in a lower path deviation error compared to scenarios without this factor.
]

#include "tracking-factor.typ"
// #include "expectation.typ"
