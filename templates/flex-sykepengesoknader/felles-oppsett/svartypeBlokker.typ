#import "verktoy.typ" : *

#let visSporsmalstekst(sporsmalstekst: none) = [#if (sporsmalstekst!=none) and (sporsmalstekst.contains(" ")) [
        #heading(level: 3)[#sporsmalstekst]
    ]
]

#let checkbox(sporsmal) = [
    #let visSporsmal = []

    #grid(
      columns: (auto, 1fr),
      column-gutter: 8pt,
      align: horizon,
      image("/resources/Checkboks.png", width: 2mm),
      [#sporsmal.at("sporsmalstekst", default: "")],
    )
]

#let radio(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
    #if (svar.len() > 0) and (svar.first().at("verdi")=="CHECKED") [
        #box(image("/resources/Checkboks.png", width: 2mm),baseline: 15%)
        #sporsmal.at("sporsmalstekst", default: "")
    ]
]

#let jaNei(sporsmal, flereInntektskilderGhost: ()) = [

    #if (sporsmal.at("tag", default: "") == "FLERE_INNTEKTSKILDER_GHOST") and (flereInntektskilderGhost.len()!=0) [
        #heading(level: 3)[Andre registrerte arbeidsforhold]
        #for inntektskilde in flereInntektskilderGhost [
            #grid(
                columns: (auto, 1fr),
                column-gutter: 8pt,
                align: horizon,
                image("/resources/arbeidsgiver.svg", width: 4mm),
                box[
                    #text(weight:"bold")[#inntektskilde.at("navn", default: "")]
                    #linebreak()
                    Orgnummer: #inntektskilde.at("orgnummer", default: "")
                ]
            )
        ]
        #linebreak()
    ]

    #let svar = sporsmal.at("svar", default: ())
    #if svar.len()!=0 [
        #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
        #grid(
              columns: (auto, 1fr),
              column-gutter: 8pt,
              align: horizon,
              image("/resources/Checkboks.png", width: 2mm),
              svar.first().at("verdi", default: ""),
        )
    ]
]

#let perioder(sporsmal) = [
    #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
    #let periode = sporsmal.at("svar", default: ())
    #if periode.len()!=0 [
        #for (gjennomgang, svar) in periode.enumerate() [
            #let svarVerdi = periode.first().at("verdi", default: none)
            #let fom = svarVerdi.split("\"fom\"").at(1).split("\"").at(1)
            #let tom = svarVerdi.split("\"tom\"").at(1).split("\"").at(1)
            #text[#formaterDato(fom) - #formaterDato(tom)]
            #if gjennomgang<(periode.len()-1) [#linebreak()]
        ]
    ]
]

#let datoer(sporsmal) = [
    #let periode = sporsmal.at("svar", default: ())
    #if (periode.len()!=0) [
        #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
        #for dato in periode [
            #block[
                #formaterDato(dato.at("verdi", default: none))
            ]
        ]
    ]
]

#let radioGruppeUkekalender(sporsmal) = [
    #let periode = sporsmal.at("svar", default: ())
        #if (periode.len()!=0) [
            #formaterDato(periode.first().at("verdi", default: none))
        ]
]

#let tall(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
    #if svar.len() > 0 [
        #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
        #svar.first().at("verdi")
        #if sporsmal.at("undertekst", default: "") == "prosent" [%]
    ]
]

#let kilometer(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
        #if svar.len() > 0 [
            #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
            #svar.first().at("verdi") km
        ]
]

#let belop(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
        #if svar.len() > 0 [
            #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
            #svar.first().at("verdi") kr
        ]
]

#let sporsmalGruppering(sporsmal) = [
    #if sporsmal.at("sporsmalstekst", default: "")!=none [
        #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
    ]
]

#let vanligTekst(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
    #if svar.len() > 0 [
        #heading(level: 3)[#sporsmal.at("sporsmalstekst", default: none)]
        #svar.first().at("verdi")
    ]
]

#let checkboxPanel(sporsmal) = [
    #if sporsmal.at("sporsmalstekst", default: "")!=none [
        #grid(
            columns: (auto, 1fr),
            column-gutter: 8pt,
            align: horizon,
            image("/resources/checkbox.svg", width: 2mm),
            sporsmal.at("sporsmalstekst", default: "")
        )
    ]
]