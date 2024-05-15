#import "../../lib/mod.typ": *
== #study.H-2.full.n <s.r.study-2>

#kristoffer[
  Our `Message` type is a wrapper type around a optional payload. So we can communicate an "empty" message.

  They do not have this, and just send zero messages where the precision matrix and information vector are all zeros. With the option wrapping we can skip work if it is empty.
]

#todo[
  Construct experiment that test the effect of varying the number of variables.
  Especially for sharp corners like 90 degree turns in the junction.
]
