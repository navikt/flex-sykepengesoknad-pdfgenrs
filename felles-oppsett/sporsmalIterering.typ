#import "svartypeBlokker.typ":*

#let svartyper = (
        "AAR_MAANED": (s, ghost) => datoer(s),
        "BELOP" : (s, ghost) => belop(s),
        "CHECKBOX": (s, ghost) => checkbox(s),
        "CHECKBOX_GRUPPE": (s, ghost) => sporsmalGruppering(s),
        "CHECKBOX_PANEL" : (s, ghost) => checkboxPanel(s),
        "COMBOBOX_SINGLE": (s, ghost) => vanligTekst(s),
        "DATO": (s, ghost) => datoer(s),
        "DATOER": (s, ghost) => datoer(s),
        "FRITEKST": (s, ghost) => vanligTekst(s),
        "IKKE_RELEVANT": (s, ghost) => ikkeRelevant(s),
        "INFO_BEHANDLINGSDAGER" : (s, ghost) => sporsmalGruppering(s),
        "JA_NEI": (s, ghost) => jaNei(s, flereInntektskilderGhost: ghost),
        "KILOMETER" : (s, ghost) => kilometer(s),
        "LAND": (s, ghost) => land(s),
        "PERIODE": (s, ghost) => perioder(s),
        "PERIODER": (s, ghost) => perioder(s),
        "PROSENT": (s, ghost) => tall(s),
        "RADIO": (s, ghost) => radio(s),
        "RADIO_GRUPPE": (s, ghost) => sporsmalGruppering(s),
        "RADIO_GRUPPE_TIMER_PROSENT": (s, ghost) => sporsmalGruppering(s),
        "RADIO_GRUPPE_UKEKALENDER" : (s, ghost) => radioGruppeUkekalender(s),
        "TALL": (s, ghost) => tall(s),
        "TIMER": (s, ghost) => tall(s),
    )

#let ikkeVisMedTag = (
    "TIL_SLUTT"
)

#let vurderSporsmal(sporsmal, hakkInnover: 0, flereInntektskilderGhost:() ) = [
    #let sporsmalSvartype = sporsmal.at("svartype", default: "")
    #let vis = svartyper.at(sporsmalSvartype, default: (s, ghost) => [])

    #pad(left: hakkInnover * 12pt)[#vis(sporsmal, flereInntektskilderGhost)]
]

#let vis(sporsmalSvartype) = svartyper.keys().contains(sporsmalSvartype)

#let sporsmalBlokk(sporsmalene, flereInntektskilderGhost:() ) = [

    #for sporsmal in sporsmalene [

        #if sporsmal.at("tag", default:"") not in ikkeVisMedTag [
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
                    let kriterieUndersporsmal = sporsmal.at("kriterieForVisningAvUndersporsmal", default: none)
                    let svar() = {
                        let svarene = sporsmal.at("svar", default: ())
                        if svarene.len() != 0 {return svarene.first().at("verdi", default: none)} else {return none}
                    }
                    if (
                        (undersporsmal != none)
                        and (
                            (kriterieUndersporsmal==none) or (kriterieUndersporsmal==svar())
                        )
                    ){
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
]