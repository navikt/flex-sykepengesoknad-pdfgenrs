#import "verktoy.typ": *

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

#let soknadMottakereBlokk(innsendtDato, innsendtTid, sendtArbeidsgiver) = [

    #let visMottakere = (
        (innsendtDato, "Sendt til Nav"),
        (innsendtTid, "Sendt til Nav"),
        (sendtArbeidsgiver, "Sendt til Arbeidsgiver")
    )

    #align(left)[
        #for (verdi, mottaker) in visMottakere [
            #if verdi!=none or verdi!="" [
                #heading(level:3)[#mottaker]
                #formaterDato(verdi)

            ]
        ]
    ]
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
    #if sykmeldingUtskrevet!="" and sykmeldingUtskrevet!=none [
        #heading(level: 3)[Dato sykmeldingen ble skrevet]
        #sykmeldingUtskrevet
    ]
]

#let arbeidsgiverBlokk(arbeidsgiver) = [
    #if arbeidsgiver!="" and arbeidsgiver!=none [
        #heading(level: 3)[Arbeidsgiver]
        #arbeidsgiver
    ]
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