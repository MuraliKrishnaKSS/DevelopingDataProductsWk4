#
# Project Week-4 Developing Data Products
#
library(shiny)
library(plotly)

#For populating dropdown lists
incomeGroups <- as.list(c("Low income", "Lower middle income", "Upper middle income",
                          "High income","Aggregate"))

regions <- as.list(c("East Asia & Pacific","South Asia", "Middle East & North Africa", 
                        "Sub-Saharan Africa", "Europe & Central Asia", 
                        "North America", "Latin America & Caribbean","Aggregate"))

# Define UI for application that draws a graph
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Threatened Species across the world (2016)"),
  
  # Sidebar with radio buttons, dropdown lists and a table 
  sidebarLayout(
    sidebarPanel(
        helpText(   a("Click for Help", 
                                  href="UserHelp.png", 
                                  target="_blank")
                    ),
        radioButtons("Group", "Group of countries by:", 
                     c("Income Group" = 0, "Region" = 1), selected = 1
                     ),

        conditionalPanel(
                condition = "input.Group == 0",
                selectInput("IncomeType","Income Groups of countries:", 
                            setNames(incomeGroups,incomeGroups)
                            )
        ),

        conditionalPanel(
                condition = "input.Group == 1",
                selectInput("RegionType","Region:", 
                            setNames(regions, regions) 
                )
        ),

        radioButtons("LifeType", "Category of threatened species:", 
                     c("Birds" = "Birds", "Fish" = "Fish", "Mammals" = "Mammals", 
                       "Plants" = "Plants", "All" = "All"), selected = "All"
        ),

        #Table showing selection level aggregate data
        plotlyOutput("smallPlot")
    ),

    # Show a plot of data on threatened species
    mainPanel(
        h3(textOutput("headingText")),
        h5("*Note : 'Threatened' species are vulnerable to endangerment in the near future"),
        HTML("<hr>"),

        plotlyOutput("mainPlot")
    )
  )
))
