#import "../../lib.typ": *
= Methodology <methodology>

#include "language.typ"
#include "architecture.typ"
#include "global-planning.typ"


#kristoffer[talk about design of different config format design, especially `formation` and `environment`

show examples of them, and how they allow for flexibly and declaratively define new simulation scenarios
]

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



// #import "@preview/codelst:2.0.1": sourcecode
//
// #sourcecode[```typ
// #show "ArtosFlow": name => box[
//   #box(image(
//     "logo.svg",
//     height: 0.7em,
//   ))
//   #name
// ]
//
// This report is embedded in the
// ArtosFlow project. ArtosFlow is a
// project of the Artos Institute.
// ```]


#kristoffer[
  show screenshots side by side of different elements of the simulation from theirs and ours, 
  e.g. visualisation of the factorgraph, or how we added visualisation of each variables gaussian uncertainty


  use this to argue on a non measureable level why our implementation has is similar to theirs / has been reproduced
]

#kristoffer[
  talk about how our graph representation is different from theirs.
  Ours is more faithful to how robots would represent the other robots in the environment
  compared to theirs, since they use bidirectional `std::shared_ptr`, which is not useable
  in a scenario where the algorithm run on different computer hosts, or just computer processes on the same host.
]
