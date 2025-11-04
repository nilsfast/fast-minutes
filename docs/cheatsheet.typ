// Printable overview of all snippets, generated from .vscode/fast-minutes.code-snippets
// typst compile --root . docs/cheatsheet.typ

#set page(paper: "a4", flipped: true, margin: 1.2cm, columns: 2)
#set columns(gutter: 1cm)
#set text(font: "Arial", size: 8pt, lang: "de")
#show raw: set text(size: 7.5pt)

#let snippets = json("/.vscode/fast-minutes.code-snippets")

// Snippet-Platzhalter lesbar machen
#let preview(body) = {
  if type(body) == array { body = body.join("\n") }
  body = body
    .replace("$TM_SELECTED_TEXT", "Auswahl")
    .replace("$CURRENT_YEAR", "JJJJ")
    .replace("$CURRENT_MONTH", "MM")
    .replace("$CURRENT_DATE", "TT")
    .replace("$CURRENT_HOUR:$CURRENT_MINUTE", "jetzt")
    .replace(regex("\$\{\d+\|([^|]*)\|\}"), m => "«" + m.captures.at(0).replace(",", " | ") + "»")
    .replace(regex("\$\{\d+:([^}]*)\}"), m => "«" + m.captures.at(0) + "»")
    .replace(regex("\$\d+"), "…")
    .replace(regex(" {2,}"), " ")
    .replace(regex("\n{2,}"), "\n")
    .trim()
  raw(body, block: true)
}

#align(center, text(size: 13pt, weight: "bold")[fast-minutes · Snippets])
#align(center, text(size: 7pt)[«…» = Vorgabe/Auswahl, … = leeres Feld, Tab springt weiter. `#votes[Ja/Nein/Enthaltung/Nicht abgegeben]` -- das vierte Feld ist optional.])
#v(0.3em)

#let rows = ()
#let last = none
#for (key, s) in snippets {
  let (group, name) = key.split(": ")
  if group != last {
    rows.push(table.cell(colspan: 3, fill: luma(225), text(weight: "bold", group)))
    last = group
  }
  let prefix = if type(s.prefix) == array { s.prefix } else { (s.prefix,) }
  rows.push(strong(prefix.map(raw).join(", ")))
  rows.push(name)
  rows.push(preview(s.body))
}

#table(
  columns: (auto, auto, 1fr),
  stroke: (x, y) => (bottom: 0.4pt + luma(200)),
  inset: 4pt,
  table.header([*Kürzel*], [*Snippet*], [*Fügt ein*]),
  ..rows,
)

#text(size: 7pt)[⟨…⟩ = Vorgabe/Auswahl, … = leeres Feld, Tab springt weiter. `#votes[Ja/Nein/Enthaltung/Nicht abgegeben]` -- das vierte Feld ist optional.]
