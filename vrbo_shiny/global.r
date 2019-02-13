library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DT)
library(googleVis)
library(stringr)
library(maps)
library(mapproj)
library(scales)
library(shinydashboard)
library(sp)
library(leaflet)
library(geojsonio)
data = read.csv('./data/vrbo.csv', header=TRUE)
dataN = data
data[] <- lapply(data, as.character)
#state = data %>% group_by(., state) %>% summarise(count = length(state)) %>% arrange (., desc(count)) %>% head(15)

choice = c("state", "price", "house", "sleep", "size", "review", "numOfBedroom", "numOfBathroom", "numOfReview")

stateData = data %>%
  select(state) %>%
  group_by(., state) %>% 
  summarise(count = length(state))
abbtoFull = read.csv("./data/states_abb.csv", header = TRUE)
stateFull.df <- merge(stateData, abbtoFull, by.x = "state", by.y = "Abb")
states <- geojson_read("./data/gz_2010_us_040_00_500k.json",what = "sp")
stateData.df <- merge(states, stateFull.df, by.x = "NAME", by.y = "Name")
nrow(data)


data %>%
  select(numOfReview) %>%
  arrange (., desc(numOfReview))
     