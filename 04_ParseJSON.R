pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite)

rm(list = ls())

rute <- read_csv("data/csv/rute03.csv")

TJ <- data.frame(KodeRute = character(), Rute = character(), Layanan = character(), 
                 JumlahHalte = integer(), Warna = character(), 
                 TrafiID = character(), API_URL = character())
# seq_along(rute$KodeRute)
for (i in seq_along(rute$KodeRute)) {
  cat(paste0(i, ": ", rute$KodeRute[[i]], "\n"))
  t <- try(fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json")), silent = T)
  if ("try-error" %in% class(t)) {
    cat(paste0("No json file for ", rute$KodeRute[[i]], "\n"))
  } else {
    k <- fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json"))
    TJ <- TJ %>%
      add_row(KodeRute = k$name, Rute = k$longName, Layanan = k$transportName, 
              JumlahHalte = length(k$stops$id), Warna = k$color, 
              TrafiID = k$id, API_URL = rute$API_URL[[i]])
    stops <- k$stops %>%
      select(-areaName, -directionName)
    write_csv(stops, paste0("data/csv/koridor/", k$name, ".csv"))
  }
}

write_csv(TJ, "data/csv/rute04.csv")
