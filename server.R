#
# Project Week-4 Developing Data Products
#
#-------------------
library(shiny)
library(plotly)

df <- read.csv("data/ThreatenedSpecies.csv", header = TRUE, stringsAsFactors = F)

# Create a list of variable names of Mammals,Birds,Fish,BigPlants
headlist <- colnames(df)[3:6] 
lapply(headlist,function(x) {df[,x] <- as.integer(df[,x])})

# Remove incomplete datasets
df <- df[complete.cases(df), ]


# Define server logic required to draw the graph
shinyServer(function(input, output) {
        
        output$headingText <- renderText({
                 paste("Number of species of",
                       ifelse(input$LifeType == "All", "All life forms",input$LifeType),
                       "threatened in" ,
                       ifelse(input$Group == 0,input$IncomeType,input$RegionType),
                       "countries", sep = " " )
       })

        output$mainPlot <- renderPlotly({
                if (input$Group ==0){
                       newdata <- df[df$IncomeGroup == input$IncomeType,
                        c("Country","ForestGrowth",input$LifeType)]                       
                } else {
                       newdata <- df[df$Region == input$RegionType, 
                        c("Country","ForestGrowth",input$LifeType)]                       
                }
                                      
                colnames(newdata)[3] <- "Lifeform"
                xTitle <- "Forest Growth percentage (annual average) in each country (2000-2015)"
                yTitle <- paste("No. of threatened species of",ifelse(input$LifeType == "All", 
                                       "All life forms",input$LifeType))

                plot_ly(data = newdata, x = ForestGrowth, y = Lifeform,    
                   text = Country, mode = 'markers',
                   marker = list(size = 9, opacity = 0.9, color = "rgb(255,0,0)")  
                )  %>%
                layout(
                    xaxis = list(range = c(-7,4), showgrid = TRUE, title = xTitle),
                    yaxis = list(autorange = TRUE ,showgrid = TRUE, title = yTitle, zeroline = TRUE)
                )
        })

        output$smallPlot <- renderPlotly({
                filterValue <- ifelse(input$Group == 0,
                                      ifelse(input$IncomeType == "Aggregate","World",input$IncomeType),
                                      ifelse(input$RegionType == "Aggregate","World",input$RegionType)
                                      )
                varNames <- c("Birds","Fish","Mammals","Plants")
                wdata <- subset(df,Country == filterValue, select = c("Country",varNames)) 
                varValues <- as.numeric(unlist(wdata[1,varNames]))
               
                colorValues <-c("rgb(202,255,255)","rgb(188,210,238)","rgb(192,192,192)","rgb(100,149,237)")
                titleValue <- paste("This",ifelse(input$Group == 0,"Group","Region"),"level - breakup", sep=" ")
                mValues <- list(l = 5, r = 5, b = 10,t = 30, pad = 4 )
                plot_ly( values = varValues ,labels = varNames, type="pie",
                         text = paste(varNames,varValues), textinfo = "text", hoverinfo ="text",       
                         marker = list(colors= colorValues)) %>%
                layout(title = titleValue,titlefont= list( size = 16),autosize = FALSE, showlegend = FALSE, 
                       width = 250, height = 250,margin = mValues, paper_bgcolor='transparent')
        })
                
  })