# The standard library
# With a lot of help from rasyidstat/transjakarta (great repo!)
pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr, tidyr)
library(googleway)
library(sf)

rm(list = ls())

TJ <- read_rds("data/rds/TJ.rds")

routes <- TJ %>%
  select(-halte) %>%
  unnest() %>%
  mutate(coords = map(shape, decode_pl)) %>%
  unnest(coords) %>%
  st_as_sf(coords = c("lon", "lat")) %>%
  group_by_at(vars(-stops, -geometry)) %>%
  summarise(do_union = F) %>%
  st_cast("LINESTRING")
  
write_rds(routes, "data/rds/routes.rds")