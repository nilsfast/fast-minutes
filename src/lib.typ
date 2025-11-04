

#let s = state("sensitivity", 0)
#let names-s = state("names", (:))
#let agenda-s = state("agenda", ())

// author: GeorgeMuscat
#let redact(body) = {
  context {
    if s.get() > 1 {
      show text: it => {
        box(rect(fill: black, height: 1em)[#hide(it)])
      }
      body
    } else {
      body
    }
  }

}

// Abkürzungen aus names.toml werden zum vollen Namen aufgelöst: #n[bs] -> Bernd Stromberg
#let n(text) = {
  context {
    let key = if type(text) == str { text } else if text.has("text") { text.text }
    // für typst query "<n>": wer wird auf welcher Seite genannt
    [#metadata((name: key, page: here().page())) <n>]
    let name = if s.get() > 2 { [_Name Zensiert_] } else { names-s.get().at(key, default: text) }
    // typst compile --input check=bs: Nennungen von bs markieren
    if sys.inputs.at("check", default: none) == key { highlight(name) } else { [#name] }
  }
}

#let agendaitem(title) = {
  // split name into number and title
  let parts = title.split(" ")
  let number = parts.at(0)
  let name = parts.slice(1).join(" ")

  [== TOP #box(number, width: 2em)  #name]
}

// TOP aus agenda.txt per Nummer oder Teil des Titels: #top("Wahl"), #top(3)
#let top(query) = context {
  let q = lower(str(query))
  let items = agenda-s.get()
  let item = items.find(it => lower(it.at(0)) == q)
  if item == none { item = items.find(it => lower(it.at(1)).contains(q)) }
  assert(item != none, message: "TOP nicht in agenda.txt: " + str(query))
  agendaitem(item.join(" "))
}

#let qtable(..cells) = {
  table(
    columns: 2,
    stroke: none,
    inset: (
      top: 0.5em,
      bottom: 0.5em,
      left: 0em,
      right: 1.5em
    ),
    align: (left, left),
    ..cells,
  )
}

#let part(body) = {
  set text(size: 14pt)
  h(0.5em);
  align(center, [*#body*])
  h(0.5em);
}

#let elect(..cells) = {

  let result-cells = ()

  for c in cells.pos() {
    if type(c) == int {
      result-cells.push([#c])
      result-cells.push([Stimmen]) 
    } else {
      result-cells.push([#n(c):]) 
    }
  }
  table(
    columns: 3,
    stroke: none,
    inset: (
      top: 0.5em,
      bottom: 0.5em,
      left: 0em,
      right: 1em
    ),
    align: (left, right, left),
    ..result-cells,
  )
}

#let votes(text) = {
  let votes = text.fields().at("text").split("/")
  let cells = []

  if votes.len() >= 3 {
    cells = ([Zustimmung:],[#votes.at(0)],[Stimmen],
    [Ablehnung:],[#votes.at(1)],[Stimmen],
    [Enthaltung:],[#votes.at(2)],[Stimmen])
  }

  if votes.len() == 4 {
    cells.push(
      ([Nicht abgegeben:], [#votes.at(3)], [Stimmen])
    )
    cells = cells.flatten()
  }
  table(
    columns: 3,
    stroke: none,
    inset: (
      top: 0.5em,
      bottom: 0.5em,
      left: 0em,
      right: 1em
    ),
    align: (left, right, left),
    ..cells
  )
}

#let minutes(
  committee: none,
  session: none,
  date: none,
  sensitivity: none,
  /* 1:  Alles sichtbar
     2:  Nicht-öffentliches geschwärtz
     3.  Nicht-öffentliches geschwärtz + Namen Anonymisiert */
  logo: none,
  agenda: none, // read("agenda.txt"): eine Zeile pro TOP, "Nummer Titel"
  names: none,  // toml("names.toml"): abkürzung = "Voller Name"
  body,
) = {
  // Set and show rules from before.
  s.update(sensitivity)
  assert(names == none or type(names) == dictionary, message: "names: toml(\"names.toml\") statt \"names.toml\" verwenden")
  assert(agenda == none or not agenda.ends-with(".txt"), message: "agenda: read(\"agenda.txt\") statt \"agenda.txt\" verwenden")
  if names != none { names-s.update(names) }
  if agenda != none {
    agenda-s.update(agenda.split("\n").map(str.trim).filter(l => l != "").map(l => {
      let (nr, ..title) = l.split(" ")
      (nr, title.join(" "))
    }))
  }
  
  let header = pad(y: 1cm, align(right, logo))
  
  let margin = 2.5cm // for other sides

  set page(
      margin: (top: 4.7cm, rest: margin),
      header: header,
      header-ascent: 0pt,
      number-align: right, 
      numbering: "1/1",
    )
  
  set text(
    font:"Arial", 
    size: 11pt
  )

  show heading: it => [
     #it #v(0.2em)
  ]

  show heading: set text(weight: "regular", size: 16pt)

  set par(
    justify: true,
    leading: 0.62em,
    spacing: 1.2em  
    )

  [= Niederschrift
  der #session am #date.display("[day].[month].[year]")
  ]

  // typst compile --input check=bs: klickbare Übersicht der TOPs, in denen bs genannt wird
  let check = sys.inputs.at("check", default: none)
  if check != none {
    block(fill: yellow.lighten(60%), inset: 1em, width: 100%, context {
      [*Nennungen von #names-s.get().at(check, default: check)*]
      let tops = query(<n>).filter(m => m.value.name == check).map(m => {
        let h = query(heading.where(level: 2).before(m.location()))
        if h.len() > 0 { h.last() } else { m }
      }).dedup(key: e => e.location().position())
      for t in tops {
        let label = if t.func() == heading { t.body } else [Sitzungsdaten]
        linebreak()
        link(t.location())[#label #box(width: 1fr, repeat[.]) S. #t.location().page()]
      }
    })
  }


  body
}


// Inhaltsübersicht aller TOPs: #inhalt()
#let inhalt(title: [Inhalt]) = outline(title: title, target: heading.where(level: 2))
