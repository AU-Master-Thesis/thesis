#import "../../lib/mod.typ": *
== #study.H-3.full.n <s.r.study-3>

#jens[section intro]

=== Path Adherence <s.r.study-3.solo-global>
#jens[Global Planning without $f_t$ vs Global Planning with $f_t$]

#jens[Isolted waypoint tracking vs path tracking for a single robot. Will show how much the robot deviates from the path.]

The path adherence is shown in @t.path-adherence, where we can see how the tracking factor has lowered the path-deviation error across the board.

#figure(
  // tablec(

  // )
  [],
  caption: [Path deviation error.]
)<t.path-adherence>

=== Collaborative Global Planning <s.r.study-3.collaborative-global>
#jens[Effect of tracking factor on ability to avoid each other]

#jens[Waypoint tracking vs path tracking and their effects on collissions vs path adherence.]
