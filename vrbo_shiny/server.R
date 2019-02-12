#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$graph = renderPlot(

      ggplot(data %>%
                   select(., Record = as.character(input$selected))%>%
                   group_by(., Record) %>%
                   summarise(., number = length(Record)) %>%
                   distinct() %>% 
                   arrange (., desc(number)) %>%
                   head(12), aes(x= Record, y= number, fill = Record)) +
      geom_bar(stat="identity", alpha=0.5, width = 0.5, position='dodge') +
      geom_text(aes(x=Record,
                    y=number,
                    label=format(number, digits=2)),
                hjust=0.5, 
                size=5,
                color=rgb(100,100,100, maxColorValue=255))+
      theme_minimal() +
      theme(
        text = element_text(size=15), 
        plot.title = element_text(hjust = 0.5),
        axis.text.x =
          element_text(size  = 12,
                       angle = 45,
                       hjust = 1,
                       vjust = 1)
      )+
      scale_y_continuous(oob = rescale_none)+
      labs(fill=as.character(input$selected),x=as.character(input$selected), y=paste("number in choice of ", as.character(input$selected)), title = paste("Top ranking number in ", as.character(input$selected)))
  )
  
 # output$map = renderGvis({
  #  gvisGeoChart(
  #    data %>%
  #      select(., state)%>%
  #      group_by(., state) %>%
  #      summarise(., number = length(state)),
  #    locationvar = 'state',
  #    colorvar = 'number',
  #    hovervar = 'state',
  #    options  = list(region="US", displayMode="regions", 
  #                    resolution="provinces",
  #                    colorAxis = "{colors:['#E0FFFF', '#4169E1']}",
  #                    datalessRegionColor = 'grey',
  #                    width = 'auto', height = 'auto',
  #                    forceFrame = TRUE)
  #)
  #})
  pal <- colorNumeric(palette = "Blues", domain=NULL)
  output$map <- renderLeaflet({
    leaflet(stateData.df) %>% 
      addProviderTiles(providers$Stamen.TonerLite) %>% 
      setView(lng = -98.583, lat = 39.833, zoom = 4) %>%
      addPolygons(data = stateData.df,fillColor = ~pal(count),
                  popup = paste0("<strong>State: </strong>", 
                                 stateData.df$NAME,
                                 "<br><strong>Number of : </strong>",
                                 stateData.df$count),
                  color = "#BDBDC3",
                  fillOpacity = 0.8,
                  weight = 1)
    
  })
  
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
  output$table = renderTable({
    data %>%
      select(., state)%>%
      group_by(., state) %>%
      summarise(., number = length(state)) %>%
      arrange(., desc(number)) %>% head(17)
  },
  striped = T,
  spacing = 'l',
  width = '100%',
  colnames = F)
  
  output$totalBox <- renderInfoBox({
    total <- nrow(data)
    infoBox("Total number of Data", total, icon = icon("info"))
  })
  output$PopularBox <- renderInfoBox({
    mostOfState <- data %>%
      select(., state)%>%
      group_by(., state) %>%
      summarise(., number = length(state)) %>%
      arrange(., desc(number)) %>% head(1) %>% select(., state)
    mostOfStateNum <- data %>%
      select(., state)%>%
      group_by(., state) %>%
      summarise(., number = length(state)) %>%
      arrange(., desc(number)) %>% head(1) %>% select(., number)
    infoBox("Most choice state", mostOfState, mostOfStateNum, icon = icon("map-pin"))
  })
  output$PopularHouseBox <- renderInfoBox({
    mostOfHouse <- data %>%
      select(., house)%>%
      group_by(., house) %>%
      summarise(., number = length(house)) %>%
      arrange(., desc(number)) %>% head(1) %>% select(., house)
    mostOfHouseNum <- data %>%
      select(., house)%>%
      group_by(., house) %>%
      summarise(., number = length(house)) %>%
      arrange(., desc(number)) %>% head(1) %>% select(., number)
    infoBox("Most popular type", mostOfHouse, mostOfHouseNum, icon = icon("thumbtack"))
  })
  
})
