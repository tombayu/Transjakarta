pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite, purrr, tidyr, sf, ggplot2, ggthemes)

rm(list = ls())

tj_rute <- read_rds("data/rds/sp_tj_rute.rds") %>% st_transform(32748)
tj_halte <- read_rds("data/rds/sp_tj_halte.rds") %>% st_transform(32748)
kr_rute <- read_rds("C:/Users/Tombayu Hidayat/Documents/Coding/Transportation/Map/jakarta-trains/data/rds/sp_kr_rute.rds") %>% st_transform(32748)
kr_stasiun <- read_rds("C:/Users/Tombayu Hidayat/Documents/Coding/Transportation/Map/jakarta-trains/data/rds/sp_kr_stasiun.rds") %>% st_transform(32748)

# 01 MRT Feeders..
## Looking at it by the stations/stops
# The basic data
stasiun_mrt <- kr_stasiun %>%
  filter(moda == "MRT")

mrt_rute <- kr_rute %>%
  filter(moda == "MRT") %>%
  filter(isHidden == 0 && direction == 1)

mrt_buffer <- stasiun_mrt %>%
  st_buffer(500)

transit <- tj_halte %>%
  st_intersection(mrt_buffer) %>%
  st_set_geometry(NULL) %>%
  select(koridor_transit) %>%
  unlist() %>%
  unique()

feeders <- tj_rute %>%
  filter(isHidden == 0 && direction == 1) %>%
  filter(kode_koridor %in% transit)

# Visualization
# color palette
tj_color <- tj_rute$warna
names(tj_color) <- tj_rute$kode_koridor
bg_color <- "gray10"

ggplot() + 
  geom_sf(data = feeders, aes(color = kode_koridor), size = 0.5) +
  geom_sf(data = mrt_buffer, alpha = 0) +
  geom_sf(data = mrt_rute, size = 2, color = "#CE0037") +
  geom_sf(data = stasiun_mrt) +
  #geom_sf(data = near_halte, size = 0.5) +
  scale_color_manual(values = tj_color) +
  guides(color = F) +
  coord_sf(xlim = c(696300, 701800), ylim = c(9304125, 9315300)) +
  theme_pander()
mrt_rute

st_write(feeders, "C:/Users/Tombayu Hidayat/Documents/Coding/Transportation/Map/gis/Transjakarta/data/shp/sp_feeders.shp")