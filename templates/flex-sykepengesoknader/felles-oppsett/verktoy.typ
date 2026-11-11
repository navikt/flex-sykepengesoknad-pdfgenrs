#let formaterDato(iso) = {
    if iso != "" and iso.len() <= 10 {
        let d = iso.slice(0, 10).split("-")
        let dato = datetime(year: int(d.at(0)), month: int(d.at(1)), day: int(d.at(2))).display("[day].[month].[year]")
        if iso.len() > 10 {
            dato + " kl." + iso.slice(11, 16)
        } else {
            dato
        }
    } else {
        return "halla"
    }
}