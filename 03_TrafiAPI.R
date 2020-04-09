pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite)

rm(list = ls())

routes <- read_csv("data/csv/rute.csv") %>%
  mutate(ScheduleID = paste0("idjkb_", 
                             ifelse(startsWith(KodeRute, "13"), paste0("brt_", KodeRute), KodeRute)
                             ))
routes

urls <- list()

for (i in 1:2) {
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
    urls[[i]] <- NULL
  } 
}
urls

t == 0
t <- try(download.file(url = paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                                    routes$ScheduleID[[30]],
                                    "&transportType=transjakarta"),
                       destfile = paste0("data/json/", routes$KodeRute[[30]], ".json"),
                       mode = "w"))
if("try-error" %in% class(t)) t <- download.file(url = paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                                                         gsub("_", "_brt_", routes$ScheduleID[[30]]),
                                                         "&transportType=transjakarta"),
                                            destfile = paste0("data/json/", routes$KodeRute[[30]], ".json"),
                                            mode = "w")
if("try-error" %in% class(t)) t <- download.file(url = paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                                                              gsub("-", ".", routes$ScheduleID[[30]]),
                                                              "&transportType=transjakarta"),
                                                 destfile = paste0("data/json/", routes$KodeRute[[30]], ".json"),
                                                 mode = "w")

?gsub
i
gsub("_", "_brt_", routes$KodeRute[[30]])
tryCatch({
  
},
error = function(e) {
  
})

?try

download.file(url = "https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_brt_13B&transportType=transjakarta",
              destfile = "data/json/13B", mode = "w")
dat <- fromJSON("https://www.trafi.com/api/schedules/jakarta/all?transportType=transjakarta")
sid <- dat$schedulesByTransportId$schedules[[1]]$scheduleId

listofdat <- list()

for (i in seq_along(sid)) {
  cat(paste0("[",i,"]"))
  listofdat[[i]] <- fromJSON(paste0("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=",
                                    sid[[i]],
                                    "&transportType=transjakarta"))
}
sid
listofdat[[1]]$stops
listofdat[[2]]$stops
fromJSON("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_brt_13b&transportType=transjakarta")
"https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_JAK-10&transportType=transjakarta"



dat2 <- fromJSON("https://www.trafi.com/api/schedules/jakarta/schedule?scheduleId=idjkb_1&transportType=transjakarta")
dat2

help("jsonlite")
rutewebtj <- read_rds("data/rds/routesDF.rds")
write_csv(rutewebtj, "data/csv/rute.csv")
