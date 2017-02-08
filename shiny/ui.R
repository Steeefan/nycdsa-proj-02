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
              'Here you an explore all the songs that were played on German',
              'radio station SWR3 over the course of whatever it says just',
              'below. Enjoy!'
            ),
            width=12
          )
        ),

        fluidRow(
          column(
            width=6,
            infoBoxOutput('datesLoaded', width=12),
            infoBoxOutput('daysLoaded', width=12),
            infoBoxOutput('songsPlayed', width=12),
            infoBoxOutput('distSongsPlayed', width=12),
            infoBoxOutput('distArtistsPlayed', width=12)
          ),

          column(
            width=6,
            box(
              img(src='swr3-elch.png', align='center'),
              width=12,
              align='center',
              solidHeader=T
            )
          )
        )
      ),

      tabPanel(
        'Songs',
        fluidRow(
          tabBox(
            title='Songs',
            id='tabsetSongs',

            tabPanel(
              'Table',

              fluidRow(
                box(
                  dataTableOutput('songsTable'),
                  width=12
                )
              )
            ),

            tabPanel(
              'Timeline',

              fluidRow(
                box(
                  'here be mooses',
                  width=12
                )
              )
            ),
            width=12
          )
        )
      ),

      tabPanel(
        'Time'
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
