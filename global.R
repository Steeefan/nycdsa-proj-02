library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)

songs = readRDS('data/clean/swr3-songs-2016-v3.rds')
tz = 'Europe/Berlin'
dtFormat = '%Y-%m-%d %H:%M:%S'
songs = mutate(
  songs,
  ts = as.POSIXct(strptime(ts, tz=tz, format=dtFormat)),
  title = as.character(title),
  artist = as.character(title),
  wdayLbl = as.character(wdayLbl)
)

