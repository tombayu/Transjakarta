# With some help from rasyidstat/transjakarta (great repo!)
pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr, tidyr)

rm(list = ls())

rute <- read_csv("data/csv/rute03.csv")

TJ <- data.frame(kode_koridor = character(), koridor = character(), layanan = character(), 
                 n_halte = integer(), warna = character(), 
                 koridor_id = character(), api_url = character(),
                 tanggal = as.Date(character()), kid = character())

for (i in seq_along(rute$KodeRute)) {
  cat(paste0(i, ": ", rute$KodeRute[[i]], "\n"))
  t <- try(fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json")), silent = T)
  if ("try-error" %in% class(t)) {
    cat(paste0("No json file for ", rute$KodeRute[[i]], "\n"))
  } else {
    k <- fromJSON(paste0("data/json/", rute$KodeRute[[i]], ".json"))
    url <- rute$API_URL[[i]]
    id <- rute$KodeRute[[i]]
    TJ <- TJ %>%
      add_row(kode_koridor = k$name, koridor = k$longName, layanan = k$transportName, 
              n_halte = length(k$stops$id), warna = k$color, 
              koridor_id = k$id, api_url = url, 
              tanggal = Sys.Date(), kid = id)
    # stops <- k$stops %>%
    #   select(-areaName, -directionName)
    # write_csv(stops, paste0("data/csv/koridor/", k$name, ".csv"))
  }
}

write_csv(TJ %>% select(-kid), "data/csv/rute04.csv")
TJ <- TJ %>%
  mutate(route_info = map(paste0("data/json/", kid, ".json"), fromJSON))
TJ <- TJ %>%
  mutate(rute = map(TJ$route_info, "tracks"),
         halte = map(TJ$route_info, "stops")) %>%
  select(-kid, -route_info)

write_rds(TJ, "data/rds/TJ.rds")