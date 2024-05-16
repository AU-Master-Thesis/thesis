#import "../../lib/mod.typ": *
= Discussion <Discussion>

#todo[
  Discuss/critisize the way the horizon variable is updated. By always having it move along, it can end in situations where the robot stops up, cause it cannot arrive at a proper solution, but after some time the robot shoots away, due to the horizon variable moving to far away, thereby sort of overruring the effect of the other factors.
]

#note.kristoffer[discuss what would need to change from our simulation to a system working with real world robots

- Detection of neighbors

]

#kristoffer[
  discuss why their implementation has a higher throughput that ours #emoji.face.sad due to graph representation. They use OpenMP
]

#include "./future-work.typ"
