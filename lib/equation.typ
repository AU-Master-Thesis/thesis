#let as-set(xs) = eval("${ " + xs.map(str).join(", ") + " }$")
#let as-list(xs) = eval("$[ " + xs.map(str).join(", ") + " ]$")
