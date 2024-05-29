#import "../../../lib/mod.typ": *
== #study.H-2.full.n <s.m.study-2>

#todo[
  Make section intro
]


#kristoffer[
  Our `Message` type is a wrapper type around a optional payload. So we can communicate an "empty" message.

  They do not have this, and just send zero messages where the precision matrix and information vector are all zeros. With the option wrapping we can skip work if it is empty.
]

// #jonas[This section is much more finished now, please read.]

#include "iteration-schedules.typ"
