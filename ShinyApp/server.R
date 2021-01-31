library(shiny)
library(readxl)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(DT)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)


data_zipcode<-read_excel("Jones-Kammen-2014-Zip-City-County-Results.xlsx",sheet = "zip code results")
data_zipcode <- data_zipcode[,-c(13:16)]
data_zipcode <- na.omit(data_zipcode)
data_city <- read_excel("Jones-Kammen-2014-Zip-City-County-Results.xlsx", sheet = "City results")
data_city <- na.omit(data_city)


Model_FNN <- read_csv("Model_FNN.csv")
Model_RNN <- read_csv("Model_RNN.csv")
Model_LSTM <- read_csv("Model_LSTM.csv")

# Data Cleaning:

worldwide_co2 <- read_excel("D_FINAL.xlsx")
worldwide_co2 <- worldwide_co2[,c(2, 17, 24, 39, 36, 37)]
worldwide_co2 <- na.omit(worldwide_co2)

model_FNN <-read_csv("Model_FNN.csv")
model_RNN <-read_csv("Model_RNN.csv")
model_LSTM <-read_csv("Model_LSTM.csv")

# Setting variables and color palette for world wide CO2 Emission map in 'About' tab

worldwide_co2 <- subset(worldwide_co2, worldwide_co2$`Year of emission` == 2014)
worldwide_co2$co2_new = round(worldwide_co2$`Total emissions (CDP) [tCO2-eq]`/10000, digits = 0)
pal <- colorNumeric(
  palette = c('gold', 'orange', 'dark orange', 'orange red', 'red', 'dark red'),
  domain = worldwide_co2$co2_new)



# Functions:



chartCol<-function(table4)
{
  
  ggplot(head(table4,15),aes(x= reorder(City, -avg),y=avg))+
    geom_bar(stat="identity", width=.3,fill="darkred")+xlab("Cities")+ylab("Avg Household Emission")
  
}

chartTable<-function(SelectedInput)
{
  if(SelectedInput=="FNN")
  {
    model_fnn_reduced<-model_FNN[,c(16,18,19,10,9,27)]
  }
  else if(SelectedInput=="RNN")
  {
    model_rnn_reduced<-model_RNN[,c(16,18,19,10,9,27)]
  }
  else if(SelectedInput=="LSTM")
  {
    model_lstm_reduced<-model_LSTM[,c(16,18,19,10,9,27)]
  }
  
}

# Define server logic for random distribution app 

server <- function(input,output,session) {
  
  
  #create the map for worldwide co2 emission
  output$mymap_about <- renderLeaflet({
    leaflet(worldwide_co2) %>% 
      setView(lng = -99, lat = 45, zoom = 3)  %>% #setting the view over ~ center of North America
      addTiles() %>% 
      addCircles(data = worldwide_co2, lat = ~ worldwide_co2$`Latitude (others) [degrees]`, 
                 lng = ~ worldwide_co2$`Longitude (others) [degrees]`, weight = 1, 
                 radius = ~co2_new*100, popup = ~as.character(co2_new), 
                 label = ~as.character(paste0("Carbon Emission for", sep = " ", 
                                              worldwide_co2$`City name`, ":", sep = " ", 
                                              worldwide_co2$`Total emissions (CDP) [tCO2-eq]`)), 
                 color = ~pal(co2_new), fillOpacity = 0.5)
  })
  
  
  
  #FNN Model
  center_lon1 = mean(Model_FNN$Longitude)
  center_lat1  = mean(Model_FNN$Latitude)
  pal1 <- colorNumeric(
    palette = "PRGn",
    domain = Model_FNN$`Total Household Carbon Footprint (tCO2e/yr).y`)
  
  filteredData1 <- reactive({
    Model_FNN[Model_FNN$PersonsPerHousehold >= input$range1[1] & Model_FNN$PersonsPerHousehold <= input$range1[2],] %>% group_by(ZipCode) %>%
      arrange(desc(`Total Household Carbon Footprint (tCO2e/yr).y`)) %>% head(1000)
  })
  
  output$map_FNN <- renderLeaflet({
    leaflet(Model_FNN) %>% addProviderTiles("Esri.NatGeoWorldMap") %>%
      setView(lng= center_lon1, lat= center_lat1,zoom = 4) 
  })
  
  observe({
    leafletProxy("map_FNN", data = filteredData1()) %>%
      clearShapes() %>%
      addCircleMarkers(radius = ~(`Total Household Carbon Footprint (tCO2e/yr).y`)/10, lng = ~Longitude, lat = ~Latitude, 
                       opacity = 0.7, popup = ~paste(PersonsPerHousehold), color = ~pal1(`Total Household Carbon Footprint (tCO2e/yr).y`))
  })
  
  
  #RNN Model
  center_lon2 = mean(Model_RNN$Longitude)
  center_lat2  = mean(Model_RNN$Latitude)
  pal2 <- colorNumeric(
    palette = "PRGn",
    domain = Model_RNN$`Total Household Carbon Footprint (tCO2e/yr).y`)
  
  filteredData2 <- reactive({
    Model_RNN[Model_RNN$PersonsPerHousehold >= input$range2[1] & Model_RNN$PersonsPerHousehold <= input$range2[2],] %>% group_by(ZipCode) %>%
      arrange(desc(`Total Household Carbon Footprint (tCO2e/yr).y`)) %>% head(1000)
  })
  
  output$map_RNN <- renderLeaflet({
    leaflet(Model_RNN) %>% addProviderTiles("Esri.NatGeoWorldMap") %>%
      setView(lng= center_lon2, lat= center_lat2,zoom = 4) 
  })
  
  observe({
    leafletProxy("map_RNN", data = filteredData2()) %>%
      clearShapes() %>%
      addCircleMarkers(radius = ~(`Total Household Carbon Footprint (tCO2e/yr).y`)/10, lng = ~Longitude, lat = ~Latitude, 
                       opacity = 0.7, popup = ~paste(PersonsPerHousehold), color = ~pal2(`Total Household Carbon Footprint (tCO2e/yr).y`))
  })
  
  
  
  #LSTM Model
  center_lon3 = mean(Model_LSTM$Longitude)
  center_lat3  = mean(Model_LSTM$Latitude)
  pal3 <- colorNumeric(
    palette = "PRGn",
    domain = Model_LSTM$`Total Household Carbon Footprint (tCO2e/yr).y`)
  
  filteredData3 <- reactive({
    Model_LSTM[Model_LSTM$PersonsPerHousehold >= input$range3[1] & Model_LSTM$PersonsPerHousehold <= input$range3[2],] %>% group_by(ZipCode) %>%
      arrange(desc(`Total Household Carbon Footprint (tCO2e/yr).y`)) %>% head(1000)
  })
  
  output$map_LSTM <- renderLeaflet({
    leaflet(Model_LSTM) %>% addProviderTiles("Esri.NatGeoWorldMap") %>%
      setView(lng= center_lon3, lat= center_lat3,zoom = 4) 
  })
  
  observe({
    leafletProxy("map_LSTM", data = filteredData3()) %>%
      clearShapes() %>%
      addCircleMarkers(radius = ~(`Total Household Carbon Footprint (tCO2e/yr).y`)/10, lng = ~Longitude, lat = ~Latitude, 
                       opacity = 0.7, popup = ~paste(PersonsPerHousehold), color = ~pal3(`Total Household Carbon Footprint (tCO2e/yr).y`))
  })
  
  
  #Creating the map for CO2 Emission tab:
  
  
  center_lon = mean(data_zipcode$Longitude)
  center_lat  = mean(data_zipcode$Latitude)
  
  output$mymap_transport <- renderLeaflet({
    data_zipcode %>% leaflet() %>% addProviderTiles("Esri.OceanBasemap") %>% 
      addMarkers(lng = ~ Longitude, lat = ~ Latitude, clusterOptions = markerClusterOptions())  %>%
      # controls
      setView(lng = center_lon, lat = center_lat, zoom = 3)
  })
  
  
  values <- reactiveValues(tbl=NULL,tbl3=NULL,tbl4=NULL)
  
  
  
  
  # Updating second drop down based on the first dropdown input:
  
  observeEvent(input$StateId, 
               {
                 values$tbl <- data_city$City[which(data_city$State==input$StateId)]
                 Cities<-values$tbl
                 output$obs1 <- renderUI(
                   {
                     updateSelectInput(session,
                                       "CityId",
                                       label = paste("Select city from ",input$StateId),
                                       choices = c("choose"="",sort(unique(Cities))),
                                       selected = "SEATTLE"
                     )
                   }
                 )
               }
  )
  
  
  
  # Displaying table and graph on CO2 Emission tab:
  
  observeEvent(input$EmissionId, 
               {
                 
                 if(input$EmissionId == "Transport (tCO2e/yr)")
                 {
                   
                   tbl3<-data_zipcode%>%
                     select(State,City,CountyName,ZipCode,`Transport (tCO2e/yr)`)%>%
                     group_by(State,City,CountyName,ZipCode)%>%
                     filter(State== input$StateId && City== input$CityId)
                   
                   tbl4<-data_zipcode%>%
                     select(State,City,`Transport (tCO2e/yr)`)%>%
                     filter(State== input$StateId)%>%
                     group_by(City)%>%
                     summarize(avg = mean(`Transport (tCO2e/yr)`))%>%
                     arrange(desc(avg))
                   
                 }
                 
                 else if (input$EmissionId == "Housing (tCO2e/yr)")
                 {
                   
                   tbl3<-data_zipcode%>%
                     select(State,City,CountyName,ZipCode,`Housing (tCO2e/yr)`)%>%
                     group_by(State,City,CountyName,ZipCode)%>%
                     filter(State== input$StateId && City== input$CityId)
                   
                   tbl4<-data_zipcode%>%
                     select(State,City,`Housing (tCO2e/yr)`)%>%
                     group_by(State,City)%>%
                     filter(State== input$StateId)%>%
                     summarize(avg = mean(`Housing (tCO2e/yr)`))%>%
                     arrange(desc(avg))
                   
                 }
                 
                 else if (input$EmissionId == "Food (tCO2e/yr)")
                 {
                   
                   tbl3<-data_zipcode%>%
                     select(State,City,CountyName,ZipCode,`Food (tCO2e/yr)`)%>%
                     group_by(State,City,CountyName,ZipCode)%>%
                     filter(State== input$StateId && City== input$CityId)
                   
                   tbl4<-data_zipcode%>%
                     select(State,City,`Food (tCO2e/yr)`)%>%
                     group_by(State,City)%>%
                     filter(State== input$StateId)%>%
                     summarize(avg = mean(`Food (tCO2e/yr)`))%>%
                     group_by(City)%>%
                     arrange(desc(avg))
                   
                 }
                 
                 else if (input$EmissionId == "Goods (tCO2e/yr)")
                 {
                   
                   tbl3<-data_zipcode%>%
                     select(State,City,CountyName,ZipCode,`Goods (tCO2e/yr)`)%>%
                     group_by(State,City,CountyName,ZipCode)%>%
                     filter(State== input$StateId && City== input$CityId) 
                   
                   tbl4<-data_zipcode%>%
                     select(State,City,`Goods (tCO2e/yr)`)%>%
                     group_by(State,City)%>%
                     filter(State== input$StateId)%>%
                     summarize(avg = mean(`Goods (tCO2e/yr)`))%>%
                     arrange(desc(avg))
                   
                 }
                 
                 else if (input$EmissionId == "Services (tCO2e/yr)")
                 {
                   
                   tbl3<-data_zipcode%>%
                     select(State,City,CountyName,ZipCode,`Services (tCO2e/yr)`)%>%
                     group_by(State,City,CountyName,ZipCode)%>%
                     filter(State== input$StateId && City== input$CityId)
                   
                   tbl4<-data_zipcode%>%
                     select(State,City,`Services (tCO2e/yr)`)%>%
                     group_by(State,City)%>%
                     filter(State== input$StateId)%>%
                     summarize(avg = mean(`Services (tCO2e/yr)`))%>%
                     arrange(desc(avg))
                 }
                 
                 output$plot1<-renderPlot(
                   chartCol(tbl4)
                 )
                 
                 output$table<-DT::renderDataTable(as.data.frame(tbl3))
                 
                 
                 
                 
                 output$radioTest <- renderUI({
                   options <- c("FNN", "RNN", "LSTM")
                   # The options are dynamically generated on the server
                   radioButtons('reply', 'Which model do you select ?', options, selected = character(0))
                   
                 })
                 
                 
                 
                 observe({input$submit
                   
                   isolate(
                     output$text <- renderText({
                       paste("Radiobutton response is:",input$reply)
                     })
                   )
                   isolate(
                     if(!is.null(input$reply))
                     {
                       output$table2<-DT::renderDataTable(chartTable(input$reply))
                     }
                   )
                   isolate(
                     output$summary2 <- renderPrint({
                       summary(chartTable(input$reply))
                     })
                   )
                   
                   
                 })
                 
               }
  )
  
  
  
  
  
  
  
  
  
}