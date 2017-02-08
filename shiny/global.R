library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(DT)

songs = readRDS('data/clean/swr3-songs-2016-v3.rds')
shows = readRDS('data/clean/shows.rds')

tz = 'Europe/Berlin'
tsFormat = '%F %T'
dtFormat = '%d.%m.%Y'
songs = mutate(
  songs,
  ts = as.POSIXct(strptime(ts, tz=tz, format=tsFormat)),
  date = as.POSIXct(strptime(date, tz=tz, format=dtFormat)),

  title = as.character(title),
  artist = as.character(artist),
  wdayLbl = as.character(wdayLbl)
)

distSongs = songs %>%
  group_by(title, artist) %>%
  summarise(
    from = min(ts),
    to = max(ts),
    playCount = n()
  ) %>%
  arrange(desc(playCount))
