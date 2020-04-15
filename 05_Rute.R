# Written with a lot of help from rasyidstat/transjakarta (great repo!)
pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr, tidyr)
library(googleway)
library(sf)

rm(list = ls())

TJ <- read_rds("data/rds/TJ.rds")

routes <- TJ %>%
  select(-halte) %>%
  unnest() %>%
  mutate(coords = map(shape, decode_pl), warna = paste0("#", warna)) %>%
  unnest(coords) %>%
  st_as_sf(coords = c("lon", "lat")) %>%
  group_by_at(vars(-stops, -geometry)) %>%
  summarise(do_union = F) %>%
  st_cast("LINESTRING")

st_crs(routes) <- 4326
write_rds(routes, "data/rds/sp_tj_rute.rds")
st_write(routes, "C:/Users/Tombayu Hidayat/Documents/Coding/Transportation/Map/gis/Transjakarta/data/shp/sp_tj_rute.shp", append = F)
