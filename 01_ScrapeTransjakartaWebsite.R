library(rvest)
library(magrittr)
library(stringr)

getwd()

tj_website <- xml2::read_html("https://www.transjakarta.co.id/peta-rute/")

tj_website %>%
  html_nodes("#peta") %>%
  html_attr("href") %>%
  gsub("\\.\\.", "https://www.transjakarta.co.id", .) -> urls

tj_website %>%
  html_nodes("#bus-content~ #service-menu .uk-panel-box") %>%
  html_attrs()

download.file(urls[[1]], "data/petarute/test1.png", mode = "wb")

tj_website %>%
  html_nodes("#peta") %>%
  html_attrs()


?download.file
urls[[1]]

paste0()
urls[[1]]
gsub("\\.\\.", "", urls[[1]])
help(rvest)
