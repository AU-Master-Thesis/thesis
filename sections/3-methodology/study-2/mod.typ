#import "../../../lib/mod.typ": *
== #study.H-2.full.n <s.m.study-2>

This section covers the methodology for #study.H-2.prefix. The concept of internal/external iteration scheduling is described in @s.iteration-schedules. An experiment to test the effect of the introduced concept is presented and discussed in @s.r.study-2.

// The general approach for integrating global planning with the original approach by@gbpplanner is described in @s.m.global-planning. The results of the carried out method from this section are presented in @s.r.study-3.



// #kristoffer[
//   Our `Message` type is a wrapper type around a optional payload. So we can communicate an "empty" message.
//
//   They do not have this, and just send zero messages where the precision matrix and information vector are all zeros. With the option wrapping we can skip work if it is empty.
// ]
//
// #jonas[This section is much more finished now, please read.]

#include "iteration-schedules.typ"
