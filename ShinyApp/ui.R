library(shiny)
library(shinyWidgets)
library(shinythemes)
library(readxl)
library(leaflet)
library(DT)
library(dplyr)
library(leaflet.extras)
library(readr)

# Loading the data
data_zipcode<-read_excel("Jones-Kammen-2014-Zip-City-County-Results.xlsx",sheet = "zip code results")
data_zipcode <- data_zipcode[,-c(13:16)]
data_zipcode <- na.omit(data_zipcode)

data_city <- read_excel("Jones-Kammen-2014-Zip-City-County-Results.xlsx", sheet = "City results")
data_city <- na.omit(data_city)

Model_FNN <- read_csv("Model_FNN.csv")
Model_RNN <- read_csv("Model_RNN.csv")
Model_LSTM <- read_csv("Model_LSTM.csv")



# Defining ui section:

shinyUI(
  navbarPage(title=" ",
             
             
             
             
             
             # First tab panel:   
             
             tabPanel("About",class= "my_style_1",
                      wellPanel(h1("What is Carbon Footprint?",align="center")),
                      fillPage(
                        tags$style(
                          type = "text/css",
                          ".half-fill { width: 50%; height: 500px; }",
                          "#one {  float: left;background-size: cover; background-image: url('CARBON.jpg')  }",
                          "#three {  float: left;background-size: cover; background-image: url('CARBON2.jpg')  }",
                        ),
                        div(id = "one", class = "half-fill"),
                        leafletOutput(outputId = "mymap_about",
                                      height = 500,
                                      width = 800
                        ),
                        padding = 0,
                        br(),
                        h4(
                          style = "color:green; font-family:'Comic Sans MS'",
                          "This project is about CO2 Emissions.A carbon footprint is the total amount of greenhouse gas emissions that come from the production, use and end-of-life of a product or service. 
                        It includes carbon dioxide - the gas most commonly emitted by humans - and others, including methane, nitrous oxide, and fluorinated gases, which trap heat in the atmosphere, causing global warming. 
                        Usually, the bulk of an individual's carbon footprint will come from transportation, housing and food. "
                        )
                      )
             ),
             
             
             
             
             # Second tab panel:
             
             tabPanel("CO2 Emissions",
                      
                      
                      
                      
                      sidebarLayout(
                        sidebarPanel(
                          height=900,
                          leafletOutput
                          (
                            outputId = "mymap_transport",
                            height = 450,
                            width = 570
                          ),
                          tags$head
                          (
                            tags$style
                            (
                              HTML("
                           .leaflet-container
                           {
                           background: #f00;
                           }
                                ")
                            )
                          ),
                          selectInput
                          (
                            width = "100%",
                            inputId = "StateId",
                            label="Select State",
                            choices = c("choose" = "", sort(unique(data_city$State))),
                            selected = "WA",
                            selectize = TRUE
                          ),
                          selectInput
                          (
                            width = "100%",
                            inputId = "CityId",
                            label="Select City",
                            choices = c("choose" = "", sort(unique(data_city$City))),
                            selected = "SEATTLE",
                            selectize= TRUE
                          ),
                          selectInput(
                            inputId = "EmissionId",
                            label = "Select type of emission ",
                            choices =  c("choose" = "", c("Transport (tCO2e/yr)","Housing (tCO2e/yr)","Food (tCO2e/yr)","Goods (tCO2e/yr)","Services (tCO2e/yr)")),
                            selected = "Transport (tCO2e/yr)",
                            selectize = TRUE
                          ),
                          
                          uiOutput("obs1")
                        ),
                        mainPanel
                        (
                          wellPanel(
                            h4("Total Emission for the selected city",align="center")
                          ),
                          
                          DT::dataTableOutput("table"),
                          br(),
                          br(),
                          
                          wellPanel(
                            h4("Top 15 cities of the selected state w.r.t selected type of emission",align="center")
                          ),
                          
                          plotOutput("plot1")
                        )
                      )
             ),
             
             navbarMenu("Models",
                        tabPanel("Predictions",
                                 sidebarLayout(
                                   sidebarPanel(
                                     x <- uiOutput('radioTest'),
                                     actionButton('submit', label = "Submit"),
                                     br(),
                                     #print(paste("The model selected is:", "reply")),
                                     textOutput('text')
                                   ),
                                   
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel("Table",
                                                h4("Table"),
                                                DT::dataTableOutput("table2")
                                       ),
                                       tabPanel("Summary", verbatimTextOutput("summary2"))
                                     )
                                   )
                                 )
                        )
             ),
             
             
             # Third tab panel:
             
             tabPanel("Long Short Term Memory Recurrent Model", h4("LSTM model -Plotting the locations (based on zipcode) while applying radius of markers w.r.t predicted household emission", align="center"), fillPage(leafletOutput(outputId =  "map_LSTM", width = "2000", height = "1000"),
                                                                                                                                                                                                                                    absolutePanel(top = 200, left = 100,
                                                                                                                                                                                                                                                  sliderInput("range3", "Persons Per Household", min(Model_LSTM$PersonsPerHousehold), max(Model_LSTM$PersonsPerHousehold),
                                                                                                                                                                                                                                                              value = range(Model_LSTM$PersonsPerHousehold), step = 0.1
                                                                                                                                                                                                                                                  )
                                                                                                                                                                                                                                    )
             )
             ),
             tabPanel("Feed Forward Model", h4("FFN model -Plotting the locations (based on zipcode) while applying radius of markers w.r.t predicted household emission", align="center"), fillPage(leafletOutput(outputId =  "map_FNN", width = "2000", height = "1000"),
                                                     absolutePanel(top = 200, left = 100,
                                                                   sliderInput("range1", "Persons Per Household", min(Model_FNN$PersonsPerHousehold), max(Model_FNN$PersonsPerHousehold),
                                                                               value = range(Model_FNN$PersonsPerHousehold), step = 0.1
                                                                   )
                                                     )
             )
             ),
             tabPanel("Simple Recurrent Model", h4("RNN model -Plotting the locations (based on zipcode) while applying radius of markers w.r.t predicted household emission", align="center"), fillPage(leafletOutput(outputId =  "map_RNN", width = "2000", height = "1000"),
                                                         absolutePanel(top = 200, left = 100,
                                                                       sliderInput("range2", "Persons Per Household", min(Model_RNN$PersonsPerHousehold), max(Model_RNN$PersonsPerHousehold),
                                                                                   value = range(Model_RNN$PersonsPerHousehold), step = 0.1
                                                                       )
                                                         )
             )
             ),
                        tags$style(type = 'text/css', 
                                   '.navbar { background-color: DarkSlateGrey;}',
                                   '.navbar-default .navbar-brand{color: white; background-color: DarkSlateGrey}',
                                   '.navbar-default:hover {background-color: White !important;
                                   color: white;}'
             )
  )
)
