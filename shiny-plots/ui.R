
library(shiny)


shinyUI(fluidPage(
    
    
    titlePanel("Old Faithful Geyser Data"),
    
    tabsetPanel(
    tabPanel('Reactive Plots',
             plotOutput('plot_tarea',
                        click = 'click_plot_tarea',
                        dblclick = 'dblclck_plot_tarea',
                        hover = 'hover_plot_tarea',
                        brush = 'brush_plot_tarea'
             ),
             DT::dataTableOutput('tarea_dt')
    )
    )
    
))
