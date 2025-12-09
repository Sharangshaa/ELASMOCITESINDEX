# load library
library(shiny)
library(tidyverse)
# select data
df <- read.csv("citesdb.csv")
# UI for the app and title
ui <- fluidPage(
  titlePanel("Information of CITES listed elasmobranchs"),
  sidebarLayout(
    sidebarPanel(
      ##select species name on the left
      selectInput("sc_name", "Select Species", choices = df$sc_name)
    ),
    
    # show species selectin tab on right
    mainPanel(
      uiOutput("info_display"), position = "right"
    )
  )
)
server <- function(input, output, session) {
  # show information of species after selecting species
  speciesinfo <- reactive({
    req(input$sc_name)
    df[df$sc_name == input$sc_name, ]
  })
  output$info_display <- renderUI({
    rec <- speciesinfo()
    
    ##preventing blank output
    if (nrow(rec) == 0) return()
    
    # defining species info and add color to redlist status
    tagList(
      p(strong("Common Name:"), rec$cm_name),
      p(strong("Redlist status:"), span (rec$redlist,
                                         style = paste0(
                                           "color:",
                                           if (rec$redlist == "Vulnerable") {
                                             "#F9E814"
                                           } else if (rec$redlist == "Least Concern") {
                                             "#60C659"
                                           } else if (rec$redlist == "Endangered") {
                                             "#FC7F3F"
                                           } else if (rec$redlist == "Critically Endangered") {
                                             "#D81E05" 
                                           } else if (rec$redlist == "Near Threatened") {
                                             "#CCE226"
                            
                                           } else {
                                             "#D1D1C6"
                                           },
                                           "; font-weight: bold;"
                                         )
      )
        ),
      p(strong("Description:"), rec$description),
      p(strong("CITES status:"), rec$cites),
      p(strong("Trade info:"), rec$trade),
      p(strong("Found In waters of:"), rec$country)
    )
  })
}

shinyApp(ui, server)
