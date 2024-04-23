#let catppuccin = {
  let _catppuccin = (
    latte: (
      rosewater: color.rgb(220, 138, 120),
      flamingo: color.rgb(221, 120, 120),
      pink: color.rgb(234, 118, 203),
      mauve: color.rgb(136, 57, 239),
      red: color.rgb(210, 15, 57),
      maroon: color.rgb(230, 69, 83),
      peach: color.rgb(254, 100, 11),
      yellow: color.rgb(223, 142, 29),
      green: color.rgb(64, 160, 43),
      teal: color.rgb(23, 146, 153),
      sky: color.rgb(4, 165, 229),
      sapphire: color.rgb(32, 159, 181),
      blue: color.rgb(30, 102, 245),
      lavender: color.rgb(114, 135, 253),
      text: color.rgb(76, 79, 105),
      subtext1: color.rgb(92, 95, 119),
      subtext0: color.rgb(108, 111, 133),
      overlay2: color.rgb(124, 127, 147),
      overlay1: color.rgb(140, 143, 161),
      overlay0: color.rgb(156, 160, 176),
      surface2: color.rgb(172, 176, 190),
      surface1: color.rgb(188, 192, 204),
      surface0: color.rgb(204, 208, 218),
      base: color.rgb(239, 241, 245),
      mantle: color.rgb(230, 233, 239),
      crust: color.rgb(220, 224, 232),
    ),
    frappe: (
      rosewater: color.rgb(242, 213, 207),
      flamingo: color.rgb(238, 190, 190),
      pink: color.rgb(244, 184, 228),
      mauve: color.rgb(202, 158, 230),
      red: color.rgb(231, 130, 132),
      maroon: color.rgb(234, 153, 156),
      peach: color.rgb(239, 159, 118),
      yellow: color.rgb(229, 200, 144),
      green: color.rgb(166, 209, 137),
      teal: color.rgb(129, 200, 190),
      sky: color.rgb(153, 209, 219),
      sapphire: color.rgb(133, 193, 220),
      blue: color.rgb(140, 170, 238),
      lavender: color.rgb(186, 187, 241),
      text: color.rgb(198, 208, 245),
      subtext1: color.rgb(181, 191, 226),
      subtext0: color.rgb(165, 173, 206),
      overlay2: color.rgb(148, 156, 187),
      overlay1: color.rgb(131, 139, 167),
      overlay0: color.rgb(115, 121, 148),
      surface2: color.rgb(98, 104, 128),
      surface1: color.rgb(81, 87, 109),
      surface0: color.rgb(65, 69, 89),
      base: color.rgb(48, 52, 70),
      mantle: color.rgb(41, 44, 60),
      crust: color.rgb(35, 38, 52),
    ),
    macchiato: (
      rosewater: color.rgb(244, 219, 214),
      flamingo: color.rgb(240, 198, 198),
      pink: color.rgb(245, 189, 230),
      mauve: color.rgb(198, 160, 246),
      red: color.rgb(237, 135, 150),
      maroon: color.rgb(238, 153, 160),
      peach: color.rgb(245, 169, 127),
      yellow: color.rgb(238, 212, 159),
      green: color.rgb(166, 218, 149),
      teal: color.rgb(139, 213, 202),
      sky: color.rgb(145, 215, 227),
      sapphire: color.rgb(125, 196, 228),
      blue: color.rgb(138, 173, 244),
      lavender: color.rgb(183, 189, 248),
      text: color.rgb(202, 211, 245),
      subtext1: color.rgb(184, 192, 224),
      subtext0: color.rgb(165, 173, 203),
      overlay2: color.rgb(147, 154, 183),
      overlay1: color.rgb(128, 135, 162),
      overlay0: color.rgb(110, 115, 141),
      surface2: color.rgb(91, 96, 120),
      surface1: color.rgb(73, 77, 100),
      surface0: color.rgb(54, 58, 79),
      base: color.rgb(36, 39, 58),
      mantle: color.rgb(30, 32, 48),
      crust: color.rgb(24, 25, 38),
    ),
    mocha: (
      rosewater: color.rgb(245, 224, 220),
      flamingo: color.rgb(242, 205, 205),
      pink: color.rgb(245, 194, 231),
      mauve: color.rgb(203, 166, 247),
      red: color.rgb(243, 139, 168),
      maroon: color.rgb(235, 160, 172),
      peach: color.rgb(250, 179, 135),
      yellow: color.rgb(249, 226, 175),
      green: color.rgb(166, 227, 161),
      teal: color.rgb(148, 226, 213),
      sky: color.rgb(137, 220, 235),
      sapphire: color.rgb(116, 199, 236),
      blue: color.rgb(137, 180, 250),
      lavender: color.rgb(180, 190, 254),
      text: color.rgb(205, 214, 244),
      subtext1: color.rgb(186, 194, 222),
      subtext0: color.rgb(166, 173, 200),
      overlay2: color.rgb(147, 153, 178),
      overlay1: color.rgb(127, 132, 156),
      overlay0: color.rgb(108, 112, 134),
      surface2: color.rgb(88, 91, 112),
      surface1: color.rgb(69, 71, 90),
      surface0: color.rgb(49, 50, 68),
      base: color.rgb(30, 30, 46),
      mantle: color.rgb(24, 24, 37),
      crust: color.rgb(17, 17, 27),
    ),
  )

  let default = "latte"

  let input = if "catppuccin" in sys.inputs { sys.inputs.catppuccin } else { default }
  if not input in _catppuccin {
    panic(theme + " is not a valid theme, valid themes are: " + catppuccin.keys().join(", "))
  }
  
  let theme = _catppuccin.at(input, default: default)
  
  // let theme = _catppuccin.at(input, default: "latte")
  // if theme == none {
  //   panic(theme + " is not a valid theme, valid themes are: " + catppuccin.keys().join(", "))
  // }

  _catppuccin.insert("theme", theme)
  _catppuccin
}

