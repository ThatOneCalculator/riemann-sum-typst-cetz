#import "@preview/cetz:0.1.2": draw

#let riemann(
  fn,
  start: 0,
  end: 10,
  n: 10,
  y-scale: 1,
  domain-offset: 0,
  range-offset: 0,
  hand: "left",
  transparency: 100%,
  dot-radius: 0.055,
  positive-color: color.green,
  negative-color: color.red) = {

    let hand-offset = 0
    let mark-horizontal = "-left"
    if hand == "right" {
      hand-offset = 1
      mark-horizontal = "-right"
    } 
    else if hand == "mid" or hand == "midpoint" {
      hand-offset = 0.5
      mark-horizontal = ""
    }

    let col-trans(color, opacity) = {
      let space = color.space()
      space(..color.components(alpha: false), opacity)
    }

    // Doesn't work if Delta n != 1
    // Should be `for i in range(start, end, step: (end - start)/n).map(...`
    // https://github.com/typst/typst/issues/2908
    for i in range(start, end).map(x => x * n/(end - start)) {
      let height = fn(i + hand-offset)
      let bar-color = positive-color
      let mark-vertical = "top"
      if fn(i) <= 0 {
        bar-color = negative-color
        mark-vertical = "bottom"
      }
      draw.fill(col-trans(
        bar-color.lighten(70%).darken(8%),
        transparency
      ))
      draw.rect(
        (i + domain-offset, range-offset),
        (i + domain-offset + 1, (height/y-scale) + range-offset),
        stroke: col-trans(bar-color.darken(30%), 90%) + 1.1pt,
        name: "r"
      )
      draw.circle(
        "r." + mark-vertical + mark-horizontal,
        radius: dot-radius,
        fill: bar-color
      )
   }
}