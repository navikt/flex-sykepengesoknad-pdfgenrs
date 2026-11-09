#let checkbox(sporsmal) = [

    #let visSporsmal = [
    ]

    #box(image("/resources/Checkboks.png", width: 2mm),baseline: 15%)
    #sporsmal.at("sporsmalstekst", default: "")
]

#let jaNei(sporsmal) = [
    #heading(level: 3)[#sporsmal.at("sporsmalstekst", default:"")]
    #box(
        image("/resources/Checkboks.png", width: 2mm),
        baseline: 15%
    )
    #sporsmal.at("svar", default: ()).first().at("verdi")
]

#let checkboxGruppe(sporsmal) = []

#let periode(sporsmal) = [
    #let periode = 0 //json(bytes(sporsmal.at("verdi")))
    #let fom = 0//periode.at("fom", default: "")
    #let tom = 0//periode.at("tom", default: "")

]

#let vurderSporsmal(sporsmal, hakkInnover: 0) = [

    #let svartyper = (
    "CHECKBOX": checkbox,
    "JA_NEI": jaNei,
    //"RADIO":none,
    "CHECKBOX_GRUPPE": checkboxGruppe,
    "PERIODE": periode,
    )
    #pad(left: hakkInnover * 12pt)[
        #svartyper.at(sporsmal.at("svartype", default: ""), default: s => [])(sporsmal)
    ]
]

#let sporsmalBlokk(sporsmalene) = [
    #for sporsmal in sporsmalene [

        #block(
            stroke: (bottom: 0.5pt + gray),
            inset: (bottom: 6pt),
            width: 100%
        )[
            #vurderSporsmal(sporsmal)

            #let undersporsmalBlokk(sporsmal, nivaa: 1) = {

                let undersporsmal = sporsmal.at("undersporsmal", default: ())

                if (undersporsmal != none) {
                    for underUnderSporsmal in undersporsmal {
                        vurderSporsmal(underUnderSporsmal, hakkInnover: nivaa)
                        undersporsmalBlokk(underUnderSporsmal, nivaa: nivaa + 1)
                    }
                }
            }
            #undersporsmalBlokk(sporsmal)
        ]
    ]
]