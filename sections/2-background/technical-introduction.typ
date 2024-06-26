#import "../../lib/mod.typ": *
== Gaussian Models <s.b.gaussian-models>
// Reasons from @gbp-visual-introduction
// (1) they accurately represent the distribution for many real world events , (2) they have a simple analytic form, (3) complex operations can be expressed with simple formulae and (4) they are closed under marginalization, conditioning and taking products (up to normalization).
// reword these reasons!

// Rewording from Gemini:
// Realistic Modeling: Gaussian models effectively capture the way many physical phenomena and sensor readings are distributed in the real world.
// Mathematical Simplicity: Gaussian models have a clean mathematical structure, making them easy to work with.
// Computational Efficiency: Calculations involving Gaussian models can be performed using straightforward formulas, keeping computations fast.
// Flexibility: Gaussian models maintain their form under common statistical operations (marginalization, conditioning, products), ensuring ease of manipulation within robotic systems.

To eventually understand #acr("GBP"), the underlying theory of Gaussian models is detailed in this section. Gaussian models are often chosen when representing uncertainty due to the following reasons:
#set enum(numbering: req-enum.with(prefix: "Reason ", color: accent))
+ _*Realistic Modeling:*_ Gaussian models effectively capture the way many physical phenomena and sensor readings are distributed in the real world.@gbp-visual-introduction
+ _*Mathematical Simplicity:*_ Gaussian models have a clean mathematical structure, making them easy to work with.@gbp-visual-introduction
+ _*Computational Efficiency:*_ Calculations involving Gaussian models can be performed using straightforward formulas, keeping computations fast.@gbp-visual-introduction
+ _*Flexibility:*_ Gaussian models maintain their form under common statistical operations (marginalization, conditioning, products), ensuring ease of manipulation within robotic systems.@gbp-visual-introduction

// Explain the two ways of representing Gaussian models in  the exponential energy form
// - Moments form
// - Canonical form

// First describe what exponential energy form is
A Gaussian distribution can be represented in the exponential energy form, which is a common way of representing probability distributions. The exponential energy form is defined as in @eq-exponential-energy@gbp-visual-introduction:

$
  p(x) = 1/Z exp(-E(x))
$<eq-exponential-energy>

// #jens[What does $Z$ and $E$ mean?]

// Then describe the two ways of representing Gaussian models in the exponential energy form
// A Gaussian model can be written in two ways; the _moments form_ and the _canonical form_.
In the exponential energy form, a Gaussian model can be represented in two ways; the _moments form_ and the _canonical form_. The moments form is defined by the mean vector, $mu$, and the covariance matrix, $Sigma$@gbp-visual-introduction. The canonical form is defined by the information vector, $eta$, and the precision matrix, $Lambda$. The energy parameters, energy equations, and computational efficiency for certain aspects of the two forms are compared in @f.gaussian-models.

#{
  let title(content) = text(black, weight: 400, content + ":", style: "italic")
  let fc-size = 55%
  let f-size = 1.2em
  set par(first-line-indent: 0em)
  [
    #figure(
      gridx(
        columns: (1fr, 1fr),
        blocked(title: "Moments Form")[
          #set text(size: f-size)
          #v(0.5em)
          #boxed(color: theme.mauve)[*Parameters:*]
          // - Mean vector, #text(theme.mauve, $mu$)
          // - Covariance matrix, #text(theme.mauve,$Sigma$). \ \
          #move(dx: -0.25em, gridx(
            columns: (fc-size, 1fr),
            title("Mean"), text(theme.mauve, $mu$),
            title("Covariance"), text(theme.mauve, $Sigma$)
          ))
          #v(0.5em)

          #boxed(color: theme.yellow)[*Energy Equation:*]
          #v(0.35em)
          $E(x) = 1/2 (x - #text(theme.mauve, $mu$))^top #text(theme.mauve, $Sigma$)^(-1) (x - #text(theme.mauve, $mu$))$ \ \

          #boxed(color: theme.teal)[*Computational Efficiency:*] \
          #move(dx: -0.25em, gridx(
            columns: (fc-size, 1fr),
            title("Marginalization"), [#cost.cheap],
            title("Conditioning"), [#cost.expensive],
            title("Product"), [#cost.expensive]
          ))
          #v(-0.5em)
        ],
        blocked(title: "Canonical Form")[
          #set text(size: f-size)
          #v(0.5em)
          #boxed(color: theme.mauve)[*Parameters:*]
          // - Information vector #text(theme.mauve, $eta = Sigma^-1 mu$)
          // - Precision matrix #text(theme.mauve, $Lambda = Sigma^-1$). \ \

          #move(dx: -0.25em, gridx(
            columns: (fc-size, 1fr),
            title("Information"), [$#text(theme.mauve, $eta$) = #text(theme.mauve, $Sigma$)^(-1)$ #text(theme.mauve, $mu$)],
            title("Precision"), [$#text(theme.mauve, $Lambda$) = #text(theme.mauve, $Sigma$)^(-1)$]
          ))
          #v(0.5em)

          #boxed(color: theme.yellow)[*Energy Equation:*]
          #v(0.35em)
          $E(x) = 1/2 x^top #text(theme.mauve, $Lambda$) x - #text(theme.mauve, $eta$)^top x$ \ \

          #boxed(color: theme.teal)[*Computational Efficiency:*] \

          #move(dx: -0.25em, gridx(
            columns: (fc-size, 1fr),
            title("Marginalization"), [#cost.expensive],
            title("Conditioning"), [#cost.cheap],
            title("Product"), [#cost.cheap]
          ))
          #v(-0.5em)
        ]
      ),
      caption: [Camparison between the moments form and the canonical form of representing Gaussian models.@gbp-visual-introduction]
    )<f.gaussian-models>
  ]
}

As outlined in @f.gaussian-models the #gaussian.canonical is much more computationally efficient when it comes to conditioning and taking products, while the #gaussian.moments excels at marginalization. This is due to the fact that the canonical form is closed under conditioning and taking products, while the moments form is closed under marginalization@gbp-visual-introduction. In the context of factor graphs in software, the #gaussian.moments is often preferred due to its efficiency in marginalization, which is a common operation in factor graph inference@gbp-visual-introduction. Furthermore, the #gaussian.moments is unable to represent unconstrained distributions, as would be yielded by an unanchored factor graph. However, this is not a problem encountered in practice for this thesis, as the factor graphs are anchored. More detail on this in @s.m.factor-graph.

// why is that?

== Probabilistic Inference <s.b.probabilistic-inference>

To contextualize factor graph inference, the underlying probabilistic inference theory is introduced. The goal of probabilistic inference is to estimate the probability distribution of a set of unknown variables, $#m.Xb$, given some observed or known quantities, $#m.D$. This is done by combining prior knowledge with $#m.D$, to infer the most likely distribution of the variables@gbp-visual-introduction. See @ex.probabilistic-inference.

#example(
  caption: [Probabilistic Inference in Meteorology]
)[
  // Everyday example describing how meteorological forecasts are made
  An everyday example of probabilistic inference is in the field of meteorology. Meteorologists use prior knowledge of weather patterns ($#m.D$), combined with observed data to infer the most likely weather forecast for the upcoming days ($#m.Xb$).
]<ex.probabilistic-inference>

// @ex.probabilistic-inference


// Explain bayesian inference
Baye's rule is the foundation of probabilistic inference, and is used to update the probability distribution of a set of variables, $#m.Xb$, given some observed data, $#m.D$. The rule is defined as in @eq-bayes-theorom[Equation]@gbp-visual-introduction:

$
  p(#m.Xb|#m.D) = (p(#m.D|#m.Xb)p(#m.Xb)) / (p(#m.D))
$<eq-bayes-theorom>

This posterior distribution describes our belief of $#m.Xb$, after observing $#m.D$, which can then be used for decision making about possible future states@gbp-visual-introduction. Furthermore, when we have the posterior, properties about $#m.Xb$ can be computed:

#set enum(numbering: req-enum.with(prefix: "Property ", color: theme.green))
+ The most likely state of $#m.Xb $, the #acr("MAP") estimate $#m.Xb _"MAP"$, is the state with the highest probability in the posterior distribution. See @eq-map-estimate@gbp-visual-introduction:

  $
    #m.Xb _"MAP" = "argmax"_#m.Xb p(#m.Xb|D)
  $<eq-map-estimate>

+ The marginal posteriors, summarising our beliefs of individual variables in $#m.Xb $, can be computed by marginalising the posterior distribution, see @eq-marginal-posterior@gbp-visual-introduction, where $#m.Xb \\#m.x _i$ denotes the set difference operation:

  $
    p(#m.Xb _i|D) = sum_(#m.Xb \\ #m.x _i) p(#m.Xb|D)
  $<eq-marginal-posterior>

// The most common methods for probabilistic inference are exact inference and approximate inference.

// #jonas[have not gotten around to rounding this section off]
