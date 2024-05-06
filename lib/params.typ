#import "catppuccin.typ": *
#import "lib.typ": *

#let syms = (
  delta_t: $Delta_t$,
  m_r: $M_R$,
  m_i: $M_I$,
  sigma_d: $sigma_d$,
  sigma_p: $sigma_p$,
  sigma_r: $sigma_r$,
  sigma_o: $sigma_o$,
  radius: $C_("radius")$,
  r_r: $r_R$,
  speed: $abs(v_0)$,
  n_r: $N_R$
)

// let params = (
#let circle = (
  // sim: (
  // ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
    ),
  ),
  env: (
    radius: $50m$,
    r_r: $tilde.op cal(U)(2,3) m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, 15, 20, 25, 30, 35, 40, 45, 50}$
  ),
)

#let clear-circle = (
  // sim: (
  // ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
    ),
  ),
  env: (
    radius: $50m$,
    r_r: $2m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, 15, 20, 25, 30, 35, 40, 45, 50}$
  ),
)

#let junction = (
  // sim: (
  // ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
    ),
  ),
  env: (
    radius: $50m$,
    r_r: $2m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, 15, 20, 25, 30, 35, 40, 45, 50}$
  ),
)

#let make-rows(subdict) = {
  let pair-list = subdict.pairs().filter(it => {
    not type(it.at(1)) == dictionary
  }).map(it => {
    let key = it.at(0)
    let val = it.at(1)
    (syms.at(key), val)
  })

  pair-list.flatten()
}

#let rep(item, n) = range(n).map(_ => item)

#let tabular(subdict, title: none, extra-rows: 0) = {

  let header = table.header(
    [Param], [Value]
  )
  let header-rows = (0,)

  if header != none {
    header-rows = (0, 1)
    header = table.header(
      table.cell(colspan: 2, align: center, title),
      [Param], [Value]
    )
  }

  show table.cell : it => {
    if it.y in header-rows {
      set text(theme.text)
      strong(it)
    } else if calc.even(it.y) {
      set text(theme.text)
      strong(it)
    } else {
      set text(theme.text)
      it
    }
  }

  set align(center)

  cut-block(
    table(
      columns: (1fr, auto),
      align: (x, y) => (left, right).at(x) + horizon,
      stroke: none,
      header,
      fill: (x, y) => if y in (0, 1) {
        theme.lavender.lighten(50%)
      } else if calc.even(y) { theme.crust } else { theme.mantle },
      gutter: -1pt,
      ..make-rows(subdict),
      ..rep((" ", " "), extra-rows).flatten()
    )
  )
}
