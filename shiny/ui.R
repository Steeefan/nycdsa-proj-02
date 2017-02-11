# ui.R

dbHeader = dashboardHeader(
  tags$li(
    class = "dropdown",
    tags$style(".main-header {max-height: 75px}"),
    tags$style(".main-header .logo {height: 75px}"),
    tags$style(".sidebar-toggle {height: 75px}")
  )
)

dbHeader$children[[2]]$children =
  tags$a(
    href='http://www.swr3.de/',
    tags$img(src='SWR3_weiss.png',height=75,style='padding:12px'),
    target='_blank'
  )


shinyUI(dashboardPage(
  skin='red',

  dbHeader,

  dashboardSidebar(disable = TRUE),

  dashboardBody(
    tabsetPanel(
      tabPanel(
        'Start',

        h2('SWR3 Song Explorer'),

        fluidRow(
          box(
            p('Welcome to the SWR3 Song Explorer!'),
            p(
              'Here you can explore all the songs that were played on German',
              'radio station SWR3 over the course of whatever it says just',
              'below. Enjoy!'
            ),
            width=12
          )
        ),

        fluidRow(
          column(
            width=4,
            infoBoxOutput('datesLoaded', width=12),
            infoBoxOutput('daysLoaded', width=12),
            infoBoxOutput('songsPlayed', width=12),
            infoBoxOutput('distSongsPlayed', width=12),
            infoBoxOutput('distArtistsPlayed', width=12)
          ),

          column(
            width=4,
            infoBoxOutput('topSong', width=12),
            infoBoxOutput('topArtist', width=12)
            # infoBoxOutput('songsPlayed', width=12),
            # infoBoxOutput('distSongsPlayed', width=12),
            # infoBoxOutput('distArtistsPlayed', width=12)
          ),

          column(
            width=4,
            box(
              img(src='swr3-elch.png', align='center', width='100%'),
              width=12,
              height='100%',
              align='center',
              solidHeader=T
            )
          )
        )
      ),

      tabPanel(
        'Songs',
        fluidRow(
          box(
            title='Filters',
            collapsible=T,
            solidHeader=T,
            width=12,
            collapsed=T,

            column(
              selectInput(
                'selArtist',
                label='Artist',
                choices=arrange(distinct(songs, artist), artist),
                multiple=T
              ),
              # uiOutput('selArtistCtrl'),
              width=2
            ),

            column(
              selectInput(
                'selTitle',
                label='Title',
                choices=arrange(distinct(songs, title), title),
                multiple=T
              ),
              width=2
            ),

            column(
              selectInput(
                'selQuarter',
                label='Quarter',
                choices=1:4,
                multiple=T
              ),
              width=1
            ),

            column(
              selectInput(
                'selMonth',
                label='Month',
                choices=1:12,
                multiple=T
              ),
              width=1
            ),

            column(
              selectInput(
                'selWday',
                label='Weekday',
                choices=c('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'),
                multiple=T
              ),
              width=1
            ),

            column(
              selectInput(
                'selSeason',
                label='Season',
                choices=c(
                  'Winter' = 'winter',
                  'Spring' = 'spring',
                  'Summer' = 'summer',
                  'Fall' = 'fall'),
                multiple=T
              ),
              width=1
            ),

            column(
              selectInput(
                'selRushHour',
                label='Rush Hour',
                choices=c(
                  'Morning' = 'morning',
                  'Evening' = 'evening'
                  ),
                multiple=T
              ),
              width=1
            ),

            column(
              dateRangeInput(
                'selDateRange',
                'Dates',
                start=min(songs$date),
                end=max(songs$date),
                min=min(songs$date),
                max=max(songs$date),
                format='yyyy-mm-dd'
              ),
              width=2
            ),

            column(
              actionButton(
                'selReset',
                'Reset',
                style='position: relative; top: 22px'
              ),
              width=1
            )
          ),

          tabBox(
            title='Songs',
            id='tabsetSongs',

            tabPanel(
              'Table',

              fluidRow(
                box(
                  h2('Complete overview'),
                  dataTableOutput('songsTable'),
                  width=12,
                  solidHeader=T
                )
              )
            ),

            tabPanel(
              'Calendar',

              fluidRow(
                box(
                  h2('Songs played by day of year'),
                  htmlOutput('songsCalendar'),
                  width=12,
                  solidHeader=T
                )
              )
            ),

            tabPanel(
              'Clock',

              fluidRow(
                box(
                  h2('Songs played by hour of day'),
                  plotOutput('songsClock'),
                  width=6,
                  solidHeader=T,
                  height=600
                )
              )
            ),

            tabPanel(
              'Histogram',

              fluidRow(
                box(
                  h2('Histogram about song playcount frequence'),
                  htmlOutput('songsHisto'),
                  width=12,
                  solidHeader=T
                )
              )
            ),

            tabPanel(
              'Songs per Artist',
                fluidRow(
                box(
                  h2('Distinct songs per artist'),
                  sliderInput(
                    'sliSongsPerArtist',
                    label=h4('Scrollbar'),
                    min=0,
                    max=n_distinct(songs$artist),
                    value=c(0, 200)
                  ),

                  htmlOutput('songsArtist'),
                  width=12,
                  solidHeader=T
                )
              )
            ),

            tabPanel(
              'Song Title Word Cloud',

              fluidRow(
                h2('300 top words in song titles'),
                box(
                  sliderInput(
                    'sliWordCloudWords',
                    label=h4('Select amount of words to show'),
                    min=0,
                    max=1000,
                    value=300
                  ),
                  width=12,
                  solidHeader=T,
                  collapsible=T,
                  collapsed=T
                )
              ),

              fluidRow(
                column(
                  width=3
                ),

                column(
                  box(
                    wordcloud2Output('songsCloud'),
                    width=12,
                    solidHeader=T,
                    height=500
                  ),
                  width=6
                ),

                column(
                  width=3
                )
              )
            ),

            width=12
          )
        )
      ),

      tabPanel(
        'About',

        h2('About'),
        fluidRow(
          box(
            'Code: ', a(href='mailto:sh@steeefan.de', 'Stefan Heinz'), br(),
            'Data: Playlists for the year 2016 scraped from ', a(href='www.swr3.de/musik/playlisten/-/id=47424/cf=42/did=65794/93avs/index.html', 'SWR3.de', target='_blank'), br(),
            br(),
            'This project has no affiliation with SWR3, Suedwestrundfunk or ARD.',
            'It\'s build as part of the', a(href='nycdatascience.com/data-science-bootcamp/', 'NYC Data Science Academy Data Science Bootcamp', target='_blank'),
            'and simply uses data freely available on', a(href='http://www.swr3.de/', 'SWR3.de', target='_blank'),

            width=12
          )
        ),

        fluidRow(
          box(
            p(
              'Suedwestrundfunk (SWR, "Southwest Broadcasting") is a regional public',
              'broadcasting corporation serving the southwest of Germany, specifically',
              'the federal states of Baden-Wuerttemberg and Rhineland-Palatinate. The',
              'corporation has main offices in three cities: Stuttgart, Baden-Baden',
              'and Mainz, with the director\'s office being in Stuttgart. It is a part',
              'of the ARD consortium. It broadcasts on two television channels and six',
              'radio channels, with its main television and radio office in Baden-Baden',
              'and regional offices in Stuttgart and Mainz. It is (after WDR) the second',
              'largest broadcasting organization in Germany. SWR, with a coverage of 55,600 sqkm,',
              'and an audience reach estimated to be 14.7 million. SWR employs 3,700 people',
              'in its various offices and facilities.'
            ),

            p(
              'SWR3 (Mehr Hits - mehr Kicks - einfach SWR3) plays pop and contemporary music',
              'to a target audience of 14- to 39-year-olds.'
            ),

            p(
              'Source: ', a(href='https://en.wikipedia.org/wiki/SWR3', 'https://en.wikipedia.org/wiki/SWR3')
            ),
            width=12
          )
        )
      )
    )
  )
))
