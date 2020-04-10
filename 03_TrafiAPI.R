pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite)

rm(list = ls())

routes <- read_csv("data/csv/rute.csv") %>%
  mutate(ScheduleID = paste0("idjkb_", 
                             ifelse(startsWith(KodeRute, "13"), paste0("brt_", KodeRute), KodeRute)
                             ))
routes

urls <- list()

for (i in seq_along(routes$KodeRute)) {
  cat(paste0("[", i, "]"), routes$KodeRute[[i]], "\n")
  
  # 1st pattern
  api <- paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
              routes$ScheduleID[[i]],
              "&transportType=transjakarta")
  t <- try(download.file(url = api,
                         destfile = paste0("data/json/", routes$KodeRute[[i]], ".json"),
                         mode = "w"), silent = T)
  if(t == 0) urls[[i]] <- api
  
  # 2nd pattern
  if ("try-error" %in% class(t)) {
    api <- paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                  gsub("JAK-", "OK-", routes$ScheduleID[[i]]),
                  "&transportType=transjakarta")
    t <- try(download.file(url = api,
                           destfile = paste0("data/json/", routes$KodeRute[[i]], ".json"),
                           mode = "w"), silent = T)
    if(t == 0) urls[[i]] <- api
  }
  
  # 3rd pattern
  if ("try-error" %in% class(t)) {
    api <- paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                  gsub("-", ".", routes$ScheduleID[[i]]),
                  "&transportType=transjakarta")
    t <- try(download.file(url = api,
                           destfile = paste0("data/json/", routes$KodeRute[[i]], ".json"),
                           mode = "w"), silent = T)
    if(t == 0) urls[[i]] <- api
  }
  
  # 4th pattern
  if ("try-error" %in% class(t)) {
    api <- paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                  gsub("_", "_brt_", routes$ScheduleID[[i]]),
                  "&transportType=transjakarta")
    t <- try(download.file(url = api,
                           destfile = paste0("data/json/", routes$KodeRute[[i]], ".json"),
                           mode = "w"), silent = T)
    if(t == 0) urls[[i]] <- api
  }
  
  # 5th pattern
  if ("try-error" %in% class(t)) {
    api <- paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                  gsub("_", "_old_", routes$ScheduleID[[i]]),
                  "&transportType=transjakarta")
    t <- try(download.file(url = api,
                           destfile = paste0("data/json/", routes$KodeRute[[i]], ".json"),
                           mode = "w"), silent = T)
    if(t == 0) urls[[i]] <- api
  }
  
  # No match..
  if("try-error" %in% class(t)) {
    cat("Helaas, no matching pattern..\n")
    urls[[i]] <- NA
  } 
}
urls

routesDF <- read_csv("data/csv/rute.csv") %>%
  add_column(API_URL = unlist(urls))

write_csv(routesDF, "data/csv/rute03.csv") 

# Manual download for these missing files..
download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_old_5F&transportType=transjakarta",
              destfile = "data/json/5H.json",
              mode = "w")
download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_6P_royaltrans&transportType=transjakarta",
              destfile = "data/json/6P.json",
              mode = "w")
download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_B16_royaltrans&transportType=transjakarta",
              destfile = "data/json/B16.json",
              mode = "w")
download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_JAK.09&transportType=transjakarta",
              destfile = "data/json/JAK-9.json",
              mode = "w")
download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_S12_royaltrans&transportType=transjakarta",
              destfile = "data/json/S12.json",
              mode = "w")