#import "felles-oppsett/base.typ": *
#import "felles-oppsett/sporsmal.typ": *

#let data = json("/data/nav-brev/brev.json")
#let soknadData = json("/data/flex-sykepengesoknader/arbeidstakere.json")

#let soknadsId = soknadData.at("soknadsId", default: (""))
#let fnr = soknadData.at("fnr", default: (""))
#let navn = soknadData.at("navn", default: (""))
#let innsendtDato = soknadData.at("innsendtDato", default: (""))
#let innsendtTid = soknadData.at("innsendtTid", default: (""))
#let sendtArbeidsgiver = soknadData.at("sendtArbeidsgiver", default: (""))
#let sykmeldingUtskrevet = soknadData.at("sykmeldingUtskrevet", default: (""))
#let arbeidsgiver = soknadData.at("arbeidsgiver", default: (""))
#let korrigerer = soknadData.at("korrigerer", default: (none))
#let egenmeldtSykmelding = soknadData.at("egenmeldtSykmelding", default: (false))
#let avsendertype = soknadData.at("avsendertype", default: (""))
#let soknadPerioder = soknadData.at("soknadPerioder", default: ())
#let egenmeldingsdagerFraSykmelding = soknadData.at("egenmeldingsdagerFraSykmelding", default: ())
#let flereInntektskilderGhost = soknadData.at("flereInntektskilderGhost", default: (:))
#let sporsmalene = soknadData.at("sporsmal", default: ())

#show: oppsett //Eh er denne nødvendig...?

#topseksjonen(
"Søknad om sykepenger",
  navn,
  fnr,
  innsendtDato,
  innsendtTid,
  sendtArbeidsgiver,
  soknadPerioder,
  sykmeldingUtskrevet,
  arbeidsgiver,
  egenmeldingsdagerFraSykmelding,
)
#sporsmalBlokk(
    sporsmalene
)

