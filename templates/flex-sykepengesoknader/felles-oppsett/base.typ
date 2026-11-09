#let oppsett(doc) = {
  set document()
  set text(font: "Source Sans 3", lang: "nb", size: 11pt)
  set page(
    paper: "a4",
    margin: (top: 16.9mm, bottom: 19.6mm, left: 16.9mm, right: 16.9mm),
    footer: context align(right)[
      #text(size: 9pt)[Side #counter(page).display() av #counter(page).final().at(0)]
    ],
    numbering: "1",
    number-align: right
  )
  doc
}

#let soknadHeading(tittel) = [
    #block(
    fill: rgb("#C2EAF7"),
      inset: 8pt,
    )[
        #grid(
          columns: (auto, 1fr),
          column-gutter: 12pt,
          align: (horizon),
          image("/resources/Navlogo.png", width: 22mm, alt: "Nav"),
          align(left)[= #tittel],
        )
    ]
]

#let formaterDato(iso) = {
  if iso == none or iso == "" { return "" }
  let d = iso.slice(0, 10).split("-")
  let dato = datetime(year: int(d.at(0)), month: int(d.at(1)), day: int(d.at(2)))
    .display("[day].[month].[year]")
  if iso.len() >= 16 {
    dato + " kl." + iso.slice(11, 16)
  } else {
    dato
  }
}

#let soknadMottakereBlokk(innsendtDato, innsendtTid, sendtArbeidsgiver) = [
    Sendt til Nav
    #linebreak()
    #formaterDato(innsendtDato)
    #linebreak()
    Sendt til Nav //Må disse hete det samme?
    #linebreak()
    #formaterDato(innsendtTid)
    #linebreak()
    Sendt til Arbeidsgiver
    #linebreak()
    #sendtArbeidsgiver
    #linebreak()
]

#let brukerProfilBlokk(navn, fnr) = [
    #grid(
        columns: (auto, 1fr),
        column-gutter: 12pt,
        align: (horizon),
        image("/resources/Personikon.png", width: 10mm, alt: "Nav"),
        align(left)[
            == #navn
            #fnr
        ],
    )
]

#let soknadsPeriodeBlokk(periode) = [
    #if (periode.at("fom", default: "") != "") [
        === #periode.at("fom") - #periode.at("tom", default: "?")
    ]
    #if periode.at("grad", default: none) != none [
        #periode.at("grad")% sykmeldt
    ]
    #if periode.at("faktiskGrad", default: none) != none [
        #linebreak()
        #text()[
            Oppgitt faktisk arbeidsgrad #periode.at("faktiskGrad")%
        ]
    ]
]

#let sykmeldingSkrevet(sykmeldingUtskrevet) = [
    #heading(level: 3)[Dato sykmeldingen ble skrevet]
    #sykmeldingUtskrevet
]

#let arbeidsgiverBlokk(arbeidsgiver) = [
    #heading(level: 3)[Arbeidsgiver]
    #arbeidsgiver
]

#let egenmeldingBlokk(egenmeldingsdager) = [
    #if egenmeldingsdager.len() > 0 [
        === Egenmeldingsdager
        #for dag in egenmeldingsdager [
            #dag
            #linebreak()
        ]
    ]
]

#let topseksjonen(
    tittel,
    navn,
    fnr,
    innsendtDato,
    innsendtTid,
    sendtArbeidsgiver,
    soknadPerioder,
    sykmeldingUtskrevet,
    arbeidsgiver,
    egenmeldingsdagerFraSykmelding
) = [
    #soknadHeading(tittel)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 12pt,
      brukerProfilBlokk(navn, fnr),
      soknadMottakereBlokk(innsendtDato, innsendtTid, sendtArbeidsgiver),
    )

    #for periode in soknadPerioder [
      #soknadsPeriodeBlokk(periode)
    ]
    #sykmeldingSkrevet(sykmeldingUtskrevet)
    #arbeidsgiverBlokk(arbeidsgiver)
    #egenmeldingBlokk(egenmeldingsdagerFraSykmelding)

]