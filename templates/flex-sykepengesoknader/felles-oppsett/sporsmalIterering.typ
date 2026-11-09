#import "svartypeBlokker.typ":*

#let svartyper = (
        "CHECKBOX": (s, ghost) => checkbox(s),
        "CHECKBOX_GRUPPE": (s, ghost) => sporsmalGruppering(s),
        "COMBOBOX_SINGLE": (s, ghost) => vanligTekst(s),
        "DATO": (s, ghost) => dato(s),
        "FRITEKST": (s, ghost) => vanligTekst(s),
        "JA_NEI": (s, ghost) => jaNei(s, flereInntektskilderGhost: ghost),
        "PERIODE": (s, ghost) => perioder(s),
        "PERIODER": (s, ghost) => perioder(s),
        "TALL": (s, ghost) => tall(s),
        "RADIO": (s, ghost) => radio(s),
        "RADIO_GRUPPE": (s, ghost) => sporsmalGruppering(s),
        "RADIO_GRUPPE_TIMER_PROSENT": (s, ghost) => sporsmalGruppering(s),
    )

#let vurderSporsmal(sporsmal, hakkInnover: 0, flereInntektskilderGhost:() ) = [
    #let sporsmalSvartype = sporsmal.at("svartype", default: "")
    #let vis = svartyper.at(sporsmalSvartype, default: (s, ghost) => [])

    #pad(left: hakkInnover * 12pt)[#vis(sporsmal, flereInntektskilderGhost)]
]

#let vis(sporsmalSvartype) = svartyper.keys().contains(sporsmalSvartype) //97 vises ikke lenger D:

#let sporsmalBlokk(sporsmalene, flereInntektskilderGhost:() ) = [
    #for sporsmal in sporsmalene [
        #block(
            stroke: (bottom: 0.5pt + gray),
            inset: (bottom: 6pt),
            width: 100%
        )[
            #vurderSporsmal(
                sporsmal,
                flereInntektskilderGhost:flereInntektskilderGhost
            )
            #let undersporsmalBlokk(sporsmal, nivaa: 1) = {
                let undersporsmal = sporsmal.at("undersporsmal", default: ())
                if (undersporsmal != none) {
                    for underUnderSporsmal in undersporsmal {
                        if vis(underUnderSporsmal.at("svartype", default: "")) == true [
                            #vurderSporsmal(underUnderSporsmal, hakkInnover: nivaa)
                            #undersporsmalBlokk(underUnderSporsmal,nivaa: nivaa + 1)
                        ] else [
                            #undersporsmalBlokk(underUnderSporsmal,nivaa: nivaa)
                        ]
                    }
                }
            }
            #undersporsmalBlokk(sporsmal)
        ]
    ]
]