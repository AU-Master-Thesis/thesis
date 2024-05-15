#import "catppuccin.typ": *
#import "lib.typ": *
#import "diff.typ": diffdict
#import "dict.typ": leafmap, leafzip, leafflatten
#import "equation.typ"


#let seeds = (0, 31, 227, 252, 805)


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
  n_r: $N_R$,
  s: $s e e d$,
  comms-radius: $r_C$,
  comms-failure-prob: $gamma$,
  variable-temporal-dist: $t_(K-1)$,
  interrobot-safety-distance: $d_r$,
  variables: $|V|$,
)

// let params = (
#let circle = (
  // sim: (
  // ),
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
      interrobot-safety-distance: $2.2 C_("radius")$,
    ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    // S_r: $2.2$,
    comms-failure-prob: $0%$,
    // variable-temporal-dist: {let v = 2 * 50 / 15; $#v$},
    // variable-temporal-dist: $6.67s^*$, // 2 * 50m / 15m/s
    variable-temporal-dist: $13.33s^*$, // 2 * 50m / 15m/s
  variables: todo[...],
  ),
  env: (
    radius: $50m$,
    r_r: $tilde.op cal(U)(2,3) m$,
    comms-radius: $50m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, ..., 50}$,

    // s: $2^*$,
  s: equation.as-set(seeds),
  ),
)

#let clear-circle = (
  // sim: (
  // ),
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
      interrobot-safety-distance: $2.2 C_("radius")$,
    ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    // S_r: $2.2$,
    comms-failure-prob: $0%$,
    // variable-temporal-dist: todo[...],
    // variable-temporal-dist: $6.67s^*$, // 2 * 50m / 15m/s
    variable-temporal-dist: $13.33s^*$, // 2 * 50m / 15m/s
    variables: todo[...],
  ),
  env: (
    radius: $50m$,
    r_r: $tilde.op cal(U)(2,3) m$,
    comms-radius: $50m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, ..., 50}$,
    // s: $2^*$,
  s: equation.as-set(seeds),
  ),
)


#let varying-network-connectivity = (
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
      interrobot-safety-distance: $2.2 C_("radius")$,
    ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    // S_r: $2.2$,
    comms-failure-prob: $0%$,
    // variable-temporal-dist: todo[...],
    // variable-temporal-dist: $6.67s^*$, // 2 * 50m / 15m/s
    variable-temporal-dist: $13.33s^*$, // 2 * 50m / 15m/s
    variables: todo[...],
  ),
  env: (
    radius: $100m$,
    r_r: $tilde.op cal(U)(2,3) m$,
    comms-radius: ${20, 40, ..., 80}m$,
    speed: $15m"/"s$,
    n_r: $30$,
    // s: ${0, 32, 64, 128, 255}^*$,
  s: equation.as-set(seeds),
  ),
)



#let junction = (
  // sim: (
  // ),
    factor: (
      sigma_d: $0.5$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
      interrobot-safety-distance: $2.2 C_("radius")$,
    ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    // S_r: $2.2$,
    comms-failure-prob: $0%$,
    variable-temporal-dist: $2s$,
    variables: todo[...],
  ),
  env: (
    radius: $N "/" A$,
    r_r: $2m$,
    comms-radius: $50m$,
    speed: $15m"/"s$,
    n_r: ${5, 10, ..., 50}$,
    // s: $2^*$,
  s: equation.as-set(seeds),
  ),
)

#let communications-failure = (
  // sim: (
  // ),
    factor: (
      sigma_d: $1$,
      sigma_p: $1 times 10^(-15)$,
      sigma_r: $0.005$,
      sigma_o: $0.005$,
      interrobot-safety-distance: $2.2 C_("radius")$,
    ),
  gbp: (
    delta_t: $0.1$,
    m_r: $10$,
    m_i: $50$,
    comms-failure-prob: ${0, 10, ..., 90}%$,
    // variable-temporal-dist: todo[...],
    // variable-temporal-dist: $6.67s^*$, // 2 * 50m / 15m/s
    variable-temporal-dist: $13.33s^*$, // 2 * 50m / 15m/s
    variables: todo[...],
    // S_r: $2.2$,
  ),
  env: (
    radius: $50m$,
    r_r: $tilde.op cal(U)(2,3) m$,
    comms-radius: $50m$,
    n_r: $21$,
    speed: ${10, 15}m"/"s$,
    // s: ${0, 32, 64, 128, 255}^*$,
  s: equation.as-set(seeds),
  ),
)



#let make-rows(subdict, previous: none) = {
  let diff = if previous == none {
    leafmap(subdict, (k, v) => false) } else {
    diffdict(previous, subdict)
  }

  assert(type(diff) == dictionary, message: "expected `diff` to have type 'dictionary', got " + type(diff))

  let dict = leafzip(subdict, diff)
  let dict_flattened = leafflatten(dict)
  for (k, pair) in dict_flattened {
    let v = pair.at(0)
    let different = pair.at(1)

    let k = syms.at(k)
    if different {
      (k, text(theme.red, v))
    } else {
      (k, v)
    }
  }

  // let pair-list = subdict.pairs().filter(it => {
  //   not type(it.at(1)) == dictionary
  // }).map(it => {
  //   let key = it.at(0)
  //   let val = it.at(1)
  //   (syms.at(key), val)
  // })
  //
  // pair-list.flatten()
}

#let tabular(subdict, title: none, extra-rows: 0, previous: none) = {
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
      ..make-rows(subdict, previous: previous),
      ..rep((" ", " "), extra-rows).flatten()
    )
  )
}
