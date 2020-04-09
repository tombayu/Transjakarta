pacman::p_load(readr, dplyr, magrittr, tibble, jsonlite)

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
