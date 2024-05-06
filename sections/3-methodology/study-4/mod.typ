#import "../../../lib/mod.typ": *

== #study.H-4.full.n <s.r.study-4>

#kristoffer[talk about design of different config format design, especially `formation` and `environment`

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
