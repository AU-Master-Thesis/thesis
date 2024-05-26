#import "../../lib/mod.typ": *

// #todo[solve these fricking frucking reference issues]
// // This section presents the results for #study.H-1.full in @s.r.study-1 and #study.H-2.prefix: #study.H-2.full in @s.r.study-2.

#let specs = (
  cpu:  [12th Gen Intel Core i7-12700H], // `lscpu`
  arch: [64-bit x86-64], // `uname -m`
  ram:  [16GiB SODIMM Synchronous 4800 MHz], // `sudo lshw -short -C memory`
  kernel: [6.6.30], // `uname -r`
  distro: [NixOS],
)



= Results <s.results>

This section details the experiments conducted to test the hypotheses outlined in @intro-research-hypothesis. It begins by presenting the metrics used for quantitative comparison. Each scenario is then described in detail, including its purpose and the experimental parameters for reproducibility. Finally, the results are interpreted and discussed.


#jens[present better]

#specs

All experiments were performed on the same laptop, featuring a #specs.cpu CPU, #specs.ram RAM, and running the #specs.distro Linux distribution with kernel version #specs.kernel. Although the computational capabilities of the machine should not influence the results, these specifications are provided for completeness and transparency.

#include "./metrics.typ"
#include "./scenarios.typ"
#include "./study-1.typ"
#include "./study-2.typ"
#include "./study-3.typ"
#include "./study-4.typ"
