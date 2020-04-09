library(rvest)
library(magrittr)
library(stringr)
library(tibble)
library(dplyr)
library(readr)

getwd()

# The URL fom which the routes will be scraped from
tj_website <- xml2::read_html("https://www.transjakarta.co.id/peta-rute/")

### Gather all the map URL
tj_website %>%
  html_nodes("#peta") %>%
  html_attr("href") %>%
  gsub("\\.\\.", "https://www.transjakarta.co.id", .) -> urls

### Gather all the routes
tj_website %>%
  html_nodes("#bus-content~ #service-menu .uk-panel-box") %>%
  html_text() %>%
  gsub("\\r", "", .) %>%
  gsub("\\t", "", .) %>%
  str_split("\\n") %>%
  unlist() -> r

routes <- c()
for (i in seq_along(r)) {
  if (grepl(":", r[[i]])) {
    routes <- c(routes, r[[i]])
  }
}
# There is one temporary route that needs to be added..
routes <- c(routes[1:33], "TEMP1 : Stasiun Manggarai - Tosari", routes[34:235])
routes

rsplt <- strsplit(routes, " : ")
routesDF <- data.frame("KodeRute" = character(), "NamaRute" = character())
for (i in seq_along(rsplt)) {
  routesDF <- routesDF %>%
    add_row("KodeRute" = ifelse(startsWith(rsplt[[i]][1], "0"), gsub("0", "", rsplt[[i]][1]), rsplt[[i]][1]), "NamaRute" = rsplt[[i]][2])
}

write_rds(routesDF, "data/rds/routesDF.rds")
write_csv(routesDF, "data/csv/rute01.csv")

### Download route map
for (i in seq_along(urls)) {
  cat(i, "\n", routesDF$KodeRute[[i]], "\n")
  download.file(urls[[i]], paste0("data/petarute/", routesDF$KodeRute[[i]], " ", routesDF$NamaRute[[i]], ".png"), mode = "wb")
}

routesDF
