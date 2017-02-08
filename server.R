# server.R

shinyServer(function(input, output) {

  ## START
  output$datesLoaded = renderInfoBox({
    infoBox(
      h4('Data loaded'),
      paste(
        min(songs$ts),
        '-',
        max(songs$ts)
      ),
      icon=icon('calendar'),
      color='red'
    )
  })

  output$daysLoaded = renderInfoBox({
    infoBox(
      h4('Days loaded'),
      n_distinct(songs$date),
      icon=icon('calendar-check-o'),
      color='red'
    )
  })

  output$songsPlayed = renderInfoBox({
    infoBox(
      h4('Total songs played'),
      format(nrow(songs), scientific=F, decimal.mark='.', big.mark=','),
      icon=icon('music'),
      color='red'
    )
  })

  output$distSongsPlayed = renderInfoBox({
    infoBox(
      h4('Distinct songs played'),
      format(n_distinct(songs$title), scientific=F, decimal.mark='.', big.mark=','),
      icon=icon('file-audio-o'),
      color='red'
    )
  })

  output$distArtistsPlayed = renderInfoBox({
    infoBox(
      h4('Distinct artists played'),
      format(n_distinct(songs$artist), scientific=F, decimal.mark='.', big.mark=','),
      icon=icon('microphone'),
      color='red'
    )
  })

  ## SONGS
  output$songsTable = renderDataTable({
    datatable(
      distSongs,
      options = list(
        pageLength = 25
      )
    )
  })
})
