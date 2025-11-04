#import "@local/fast-minutes:0.0.1": *


#show: minutes.with(
  committee: "Vorstand",
  session: "1. Sitzung des Vorstandes",
  date: datetime(year: 2025, day: 1, month: 10),
  // Set this to 1, 2 or 3 and watch what happens:
  sensitivity: 3, 
  logo: image("capitol.png"),
  agenda: read("agenda.txt"),
  names: toml("names.toml"),
)

#qtable(
  [Sitzungsleitung:],                          n[bs],
  [Schriftführende Person:],                    n[er],
  [Anwesende Personen:],                       [s. Liste],
  [Abwesende Personen:],                       [s. Liste],
  [Anwesende teilnahmeberechtigte Personen:],   [s. Liste],
  [Anwesende hinzugezogene Personen:],          [s. Liste],
  [Sitzungsort:],                              [Büro],
  [Sitzungsform:],                             [Präsenz],
  [Sitzungszeit:],                             [10:30 bis ca. 17:30 Uhr],
)

Anlagen:
+ Anwesenheitsliste 
+ Tagesordnung 

#top("Begrüßung")

#n[bs] begrüßt die anwesenden Mitglieder und eröffnet die Sitzung.

#top("Anträge")

Dem Gremium liegt der Antrag "Beschlussvorlage für neue Mikrowelle" zur Beschlussfassung vor. Der Antrag wurde form- und fristgerecht eingereicht.

Das Gremium berät den vorliegenden Antrag.

#votes[10/0/0/0]

#top("Wahl")

Das Gremium wählt zwei Personen ind den Kontrollausschuss.

#elect(
  "ulf", 8,
  "eri", 2,
  "er", 0,
)

Das Gremium wählt #n[ulf] in den Kontrollausschuss.


#top(4)
#redact[

Dem Gremium liegt der Antrag zur Beschlussfassung eingereicht von #n[ts] vor. Der Antrag wurde form- und fristgerecht eingereicht.

Das Gremium berät den vorliegenden Antrag.

Das Gremium stimmt über den vorliegenden Antrag ab:

#votes[10/0/0/0]

Der Antrag ist damit angenommen.

]

#top("5b")

Keine Themen.

Die Sitzungsleitung schließt die Sitzung.
