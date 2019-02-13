
shinyUI(
  dashboardPage(skin = "blue",
  dashboardHeader(title = "Summary of Vrbo"),
  dashboardSidebar(
    sidebarUserPanel("Weixing Yang",
                     image = "h1.jpg"),
    sidebarMenu(
      menuItem("Home", tabName = "Home", icon = icon("home")),
      menuItem("Bar Graph", tabName = "BarGraph", icon = icon("chart-bar")),
      menuItem("Scatter Graph", tabName = "ScatterGraph", icon = icon("chart-line")),
      menuItem("Map", tabName = "Map", icon = icon("map"))
    ),
    selectizeInput("selected",
                   "Select data to Display",
                   choice)
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Home",
              fluidRow(
                box(title = "explore Vrbo",
                    footer = "Vacation Rental By Owne(Vrbo) is a site that allows you to find rentals of
                    all kinds of choices for your vacation, including houses, apartments, condos, villas, etc.
                    It was originally found in 1995, and then got bought by HomeAway in 2006. Its function is 
                    very similar to Airbnb; however, the owner can only rent entire home unit on Vrbo which makes it
                    less popular compare to Airbnb. But if you are sick of sharing spaces with strangers or spend 
                    tons of money in the hotel, tired of bring lots of items to camping, 
                    Vrbo could be a very good choice. In this project, I scrapy data such as 
                    type, price, location(state), number of people sleep in the place, number of bedrooms in the place
                    , number of bathrooms in the place, number of reviews, and reviews.",width=12)),
              fluidRow(box(img(src = "vacation.jpg", style="width:1470px;height:981px;"), width=12))),
      tabItem(tabName = "BarGraph",
              fluidRow(infoBoxOutput("totalBox"),
                       infoBoxOutput("PopularBox"),
                       infoBoxOutput("PopularHouseBox")),
              fluidRow(box(width = 12,plotOutput("graph")))),
      tabItem(tabName = "ScatterGraph",
              fluidRow(box(width = 12,plotOutput("scatter")))),
      tabItem(tabName = 'Map',
              h3('Number of choices in different state', align = "center"),
              fluidRow(
                      column(
                              width = 9,
                              box(
                                  title = "Map",
                                  solidHeader = T,
                                  collapsible = T,
                                  width = 12,
                                  status = "info",
                                  #htmlOutput('map') 
                                  leafletOutput(outputId ='map',height = 
                                                  800) 
                                )
                            ),
                      column(
                              width = 3,
                              box(
                                  title = "Data",
                                  solidHeader = T,
                                  collapsible = T,
                                  width = NULL,
                                  status = "info",
                                  tableOutput({
                                              'table'
                                              })
                                )
                            )
                        )
              )
    )
  )
))
