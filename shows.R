shows = data.frame(
  show = c(
    'Luna',
    'Morningshow',
    'Vormittagsshow',
    'Topthemen am Mittag',
    'PopUp',
    'Nachmittagsshow',
    'Club',
    'Popshop',
    'Sunrise',
    'Vormittagsshow',
    'Die Sonntagsshow',
    'PopUp',
    'Wochenendshow',
    'Weltweit',
    'ClubParty',
    'Club Pop & Go'
  ),

  fromTime = c(0, 5, 9, 12, 13, 15, 18, 22, 5, 8, 8, 13, 16, 16, 19, 19),
  toTime   = c(5, 9, 12, 13, 15, 17, 21, 23, 8, 12, 12, 16, 19, 19, 24, 24)-1,
  fromDate = c(0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 7, 6, 6, 7, 6, 7),
  toDate   = c(7, 5, 5, 7, 5, 5, 5, 5, 7, 6, 7, 7, 6, 7, 6, 7)
)

saveRDS(shows, 'data/clean/shows.rds')
