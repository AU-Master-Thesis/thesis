#import "template.typ": *
#import "catppuccin.typ": *
#import "note.typ"
#import "text-case.typ": *
#import "@preview/codelst:1.0.0": sourcecode, codelst, sourcefile

#import "@preview/tablex:0.0.6": *
#import "@preview/drafting:0.2.0": *
#import "@preview/cetz:0.2.2": *
// #import "@preview/glossarium:0.3.0": make-glossary, print-glossary, gls, glspl
// #show: make-glossary

#import "@preview/wordometer:0.1.1": word-count, total-words, total-characters
// #show: word-count.with(exclude: (heading.where(level: 1), strike, figure.caption, <no-wc>))

#import "@preview/acrostiche:0.3.1": init-acronyms, print-index, acr, acrpl

// #show: word-count

#let theme = catppuccin.latte
#let accent = theme.lavender
#let colors = (
  variable: theme.maroon,
  factor: theme.lavender,
)

#let hr = line(length: 100%)

#let project-name = "Multi-agent Collaborative Path Planning"

#let authors = ((
  name: "Kristoffer Plagborg Bak Sørensen",
  email: "201908140@post.au.dk",
  auid: "au649525",
), (
  name: "Jens Høigaard Jensen",
  email: "201907928@post.au.dk",
  auid: "au649507",
),).map(author => {
  author + (
    department: [Department of Electrical and Computer Engineering],
    organization: [Aarhus University],
    location: [Aarhus, Denmark],
  )
})

#let a = (
  jens: authors.at(1).name,
  kristoffer: authors.at(0).name,
)

#let std-block = block.with(
  fill: catppuccin.latte.base,
  radius: 1em,
  inset: 0.75em,
  stroke: none,
  width: 100%,
  breakable: true,
)

#let sourcecode = sourcecode.with(frame: std-block, numbers-style: (lno) => move(dy: 1pt, text(
  font: "JetBrains Mono",
  size: 0.75em,
  catppuccin.latte.overlay0.lighten(50%),
  lno,
)))

#let sourcefile = sourcefile.with(frame: std-block, numbers-style: (lno) => move(dy: 1pt, text(
  font: "JetBrains Mono",
  size: 0.75em,
  catppuccin.latte.overlay0.lighten(50%),
  lno,
)))

#let snippet = sourcecode.with(numbering: none, frame: std-block.with(inset: 2pt, radius: 3pt))

#let tablex = tablex.with(stroke: 0.25pt, auto-lines: false, inset: 0.5em)

#let rule = hlinex(stroke: 0.25pt)
#let thick-rule = hlinex(stroke: 0.75pt)
#let double-rule(cols) = (hlinex(), colspanx(cols)[#v(-0.75em)], hlinex(),)

#let boxed(content, color: accent.lighten(0%), fill: none, weight: 400) = {
  if (fill == none) {
    fill = color.lighten(80%)
  }
  box(
    fill: fill,
    radius: 3pt,
    inset: (x: 2pt),
    outset: (y: 2pt),
    text(color, weight: weight, content),
  )
}

// #let list-box(title, content) = {
//   gridx(
//     columns: (1em, 1fr),
//     column-gap: 1pt,
//     [], [#boxed(title) #content],
//   )
//   // v(-3.25em)
// }

#let no-indent(content) = {
  set par(first-line-indent: 0pt)
  content
}

#let remark(txt, color: color.red, prefix: "") = {
  if not "release" in sys.inputs {
    boxed(color: color.lighten(0%), fill: color.lighten(80%), [*#prefix* #txt])
  }

  state("remark" + prefix, 0).update(s => s + 1)
}

#let todo = remark.with(color: theme.maroon, prefix: "Todo: ")
#let jens = remark.with(color: theme.teal, prefix: "Jens: ")
#let yens = remark.with(color: theme.pink, prefix: "Yens: ")
#let kristoffer = remark.with(color: theme.green, prefix: "Kristoffer: ")

#let boxed-enum(
  prefix: "",
  suffix: "",
  delim: ".",
  color: accent.lighten(0%),
  fill: accent.lighten(80%),
  ..numbers,
) = boxed(
  color: color,
  fill: fill,
  prefix + numbers.pos().map(str).join(delim) + delim + suffix,
  weight: 900,
)

#let req-enum(prefix: "R-", color: accent, ..numbers) = boxed(
  color: color,
  fill: color.lighten(80%),
  text(weight: 900, prefix + numbers.pos().map(n => {
    if n < 10 {
      str(n)
    } else {
      str(n)
    }
  }).join(".")),
)

#let vdmpp(text) = raw(text, block: false, lang: "vdmpp")

#let requirement-heading(content) = heading(
  level: 2,
  supplement: "Requirement",
  numbering: none,
  outlined: false,
  content,
)
#let req(content) = {
  boxed(weight: 900)[R-#content]
  h(0.5em)
}

#let abstraction-counter = counter("abstraction-counter")

#let abstraction-id = {
  abstraction-counter.step()
  boxed("A" + abstraction-counter.display(), weight: 900)
}

#let cy(content) = text(catppuccin.latte.yellow, content)
#let cr(content) = text(catppuccin.latte.maroon, content)
#let cg(content) = text(catppuccin.latte.green, content)
#let cb(content) = text(catppuccin.latte.lavender, content)
#let cp(content) = text(catppuccin.latte.mauve, content)

#let ra = sym.arrow.r

#let swatch(color, content: none, s: 6pt) = {
  if content != none {
    content
    // h(0.1em)
  }
  h(1pt, weak: true)
  box(
    height: s,
    width: s,
    fill: color,
    // stroke: 1pt + color,
    radius: s / 2,
    baseline: (s - 0.5em) / 2,
  )
}

#let sy = swatch(catppuccin.latte.yellow)
#let sr = swatch(catppuccin.latte.maroon)
#let sg = swatch(catppuccin.latte.green)
#let sb = swatch(catppuccin.latte.blue)
#let sp = swatch(catppuccin.latte.mauve)
#let sgr = swatch(catppuccin.latte.surface0)
#let sl = swatch(catppuccin.latte.lavender)

#let nameref(label, name, supplement: none) = {
  show link : it => text(accent, it)
  link(label, [#ref(label, supplement: supplement). #name])
}

#let numref(label) = ref(label, supplement: none)

#let scen(content) = boxed(color: catppuccin.latte.yellow, content)

#let toc-printer(target: none) = {
  set par(first-line-indent: 0em)
  outline(
    indent: 2em,
    // fill: repeat("_"),
    fill: grid(
      // column-gutter:
      columns: 1,
      block(fill: black, height: 0.5pt, width: 100%),
    ),
    depth: 2,
    target: target,
    title: none,
  )
}

#let hline-with-gradient(cmap: color.map.inferno, height: 2pt) = rect(width: 100%, height: height, fill: gradient.linear(..cmap))

#let merge(..dicts) = {
  dicts.pos().fold((:), (acc, dict) => {
    for (k, v) in dict {
      acc.insert(k, v)
    }
    acc
  })
}

#let important-datetimes = (project: (
  start: datetime(day: 29, month: 01, year: 2024),
  end: datetime(day: 04, month: 06, year: 2024),
))

#let plural(word, n) = if n <= 1 {
  word
} else {
  word + "s"
}

#let as-string(any) = {
    if type(any) == "string" {
        any
    } else if type(any) == "content" {
        let repr_any = repr(any)
        repr_any.slice(1, repr_any.len() - 1) // remove square brackets
    } else {
        str(any)
    }
}

#let plural-alt(s) = {
    let s = as-string(s)
    if s.ends-with("s") {
        // plural
        s + "es"
    } else {
        // singular
        s + "s"
    }
}

#let possessive(s) = {
    let s = as-string(s)
    if s.ends-with("s") {
        // plural
        s + "s"
    } else {
        // singular
        s + "'s"
    }
}

// Format a string | content as Title Case
#let titlecase(text) = {
    let string = if type(text) == "string" {
        text
    } else if type(text) == "content" {
        repr(text).slice(1,-1) // remove square brackets
    } else {
        panic("Invalid type for text. Valid types are 'string' | 'content'")
    }

    string.split(" ").map(word => {
        let chars = word.split("")
        (
            upper(chars.at(1)),
            ..chars.slice(2, -1)
        ).join("") // join into a string again
    }).join(" ") // join into a sentence again
}

#let repo(org: none, repo: none) = {
    if (repo == none) {
        panic("Name is required for repo")
    }
    if (org == none) {
        raw(repo)
    }
    raw((org, repo).join("/"), block: false)
}

#let release() = {
  return "release" in sys.inputs and sys.inputs.release == "true"
}

#let stats() = {
  if release() {
    return
  }
  locate(loc => {
    let words = state("total-words").final(loc)
    let chars = state("total-characters").final(loc) + words * 0.8
    let normal-pages = chars / 2400

    let total-pages = 100
    let people = 2

    let total-days = important-datetimes.project.end - important-datetimes.project.start
    let days-left = important-datetimes.project.end - datetime.today()

    let pages-person-day = (total-pages - normal-pages) / (people * days-left).days()

    set text(size: 10pt, font: "JetBrainsMono NF")
    set par(first-line-indent: 0em)
    set align(center)

    tablex(
      columns: (auto, auto),
      align: (left, right),
      [*words*], [#words],
      [*characters*], [#calc.round(chars, digits: 0)],
      [*normal pages*], [#calc.round(normal-pages, digits: 2)],
      rule,
      [*goal pages*], [#total-pages],
      [*goal characters*], [#(total-pages * 2400)],
      [*pp./person/day*], [#calc.round(pages-person-day, digits: 2)],
      [*days left*], [#days-left.days()],
    )

    let colors = (
      complete: catppuccin.latte.lavender,
      incomplete: catppuccin.latte.maroon,
    )
    let progress = normal-pages / total-pages * 100%
    let progress-left = 100% - progress

    grid(
      column-gutter: 0pt,
      columns: (progress, 1fr),
      row-gutter: 5pt,
      text(colors.complete, [#repr(progress) (#calc.round(normal-pages, digits: 2) pages)]),
      text(colors.incomplete, [#repr(progress-left) (#calc.round(total-pages - normal-pages, digits: 2) pages)]),
      box(height: 1em, width: 100%, fill: colors.complete),
      box(height: 1em, width: 100%, fill: colors.incomplete),
    )

    let days-gone = total-days.days() - days-left.days()
    let days-left-percent = days-left.days() / total-days.days() * 100%
    grid(
      column-gutter: 0pt,
      columns: (1fr, days-left-percent),
      row-gutter: 5pt,
      text(colors.incomplete, [#repr(100% - days-left-percent) (#days-gone days)]),
      text(colors.complete, [#repr(days-left-percent) (#days-left.days() days)]),
      box(height: 1em, width: 100%, fill: colors.incomplete),
      box(height: 1em, width: 100%, fill: colors.complete),
    )

    let t = state("remark" + "Todo: ").final(loc)
    let j = state("remark" + "Jens: ").final(loc)
    let k = state("remark" + "Kristoffer: ").final(loc)
    let total = 0 + t + j + k

    let columns = ()
    let texts = ()
    let boxes = ()

    if t != none {
      columns.push(t)
      texts.push(text(theme.maroon, [#t todo]))
      boxes.push(box(height: 1em, width: 100%, fill: theme.maroon))
    }
      if j != none {
      columns.push(j)
      texts.push(text(theme.teal, [#j Jens]))
      boxes.push(box(height: 1em, width: 100%, fill: theme.teal))
    }
      if k != none {
      columns.push(k)
      texts.push(text(theme.green, [#k Kristoffer]))
      boxes.push(box(height: 1em, width: 100%, fill: theme.green))
    }

    v(1em)

    grid(
      column-gutter: 0pt,
      columns: columns.map(v => v / total * 100%),
      row-gutter: 5pt,
      ..texts,
      ..boxes,
    )

    align(center, [#total *#plural("remark", total)*])
  })
}

#let print-index(level: 1, outlined: false, sorted: "", title: "Acronyms Index", delimiter:":") = {
  //Print an index of all the acronyms and their definitions.
  // Args:
  //   level: level of the heading. Default to 1.
  //   outlined: make the index section outlined. Default to false
  //   sorted: define if and how to sort the acronyms: "up" for alphabetical order, "down" for reverse alphabetical order, "" for no sort (print in the order they are defined). If anything else, sort as "up". Default to ""
  //   title: set the title of the heading. Default to "Acronyms Index". Passing an empty string will result in removing the heading.
  //   delimiter: String to place after the acronym in the list. Defaults to ":"

  // assert on input values to avoid cryptic error messages
  assert(sorted in ("","up","down"), message:"Sorted must be a string either \"\", \"up\" or \"down\"")

  if title != ""{
    heading(level: level, outlined: outlined)[#title]
  }

  state("acronyms",none).display(acronyms=>{

    // Build acronym list
    let acr-list = acronyms.keys()

    // order list depending on the sorted argument
    if sorted!="down"{
      acr-list = acr-list.sorted()
    }else{
      acr-list = acr-list.sorted().rev()
    }

    // print the acronyms
    for acr in acr-list{
      let acr-long = acronyms.at(acr)
      let acr-long = if type(acr-long) == array {
        acr-long.at(0)
      } else {acr-long}
      table(
        columns: (1fr, 10fr),
        column-gutter: 1em,
        align: (right, left),
        stroke: none,
        inset: 0pt,
        [*#acr#delimiter*], [#acr-long\ ]
      )
    }
  })
}

#let node(color, content, rounding: 50%, size: 4mm) = {
  let width = if (repr(content).len() - 2) > 1 { 0pt } else { 1.5pt };
  h(5pt)
  // block(
    box(
      fill: color.lighten(90%),
      stroke: 1pt + color,
      outset: (x: size / 2, y: size / 2),
      inset: (y: -size / 4),
      radius: rounding,
      baseline: -size / 4,
      height: 0pt,
      width: 0pt,
      align(
        center,
        text(
          catppuccin.latte.text,
          size: 0.5em,
          weight: "bold",
          font: "JetBrains Mono",
          content
        )
      )
    )
  // )
  h(5pt)
}

#let variable(color, content) = {
  node(color, content)
}

#let factor(color, content) = {
  node(color, content, rounding: 5%, size: 1.25mm)
}

#let example-counter = counter("example")
#let example-box(number) = boxed(color: accent)[*Example #number:*]

#let example(body) = std-block[
  #example-counter.step()
  #example-box(context example-counter.get().at(0))
  #body
]


#let H(n) = [Hypothesis #boxed(color: theme.lavender)[*H-#n*]]
#let RQ(n) = [Research Question #boxed(color: theme.lavender)[*RQ-#n*]]
#let O(n) = [Objective #boxed(color: theme.lavender)[*O-#n*]]

#let study = (
  H-1: (
    prefix: [_*Study 1*_],
    name: [_*Reproduction*_],
    full: [_*Study 1: Reproduction*_],
  ),
  H-2: (
    prefix: [_*Study 2*_],
    name: [_*Extension*_],
    full: [_*Study 2: Extension*_],
  ),
)

#let step = (
  s1: boxed(color: colors.variable)[*Step 1*],
  s2: boxed(color: colors.variable)[*Step 2*],
  s3: boxed(color: colors.factor)[*Step 3*],
  s4: boxed(color: colors.factor)[*Step 4*],
)

#let iteration = (
  // factor: boxed(color: colors.factor)[*Factor Iteration*],
  // variable: boxed(color: colors.variable)[*Variable Iteration*],
  factor: text(colors.factor, "Factor Iteration"),
  variable: text(colors.variable, "Variable Iteration"),
)


#let blocked(title: none, content) = std-block[
  #v(0.25em)
  #text(theme.text, size: 1.2em, weight: 900, title)

  #move(dx: -0.75em, dy: 0pt, line(length: 100% + 2 * 0.75em, stroke: white + 2pt))

  #content

  #v(0.5em)
]

#let cost = (
  cheap: " " + sg + " " + text(theme.green, style: "italic", "Cheap"),
  expensive: " " + sr + " " + text(theme.maroon, style: "italic", "Expensive"),
)

#let algorithm-counter = counter("algorithm")

#let algorithm(
    content,
    caption: none,
    numbering: "1.",
    supplement: "Algorithm",
) = {
    algorithm-counter.step()
    // show regex("^\/\/.*"): it => raw(it)
    set par(first-line-indent: 0em)
    tablex(
        columns: (5%, 95%),
        auto-lines: false,
        stroke: 0.5pt,
        if caption != none {hlinex()},
        if caption != none {
            colspanx(2, [*#supplement #algorithm-counter.display():* #caption])
        },
        hlinex(),
        [], [#content],
        hlinex(),
    )
}
