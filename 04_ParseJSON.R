pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite)

rm(list = ls())

rute <- read_csv("data/csv/rute03.csv")

TJ <- data.frame(kode_rute = character(), rute = character(), layanan = character(), 
                 n_halte = integer(), warna = character(), 
                 trafi_id = character(), api_url = character(), tanggal = as.Date(character()))

for (i in seq_along(rute$KodeRute)) {
  cat(paste0(i, ": ", rute$KodeRute[[i]], "\n"))
  t <- try(fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json")), silent = T)
  if ("try-error" %in% class(t)) {
    cat(paste0("No json file for ", rute$KodeRute[[i]], "\n"))
  } else {
    k <- fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json"))
    url <- rute$API_URL[[i]]
    TJ <- TJ %>%
      add_row(kode_rute = k$name, rute = k$longName, layanan = k$transportName, 
              n_halte = length(k$stops$id), warna = k$color, 
              trafi_id = k$id, api_url = url, tanggal = Sys.Date())
    stops <- k$stops %>%
      select(-areaName, -directionName)
    write_csv(stops, paste0("data/csv/koridor/", k$name, ".csv"))
  }
}

write_csv(TJ, "data/csv/rute04.csv")