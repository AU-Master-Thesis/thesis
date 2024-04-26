#import "../../lib.typ": *
== Study 1: Reproduction <s.r.study-1>

=== Experiment Setup


==== Circle Environment

#{
  // "todo cell"
  let tdc = table.cell.with(fill: red.lighten(50%))
  set align(center)
  table(
    columns: (1fr, 1fr),
    table.header([Param], [Value]),
    table.hline(),
    [$Delta_T$], [$0.1 s$],
    tdc[$M_R$], tdc[$10$],
    tdc[$M_I$], tdc[$50$],
    // [$sigma_d$], [$0.1$ #note.k[not stated explicitly in the paper, but all their configs in the repo uses 0.1]],
    [$sigma_d$], [$1 m$],
    [$sigma_p$], [$1 times 10^(-15)$],
    [$sigma_r$], [$0.005$],
    [$sigma_o$], [$0.005$],
    [$C_("radius")$], [$50 m$],
    tdc[$r_R$], tdc[randomly sampled from $cal(U)(2,3) m$],
  [Initial speed], [$15 " " m "/" s$],
  [$N_R$], [${5, 10, 15, 20, 25, 30, 35, 40, 45, 50}$]
)
}

/ $M_I$ : Internal #acr("GBP") messages
/ $M_R$ : External inter-robot #acr("GBP") messages
/ $N_R$ : Number of robots
/ $r_R$ : Robot radius


==== Junction Environment
