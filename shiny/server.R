# server.R

shinyServer(function(input, output) {

  ## START
  output$datesLoaded = renderInfoBox({
    infoBox(
      h4('Data loaded'),
      paste(
        min(songs$date),
        '-',
        max(songs$date)
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

  output$topSong = renderInfoBox({
    topSong = songs %>%
      group_by(artist, title) %>%
      summarise(
        n = n()
      ) %>% arrange(desc(n)) %>% head(1)

    infoBox(
      h4('Top Song'),
      paste(topSong$artist, '-', topSong$title, paste0('(', topSong$n, ')')),
      icon=icon('thumbs-up'),
      color='red'
    )
  })

  output$topArtist = renderInfoBox({
    topSong = songs %>%
      group_by(artist) %>%
      summarise(
        n = n()
      ) %>% arrange(desc(n)) %>% head(1)

    infoBox(
      h4('Top Artist'),
      paste(topSong$artist, paste0('(', topSong$n, ')')),
      icon=icon('thumbs-up'),
      color='red'
    )
  })

  # output$selArtistCtrl = renderUI({
  #   songsFiltered = filterDF(
  #     songs,
  #     input$selArtist,
  #     input$selTitle,
  #     input$selQuarter,
  #     input$selMonth,
  #     input$selWday,
  #     input$selSeason,
  #     input$selRushHour,
  #     input$selDateRange
  #   )
  #
  #   selectInput(
  #     'selArtist',
  #     label='Artist',
  #     choices=distinct(songsFiltered, artist),
  #     multiple=T
  #   )
  # })

  ## SONGS
  output$songsTable = renderDataTable({
    songsFiltered = filterDF(
      songs,
      input$selArtist,
      input$selTitle,
      input$selQuarter,
      input$selMonth,
      input$selWday,
      input$selSeason,
      input$selRushHour,
      input$selDateRange
    )

    distSongs = songsFiltered %>%
      group_by(artist, title) %>%
      summarise(
        from = min(ts),
        to = max(ts),
        playCount = n()
      ) %>%
      arrange(desc(playCount))

    datatable(
      mutate(
        distSongs,
        from=strftime(from, format='%F %H:%M', tz='Europe/Berlin'),
        to=strftime(to, format='%F %H:%M', tz='Europe/Berlin')
      ),
      options = list(
        pageLength = 25
      )
    )
  })

  output$songsCalendar = renderGvis({
    songsFiltered = filterDF(
      songs,
      input$selArtist,
      input$selTitle,
      input$selQuarter,
      input$selMonth,
      input$selWday,
      input$selSeason,
      input$selRushHour,
      input$selDateRange
    )

    distSongs = songsFiltered %>%
      group_by(date) %>%
      summarise(
        playCount = n()
      ) %>%
      arrange(desc(playCount))

    gvisCalendar(
      distSongs,
      datevar='date',
      numvar='playCount',
      options = list(
        width='100%',
        title=paste('Songs x Year')
      )
    )
  })

  output$songsClock = renderPlot({
    songsFiltered = filterDF(
      songs,
      input$selArtist,
      input$selTitle,
      input$selQuarter,
      input$selMonth,
      input$selWday,
      input$selSeason,
      input$selRushHour,
      input$selDateRange
    )

    distSongs = songsFiltered %>%
      group_by(hour) %>%
      summarise(
        playCount = n()
      )

    fromCol = '#d73925'
    toCol = '#e77d72'
    songsCol = colorRampPalette(c(fromCol, toCol))(24)

    ggplot(distSongs, aes(x=hour, y=playCount, fill=playCount)) +
      geom_bar(stat='identity') +
      coord_polar() +
      theme_bw() +
      labs(x = 'Hour of day', y = '', fill = 'Playcount') +
      theme(
        plot.title = element_text(hjust = 0.5, size = 22),
        plot.subtitle = element_text(hjust = .5, size = 16),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
      ) +
      guides(fill='legend') +
      ggtitle(paste('Playcounts during the day')) +
      scale_fill_gradient(low='darkred', high=toCol)

  })

  output$songsHisto = renderGvis({
    songsFiltered = filterDF(
      songs,
      input$selArtist,
      input$selTitle,
      input$selQuarter,
      input$selMonth,
      input$selWday,
      input$selSeason,
      input$selRushHour,
      input$selDateRange
    )

    distSongs = songsFiltered %>%
      group_by(artist, title) %>%
      summarise(
        playCount = n()
      )

    gvisHistogram(
      distSongs[, 'playCount'],
      options = list(
        width='100%',
        height=500,
        title=paste('Frequency of playcounts'),
        hAxis=
          paste(
            "{",
              "slantedText: true",
            "}"
          ),
        colors=
          paste(
          '[',
            "'red'",
          ']'
        )
      )
    )
  })

  output$songsArtist = renderGvis({
    songsFiltered = filterDF(
      songs,
      input$selArtist,
      input$selTitle,
      input$selQuarter,
      input$selMonth,
      input$selWday,
      input$selSeason,
      input$selRushHour,
      input$selDateRange
    )

    distSongs = songsFiltered %>%
      group_by(artist) %>%
      summarise(
        songCount = n_distinct(title)
      ) %>% arrange(desc(songCount))

    gvisColumnChart(
      distSongs[input$sliSongsPerArtist[1]:input$sliSongsPerArtist[2], ],
      xvar='artist',
      yvar='songCount',
      options = list(
        width='100%',
        height=500,
        title=paste('Songs per Artist'),
        hAxis=
          paste(
            '{',
              'slantedText: true,',
              'textStyle:',
              '{',
                'fontSize: 9',
              '}',
            '}'
          ),
        vAxis=
          paste(
            '{',
              'minorGridlines:',
                '{',
                  'count: 1',
                '}',
            '}'
          ),
        colors=
          paste(
            '[',
              '\'red\'',
            ']'
          ),
        chartArea='{ width: \'90%\' }'
      )
    )
  })
})
