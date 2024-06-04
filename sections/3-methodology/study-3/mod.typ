#import "../../../lib/mod.typ": *
== #study.H-3.full.n <s.m.study-3>
This section outlines the methodology for #study.H-3.prefix. The general approach for integrating global planning with the original approach by@gbpplanner is described in @s.m.global-planning, which completes research objective #boxed(color: theme.green, [*O-3.1.1*]). The results of the carried out method from this section are presented in @s.r.study-3, thus closing off #boxed(color: theme.green, [*O-3.1.2*]) and #boxed(color: theme.green, [*O-3.2.1*]). The motivation for this addition comes by how the robots are pulled along their path. This happens by manually moving the horizon variable along the path at a steady rate, not influenced by how far the robot has actually gotten. With many obstacles, this results in the robots often getting stuck in local minima. These local minima are expected to be avoided when a global planner takes care of the environmental collision avoidance.#footnote[See demonstration video on #link("https://youtu.be/Uzz57A4Tk5E", "YouTube: Master Thesis - Path Tracking vs Waypoint Tracking vs Default").] Furthermore, in an attempt to reduce path deviation, a tracking factor is introduced to the #acr("GBP") structure. The design of which is detailed in @s.m.tracking-factor. This deliberation completes objectives #boxed(color: theme.green, [*O-3.4.X*]), while the results from @s.r.study-3 will provide closure for #boxed(color: theme.green, [*O-3.5.X*]).
// #note.jonas[Is this enough to explain the motivation? Or do we need some evidence like a screenshot or link to a video?]

#include "global-planning.typ"
#include "tracking-factor.typ"
