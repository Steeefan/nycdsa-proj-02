library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)

wdayDE = function(wday) {
  switch(wday, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')
}

songs = readRDS('data/clean/swr3-songs-2016-v3.rds')
tz = 'Europe/Berlin'
dtFormat = '%Y-%m-%d %H:%M:%S'
songs = mutate(
  songs,
  ts = as.POSIXct(strptime(ts, tz=tz, format=dtFormat)),
  title = as.character(title),
  artist = as.character(title),
  weekdayLbl = wdayDE(weekday)  # Week starts on Mon in DE!
)

songs %>% group_by(weekday) %>% summarise(n())

# for (i in 1:nrow(songs)) {
#   print(paste(i, songs[i, 'weekday'], wdayDE(songs[i, 'weekday'])))
# }
