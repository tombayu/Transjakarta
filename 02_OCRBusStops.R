rm(list = ls())

library(tesseract)
library(magrittr)
library(readr)
library(dplyr)
library(stringr)

fl <- list.files("data/petarute/")
# gsub(".png", "", .)
fl[[1]]
bahasa <- tesseract("ind")

ocr <- list()

# seq_along(fl)
for (i in 1:3) {
  ocr[[i]] <- ocr(paste0("data/petarute/", fl[[1]]))
    
}

(Koridor_1 <- ocr("data/petarute/1 Blok M - Kota.png", bahasa))
str_split(Koridor_1, "\n")
(Koridor_1A <- ocr("data/petarute/1A PIK - Balai Kota.png", engine = bahasa))
k1a <- ocr_data("data/petarute/1A PIK - Balai Kota.png", engine = bahasa)
str_split(Koridor_1A, "\n")
?ocr
fl[[1]]
