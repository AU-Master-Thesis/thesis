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


#kristoffer[
- Expect Soon as Possible and Late as Possible to be the same, as they are identical, only different in their offset/phase
- Same for Centered and Half at the beginning, Half at the end, as they exhibit the same symmetry

- Expect Interleave Evenly to perform the best, as the computation is the most evenly distributed in time
]
