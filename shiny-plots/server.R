library(shiny)
library(ggplot2)
library(dplyr)

out_click<- NULL
out_hover<-NULL

shinyServer(function(input, output) {

    puntos <- reactive({
        if(!is.null(input$click_plot_tarea$x)){
            df<-nearPoints(mtcars,input$click_plot_tarea,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- rbind(out_click,out) %>% distinct()
            return(out)
        }
        if(!is.null(input$hover_plot_tarea$x)){
            df<-nearPoints(mtcars,input$hover_plot_tarea,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_hover <<- out
            return(out_hover)
        }
        
        if(!is.null(input$dblclck_plot_tarea$x)){
            df<-nearPoints(mtcars,input$dblclck_plot_tarea,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- setdiff(out_click,out)
            return(out_hover)
        }
        
        if(!is.null(input$brush_plot_tarea)){
            df<-brushedPoints(mtcars,input$brush_plot_tarea,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- rbind(out_click,out) %>% dplyr::distinct()
            return(out_hover)
        }
        
        
        
    })
    
    
    mtcars_plot <- reactive({
        plot(mtcars$wt,mtcars$mpg,xlab="wt",ylab="Miles per Galon")
        puntos <-puntos()
        if(!is.null(out_hover)){
            points(out_hover[,1],out_hover[,2],
                   col='gray',
                   pch=16,
                   cex=2)}
        if(!is.null(out_click)){
            points(out_click[,1],out_click[,2],
                   col='green',
                   pch=16,
                   cex=2)}
        
    })
    
    output$plot_tarea <- renderPlot({
        
        mtcars_plot()
    })
    
    
    click_table <- reactive({
        input$click_plot_tarea$x
        input$dblclck_plot_tarea$x
        input$brush_plot_tarea
        out_click
    })
    
    output$tarea_dt <- DT::renderDataTable({
        click_table() %>% DT::datatable()
    })
    
})
