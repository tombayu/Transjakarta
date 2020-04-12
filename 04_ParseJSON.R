pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr)

rm(list = ls())

rute <- read_csv("data/csv/rute03.csv")

TJ <- data.frame(kode_koridor = character(), koridor = character(), layanan = character(), 
                 n_halte = integer(), warna = character(), 
                 trafi_id = character(), api_url = character(), 
                 #rute = list(), halte = list(),
                 tanggal = as.Date(character()))


for (i in seq_along(rute$KodeRute)) {
  cat(paste0(i, ": ", rute$KodeRute[[i]], "\n"))
  t <- try(fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json")), silent = T)
  if ("try-error" %in% class(t)) {
    cat(paste0("No json file for ", rute$KodeRute[[i]], "\n"))
  } else {
    k <- fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json"))
    url <- rute$API_URL[[i]]
    TJ <- TJ %>%
      add_row(kode_koridor = k$name, koridor = k$longName, layanan = k$transportName, 
              n_halte = length(k$stops$id), warna = k$color, 
              trafi_id = k$id, api_url = url, 
              #rute = k$tracks, halte = k$stops,
              tanggal = Sys.Date())
    stops <- k$stops %>%
      select(-areaName, -directionName)
    write_csv(stops, paste0("data/csv/koridor/", k$name, ".csv"))
  }
}

write_csv(TJ, "data/csv/rute04.csv")

dat <- fromJSON("data/json/1.json")
map(map(dat, "tracks"), "shape")
dat$tracks$shape
