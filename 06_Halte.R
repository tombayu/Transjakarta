# Written with a lot of help from rasyidstat/transjakarta (thanks, great repo!)
pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr, tidyr, sf)

rm(list = ls())

TJ <- read_rds("data/rds/TJ.rds")

halte <- TJ %>%
  select(-rute, -n_halte) %>%
  unnest() %>%
  rename(halte_id = id, nama_halte = name, lon = lng) %>%
  group_by(halte_id, nama_halte, lon, lat) %>%
  summarise(n_koridor = n_distinct(koridor_id),
            koridor_transit = list(unique(kode_koridor))) %>%
  ungroup()

write_rds(halte, "data/rds/halte.rds")

halte_pt <- halte %>%
  st_as_sf(coords = c("lon", "lat")) %>%
  st_cast("POINT")
st_crs(halte_pt) <- 4326

st_write(halte_pt, "C:/Users/Tombayu Hidayat/Documents/Coding/Transportation/Map/gis/Transjakarta/data/shp/halte.shp")