#let display(value) = if value == none { "" } else { str(value) }
#let has-text(value) = value != none and value != ""
#let answers(q) = q.at("svar", default: ())
#let children(q) = q.at("undersporsmal", default: ())

#let date-short(value) = {
  datetime.from-iso(str(value))
    .display("[day padding:zero].[month padding:zero].[year]")
}

#let date-long(value) = {
  let date = datetime.from-iso(str(value))
  let months = (
    "januar", "februar", "mars", "april", "mai", "juni",
    "juli", "august", "september", "oktober", "november", "desember",
  )
  str(date.day) + ". " + months.at(date.month - 1) + " " + str(date.year)
}

#let year-month(value) = {
  datetime.from-iso(str(value))
    .display("[month padding:zero].[year]")
}

#let period-label(period) = {
  date-short(period.fom) + " - " + date-short(period.tom)
}

#let comma-number(value) = str(value).replace(".", ",")

#let currency(value) = str(value).replace(".", ",")

#let render-question-text(q, show-title: true) = {
  let title = q.at("sporsmalstekst", default: none)
  let help = q.at("undertekst", default: none)

  if show-title and has-text(title) {
    heading(level: 3)[#title]
  }
  if has-text(help) {
    par[#help]
  }
}

#let render-children(q, root) = {
  for child in children(q) {
    render-spm(child, root: root)
  }
}

#let render-checked(q, answer, label, root) = {
  par[☑ #label]
  for child in children(answer) {
    render-spm(child, root: root)
  }
}

#let render-spm(q, root: (:)) = {
  let kind = q.at("svartype", default: "")
  let title = q.at("sporsmalstekst", default: none)
  let help = q.at("undertekst", default: none)
  let response = answers(q)
  let nested = children(q)

  if kind == "CHECKBOX" or kind == "RADIO" or kind == "RADIO_DATO" or kind == "CHECKBOX_PANEL" {
    for answer in response {
      if answer.at("verdi", default: none) == "CHECKED" {
        let label = if kind == "RADIO_DATO" {
          date-short(answer.at("sporsmalstekst", default: title))
        } else {
          answer.at("sporsmalstekst", default: title)
        }
        render-checked(q, answer, display(label), root)
      }
    }
  } else if kind == "DATO" or kind == "DATOER" or kind == "AAR_MAANED" {
    render-question-text(q)
    for answer in response {
      let value = answer.at("verdi", default: none)
      let formatted = if kind == "DATO" {
        date-short(value)
      } else if kind == "DATOER" {
        date-long(value)
      } else {
        year-month(value)
      }
      par[#formatted]
    }
  } else if kind == "KILOMETER" or kind == "BELOP" or kind == "TIMER" or kind == "PROSENT" or kind == "TALL" {
    render-question-text(q)
    for answer in response {
      let value = display(answer.at("verdi", default: none))
      let suffix = if kind == "KILOMETER" {
        " km"
      } else if kind == "BELOP" {
        " kr"
      } else if kind == "TIMER" {
        " timer totalt"
      } else if kind == "PROSENT" {
        " prosent"
      } else {
        " " + display(answer.at("undertekst", default: none))
      }
      let formatted = if kind == "KILOMETER" or kind == "TIMER" {
        comma-number(value)
      } else if kind == "BELOP" {
        currency(value)
      } else {
        value
      }
      par[#formatted#suffix]
    }
  } else if kind == "FRITEKST" {
    for answer in response {
      render-question-text(q)
      par[#display(answer.at("verdi", default: none))]
    }
  } else if kind == "JA_NEI" {
    if title != none {
      if q.at("tag", default: "") == "FLERE_INNTEKTSKILDER_GHOST" {
        let employers = root.at("flereInntektskilderGhost", default: ())
        if employers.len() > 0 {
          heading(level: 3)[Andre registrerte arbeidsforhold]
          for employer in employers {
            par[
              **#display(employer.at("navn", default: none))** \
              Orgnummer: #display(employer.at("orgnummer", default: none))
            ]
          }
        }
      }

      heading(level: 3)[#title]

      if q.at("tag", default: "") == "INNTEKTSOPPLYSNINGER_VARIG_ENDRING_25_PROSENT" {
        let income = q.at("metadata", default: (:))
          .at("sigrunInntekt", default: none)

        if income != none {
          let average = income.at("beregnet", default: (:))
            .at("snitt", default: none)
          par[
            Gjennomsnittlig årsinntekt på sykmeldingstidspunktet:
            #currency(average) kroner
          ]
          par[Inntekt per kalenderår, de tre siste ferdiglignede årene:]
          for year in income.at("inntekter", default: ()) {
            par[
              #display(year.at("aar", default: none)):
              #currency(year.at("verdi", default: none)) kroner
            ]
          }
        }
      }
    }

    if has-text(help) {
      par[#help]
    }

    let first = response.at(0, default: (:))
    let value = first.at("verdi", default: none)
    par[☑ #str(value).capitalize()]

    if value == q.at("kriterieForVisningAvUndersporsmal", default: none) {
      for child in nested {
        render-spm(child, root: root)
      }
    }
  } else if kind == "RADIO_GRUPPE_UKEKALENDER" {
    render-question-text(q)
    for answer in response {
      let value = answer.at("verdi", default: none)
      par[
        #if value == "Ikke til behandling" {
          "Ikke til behandling"
        } else {
          date-short(value)
        }
      ]
    }
  } else if kind == "CHECKBOX_GRUPPE" or kind == "RADIO_GRUPPE" or kind == "RADIO_GRUPPE_TIMER_PROSENT" {
    render-question-text(q)
    for answer in response {
      par[#display(answer.at("verdi", default: none))]
    }

    if kind == "RADIO_GRUPPE_TIMER_PROSENT" {
      for child in nested {
        for answer in answers(child) {
          if answer.at("verdi", default: none) == "CHECKED" {
            for grandchild in children(child) {
              render-spm(grandchild, root: root)
            }
          }
        }
      }
    } else {
      render-children(q, root)
    }
  } else if kind == "PERIODER" or kind == "PERIODE" {
    render-question-text(q)
    for answer in response {
      par[#period-label(answer.at("verdi", default: (:)))]
    }
  } else if kind == "LAND" or kind == "COMBOBOX_SINGLE" or kind == "COMBOBOX_MULTIPLE" {
    render-question-text(q)
    for answer in response {
      par[#display(answer.at("verdi", default: none))]
    }
  } else if kind == "INFO_BEHANDLINGSDAGER" {
    if has-text(title) {
      par[#title]
    }
    render-children(q, root)
  } else if kind == "GRUPPE_AV_UNDERSPORSMAL" {
    render-children(q, root)
  } else if kind == "IKKE_RELEVANT" {
    if has-text(title) {
      par[#title]
    }
    if has-text(help) {
      par[#help]
    }
    render-children(q, root)
  } else {
    []
  }
}

#render-spm(question, root: data)


//Spørsmål 2

#let as-text(value) = if value == none { "" } else { str(value) }

#let iso-date(value) = {
  datetime.from-iso(as-text(value))
    .display("[day padding:zero].[month padding:zero].[year]")
}

#let iso-long-date(value) = {
  let date = datetime.from-iso(as-text(value))
  let months = (
    "januar", "februar", "mars", "april", "mai", "juni",
    "juli", "august", "september", "oktober", "november", "desember",
  )
  str(date.day) + ". " + months.at(date.month - 1) + " " + str(date.year)
}

#let iso-year-month(value) = {
  datetime.from-iso(as-text(value))
    .display("[month padding:zero].[year]")
}

#let comma-number(value) = as-text(value).replace(".", ",")

#let currency-no(value) = comma-number(value)

#let period(value) = {
  let data = json.decode(as-text(value))
  iso-date(data.fom) + " - " + iso-date(data.tom)
}

#let question-heading(q) = {
  let title = q.at("sporsmalstekst", default: none)
  let help = q.at("undertekst", default: none)

  if title != none and title != "" {
    heading(level: 3)[#title]
  }
  if help != none and help != "" {
    par[#help]
  }
}

#let render-children(q) = {
  let children = q.at("undersporsmal", default: ())
  for child in children {
    render-spm(child)
  }
}

#let render-checked-answer(q, answer, label: none) = {
  if answer.at("verdi", default: none) == "CHECKED" {
    block[
      ☑ #if label == none { q.at("sporsmalstekst", default: "") } else { label }
      #render-children(q)
    ]
  }
}

#let render-spm(q) = {
  let kind = q.at("svartype", default: "")
  let answers = q.at("svar", default: ())
  let title = q.at("sporsmalstekst", default: none)
  let help = q.at("undertekst", default: none)

  if kind == "CHECKBOX" or kind == "RADIO" or kind == "CHECKBOX_PANEL" {
    for answer in answers {
      render-checked-answer(q, answer)
    }
  } else if kind == "RADIO_DATO" {
    for answer in answers {
      if answer.at("verdi", default: none) == "CHECKED" {
        render-checked-answer(q, answer, label: iso-date(q.sporsmalstekst))
      }
    }
  } else if kind == "DATO" or kind == "DATOER" or kind == "AAR_MAANED" {
    question-heading(q)
    for answer in answers {
      let value = answer.at("verdi", default: none)
      let formatted = if kind == "DATO" {
        iso-date(value)
      } else if kind == "DATOER" {
        iso-long-date(value)
      } else {
        iso-year-month(value)
      }
      par[#formatted]
    }
  } else if kind == "KILOMETER" or kind == "TIMER" or kind == "PROSENT" or kind == "TALL" or kind == "BELOP" {
    question-heading(q)
    for answer in answers {
      let value = answer.at("verdi", default: none)
      let output = if kind == "KILOMETER" {
        comma-number(value) + " km"
      } else if kind == "TIMER" {
        comma-number(value) + " timer totalt"
      } else if kind == "PROSENT" {
        as-text(value) + " prosent"
      } else if kind == "TALL" {
        as-text(value) + " " + as-text(answer.at("undertekst", default: none))
      } else {
        currency-no(value) + " kr"
      }
      par[#output]
    }
  } else if kind == "CHECKBOX_GRUPPE" or kind == "RADIO_GRUPPE" or kind == "RADIO_GRUPPE_TIMER_PROSENT" {
    question-heading(q)
    for answer in answers {
      par[#as-text(answer.at("verdi", default: none))]
    }

    if kind == "RADIO_GRUPPE_TIMER_PROSENT" {
      for child in q.at("undersporsmal", default: ()) {
        for child-answer in child.at("svar", default: ()) {
          if child-answer.at("verdi", default: none) == "CHECKED" {
            for grandchild in child.at("undersporsmal", default: ()) {
              render-spm(grandchild)
            }
          }
        }
      }
    } else {
      render-children(q)
    }
  } else if kind == "RADIO_GRUPPE_UKEKALENDER" {
    question-heading(q)
    for answer in answers {
      let value = answer.at("verdi", default: none)
      par[#if value == "Ikke til behandling" { value } else { iso-date(value) }]
    }
  } else if kind == "PERIODER" or kind == "PERIODE" {
    question-heading(q)
    for answer in answers {
      par[#period(answer.at("verdi", default: none))]
    }
  } else if kind == "LAND" or kind == "COMBOBOX_SINGLE" or kind == "COMBOBOX_MULTIPLE" {
    question-heading(q)
    for answer in answers {
      par[#as-text(answer.at("verdi", default: none))]
    }
  } else if kind == "FRITEKST" {
    for answer in answers {
      question-heading(q)
      par[#as-text(answer.at("verdi", default: none))]
    }
  } else if kind == "JA_NEI" {
    let tag = q.at("tag", default: "")
    let first-answer = answers.at(0, default: (:))

    if tag == "FLERE_INNTEKTSKILDER_GHOST" {
      let employers = q.at("flereInntektskilderGhost", default: ())
      if employers != () {
        heading(level: 3)[Andre registrerte arbeidsforhold]
        for employer in employers {
          par[
            ☑ #strong(as-text(employer.at("navn", default: none)))
            \
            Orgnummer: #as-text(employer.at("orgnummer", default: none))
          ]
        }
        par[]
      }
    }

    if title != none and title != "" {
      heading(level: 3)[#title]
    }

    if tag == "INNTEKTSOPPLYSNINGER_VARIG_ENDRING_25_PROSENT" {
      let metadata = q.at("metadata", default: (:))
      let income = metadata.at("sigrunInntekt", default: none)
      if income != none {
        let average = income.at("beregnet", default: (:)).at("snitt", default: none)
        par[
          Gjennomsnittlig årsinntekt på sykmeldingstidspunktet:
          #currency-no(average) kroner
        ]
        par[Inntekt per kalenderår, de tre siste ferdiglignede årene:]
        for item in income.at("inntekter", default: ()) {
          par[
            #as-text(item.at("aar", default: none)):
            #currency-no(item.at("verdi", default: none)) kroner
          ]
        }
        par[]
      }
    }

    if help != none and help != "" {
      par[#help]
    }

    par[☑ #as-text(first-answer.at("verdi", default: none)).capitalize()]

    if first-answer.at("verdi", default: none) ==
      q.at("kriterieForVisningAvUndersporsmal", default: none) {
      render-children(q)
    }
  } else if kind == "INFO_BEHANDLINGSDAGER" {
    if title != none and title != "" {
      par[#title]
    }
    render-children(q)
  } else if kind == "GRUPPE_AV_UNDERSPORSMAL" {
    render-children(q)
  } else if kind == "IKKE_RELEVANT" {
    if title != none and title != "" {
      par[#title]
    }
    if help != none and help != "" {
      par[#help]
    }
    render-children(q)
  }
}