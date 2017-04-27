#################################################
#              Text Filtering by Keywords            #
#################################################

library(shiny)
library(NLP)
library(magrittr)
library(tidytext)
library(dplyr)


shinyUI(fluidPage(
  
 titlePanel("Text Filtering by Keywords"),
  
  # Input in sidepanel:
  sidebarPanel(
    
    fileInput("file", "Upload text file"),
    fileInput("keywords", "Upload Key words text file"),
    tags$b("And/Or"),br(),br(),
    textInput("keywords2",('Enter key words seperated by comma (,)'),value = '')
    
  ),
  
  # Main Panel:
  mainPanel( 
        tabsetPanel(type = "tabs",
                #
                tabPanel("Overview",h4(p("How to use this App")),
                         
                         p("To use this app you need a document corpus in txt file format. Make sure each document is 
                           separated from another document with a new line character. Similarly you will need a keywords 
                           txt file. Each Key Word should be separated by a new line. You can download the sample files 
                           from Example dataset tab. Also you can enter the keywords in left side bar panel. If you are 
                           entering keywords in the left side bar panel, than each key word should be separated by comma (,) 
                           without any space.", align = "justify")
                         )
                ,
                tabPanel("Example dataset", h4(p("Download Sample text file")), 
                         downloadButton('downloadData1', 'Download Nokia Lumia reviews text file'),br(),
                         h4(p("Download Sample Key Words text file")), 
                         downloadButton('downloadData2', 'Download Sample Key Words text file'),br(),
                         br(),
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                         img(src = "example1.png")),
                
                tabPanel("Filtered Corpus",
                         h4(p("Download Filtered Corpus text file")), 
                         downloadButton('downloadData3', 'Download Filtered Corpus text file'),br(),br(),
                         verbatimTextOutput("filter_corp"))
                )
           )
       )
    )

