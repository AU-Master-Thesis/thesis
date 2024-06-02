#import "../../lib/mod.typ": *

// #todo[solve these fricking frucking reference issues]
// // This section presents the results for #study.H-1.full in @s.r.study-1 and #study.H-2.prefix: #study.H-2.full in @s.r.study-2.

#let specs = (
  cpu:  [12th Gen Intel Core i7-12700H], // `lscpu`
  arch: [64-bit x86-64], // `uname -m`
  ram:  [16GiB SODIMM 4800 MHz], // `sudo lshw -short -C memory`
  OS: [NixOS Linux Kernel 6.6.30], // `uname -r`
)



= Results <s.results>

This section details the experiments conducted to test the hypotheses outlined in @intro-research-hypothesis. It begins by presenting the metrics used for quantitative comparison in #numref(<s.r.metrics>). Each scenario is then described in detail, see @s.r.scenarios, including its purpose and the experimental parameters for reproducibility. Finally, the results are interpreted and discussed.

#let spec-table = [
  #figure(
    {
      show table.cell : it => {
        if it.x == 0 {
          set text(weight: "bold")
          it
        } else {
          it
        }
      }
      tablec(
        columns: 2,
        align: (left, left),
        header: table.header(
          [Type], [Component]
        ),
        ..specs.pairs().map(it => {
          let type = it.at(0)
          let component = it.at(1)

          (titlecase(type), component)
        }).flatten()
      )
    },
    caption: [System specifications for the machine, the experiments have been run on.]
  )<t.specs>
]

#let exp = [
  #h(1em)All experiments were performed on the same laptop, featuring a #specs.cpu CPU, #specs.ram RAM, and running #specs.OS, see @t.specs. Although the computational capabilities of the machine should not influence the results, these specifications are provided for completeness and transparency.]
#v(-0.55em)
#grid(
  columns: (1fr, 14em),
  column-gutter: 1em,
  exp,
  spec-table,
)

#include "./metrics.typ"
#include "./scenarios.typ"
#include "./study-1.typ"
#include "./study-2.typ"
#include "./study-3.typ"
