#import "../../../lib/mod.typ": *
=== Architecture <s.m.architecture>

This section presents the architectural patterns used in the design of the simulation. First by presenting the major architectural paradigm used, the ECS paradigm. What it is, how it works and why it was chosen. Second how it results in changes compared to the original implementation of the gbplanner algorithm.


==== Entity Component System

#todo[
  briefly mention intermediate mode GUI vs retained mode
]

#todo[
    Mention that bevy will try to automatically schedule systems in parallel when the queries mutability allow for it.
]

#k[
  write about how we use bevy and ECS. what components are central, and how is the algorithm composed using systums and run schedules.
]


#jonas[This section about ECS has been moved to the background section.]
#todo[There should be new content here, describing why this architecture was chosen, and which others were considered.]
