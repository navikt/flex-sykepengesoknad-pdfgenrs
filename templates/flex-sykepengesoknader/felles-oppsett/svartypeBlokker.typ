#import "verktoy.typ" : *

#let visSporsmalstekst(sporsmalstekst: none) = [#if sporsmalstekst!=none [
        #heading(level: 3)[#sporsmalstekst]
    ]
]

#let checkbox(sporsmal) = [
    #let visSporsmal = []
    #box(image("/resources/Checkboks.png", width: 2mm),baseline: 15%)
    #sporsmal.at("sporsmalstekst", default: "")
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

    #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
    #box(
        image("/resources/Checkboks.png", width: 2mm),
        baseline: 15%
    )
    #sporsmal.at("svar", default: ()).first().at("verdi")
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

#let dato(sporsmal) = [
    #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
    #let periode = sporsmal.at("svar", default: ())
    #if periode.len()!=0 [#formaterDato(periode.first().at("verdi", default: none))]
]

#let tall(sporsmal) = [
    #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
    #let svar = sporsmal.at("svar", default: ())
    #if svar.len() > 0 [
        #svar.first().at("verdi")
        #if sporsmal.at("undertekst", default: "") == "prosent" [%]
    ]
]

#let sporsmalGruppering(sporsmal) = [
    #visSporsmalstekst(sporsmalstekst: sporsmal.at("sporsmalstekst", default: none))
]

#let vanligTekst(sporsmal) = [
    #let svar = sporsmal.at("svar", default: ())
    #if svar.len() > 0 [
        #heading(level: 3)[#sporsmal.at("sporsmalstekst", default: none)]
        #svar.first().at("verdi")
    ]
]
