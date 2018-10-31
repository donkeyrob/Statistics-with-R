library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(plyr)
library(shinydashboard)

#read in the data
data <- read_csv("UCI_Credit_Card.csv")
#manipulate data
data$SEX <- mapvalues(data$SEX, from = c(1,2), to = c("male","female"))
data$EDUCATION <- mapvalues(data$EDUCATION, from=c(1,2,3,4,5,6,0), 
                  to=c("graduate school", "university", "high school", "others", "unknown", "unknown","unknown"))
data$MARRIAGE <- mapvalues(data$MARRIAGE, from=c(1,2,3,0), to=c("married","single","others","others"))
#converting to factor
data$SEX <-factor(data$SEX)
data$EDUCATION <- factor(data$EDUCATION)
data$MARRIAGE <- factor(data$MARRIAGE)
data$AGEf <- factor(data$AGE)
data$default.payment.next.month<-factor(data$default.payment.next.month)
#add a column age bucket
data$AGE.bucket<-cut(data$AGE,c(10,20,30,40,50,60,70))


server <- function(input, output,session){

  getData <- reactive({
    newData <- data %>% filter(EDUCATION == input$education)
  })
  getData2 <- reactive({
    newData <- data %>% filter(EDUCATION == input$education2)
  })
  getData_marriage <- reactive({
    newData <- data %>% filter(MARRIAGE == input$marriage)
  })
  makeplot <- reactive({
    newdata <- getData()
    # Balance limits by gender and education
    d1 <- ggplot(data, aes(factor(SEX), (LIMIT_BAL/1000),fill = EDUCATION)) + 
      geom_boxplot() + xlab("Gender") + ylab("BLimit(x1000 NT$)") + 
      scale_fill_brewer(palette = "Accent")
    # Balance limits by education and gender
    d2 <- ggplot(data, aes(factor(EDUCATION), (LIMIT_BAL/1000), fill=SEX)) + 
      geom_boxplot() + xlab("Education") + ylab("BLimit(x1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    d1.t <- ggplot(newdata, aes(factor(SEX), (LIMIT_BAL/1000))) + 
      geom_boxplot() + xlab("Gender") + ylab("BLimit(x1000 NT$)") + 
      scale_fill_brewer(palette = "Accent")
    
    if(input$compare == F){
      d1.t
    } else if(input$flip){
      d2
    } else {
      d1
    }
    
  })
  makeplot2 <- reactive({
    newdata <- getData_marriage()
    # Balance limits by education and gender
    d3 <- ggplot(data, aes(factor(SEX), (LIMIT_BAL/1000), fill=MARRIAGE)) + 
      geom_boxplot() + xlab("Gender") + ylab("Balance Limit ( x 1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    
    d4 <- ggplot(data, aes(factor(MARRIAGE), (LIMIT_BAL/1000), fill=SEX)) + 
      geom_boxplot() + xlab("Marital Status") + ylab("Balance Limit ( x 1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    d3.t <- ggplot(newdata, aes(factor(SEX), (LIMIT_BAL/1000))) + 
      geom_boxplot() + xlab("Gender") + ylab("Balance Limit ( x 1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    
    if(input$compare == F){
      d3.t
    } else if(input$flip){
      d3
    } else {
      d4
    }
  })
  
  makeplot3 <- reactive({
    ggplot(aes(x=AGE,y=LIMIT_BAL/1000),data=subset(data,!is.na(AGE.bucket)))+
      xlab("Age") + 
      ylab("Balance Limit (x1000 NT$)") +
      coord_cartesian(xlim = c(21,60),ylim = c(0,700))+
      scale_color_brewer(palette = "Pastel1")+
      geom_jitter(alpha=0.5, position = position_jitter(h=0), aes(color=AGE.bucket)) +
      geom_smooth(stat='summary', fun.y=mean) +
      geom_smooth(stat='summary', fun.y=quantile, fun.args = list(probs = 0.1), color = 'black', linetype=2) +
      geom_smooth(stat='summary', fun.y=quantile, fun.args = list(probs = 0.5), color = 'red', linetype=2) +
      geom_smooth(stat='summary', fun.y=quantile, fun.args = list(probs = 0.9), color = 'black', linetype=2)
  })
  
  output$edu_vs_sex <- renderPlot({
    makeplot()
  })
  output$mar_vs_sex <- renderPlot({
    makeplot2()
  })
  output$bal_vs_age <- renderPlot({
    makeplot3()
  })
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  output$title1 <- renderUI({
    if(input$compare == F){
      text <- paste0("Balance Limit by ", input$education, " and ", input$marriage)
      h2(text)
    } else {
      h2("Balance Limit by Gender, Education and Marital Status")
    }
  })
  
  output$title2 <- renderUI({
    if(input$compare == F){
      text <- paste0("Default Payment by ", input$education2)
      h2(text)
    } else {
      h2("Default Payment by Education and Age")
    }
  })
  
  makeplot21 <- reactive({
    newdata <- getData2()
    d1 <- ggplot(newdata, aes(x=default.payment.next.month)) + 
      geom_histogram(stat="count",color='red',fill='orange') +
      xlab("Default Payment Status") + ylab("Customer Count") 

    d2 <- ggplot(data, aes(x=default.payment.next.month),aes(y=stat_count(SEX))) + 
      geom_bar(aes(fill=factor(data$EDUCATION))) +
      xlab("Default Payment Status")+ylab("Customer Count") + 
      facet_wrap(~SEX)+
      scale_fill_discrete(name="Education")
    if(input$compare2 == F){
      d1
    } else {
      d2
    }
  })
  
  makeplot22 <- reactive({
    ggplot(data = subset(data,!is.na(AGE.bucket)), aes(factor(EDUCATION), (LIMIT_BAL/1000), fill=AGE.bucket)) + 
      geom_boxplot() +
      xlab("Education") + 
      ylab("Balance Limit ( x 1000 NT$)") + 
      coord_cartesian(ylim = c(0,500)) +
      scale_fill_brewer(palette = "Accent")
  })
  output$plot21 <- renderPlot({
    makeplot21()
  })
  output$plot22 <- renderPlot({
    makeplot22()
  })  
  output$downloadplot <- downloadHandler(
    filename =  function() {
      paste("Balance_Education", "png", sep=".")
    },
    content = function(file) {
      png(file)
      print(makeplot())
      dev.off()  # turn the device off
    })      
  output$downloadplot2 <- downloadHandler(
    filename =  function() {
      paste("Balance_Marriage", "png", sep=".")
    },
    content = function(file) {
      png(file)
      print(makeplot2())
      dev.off()  # turn the device off
    })   
  output$downloadplot3 <- downloadHandler(
    filename =  function() {
      paste("Balance_Age", "png", sep=".")
    },
    content = function(file) {
      png(file)
      print(makeplot3())
      dev.off()  # turn the device off
    })   
  output$downloadplot21 <- downloadHandler(
    filename =  function() {
      paste("Default_Education", "png", sep=".")
    },
    content = function(file) {
      png(file)
      print(makeplot21())
      dev.off()  # turn the device off
    })   
  output$downloadplot22 <- downloadHandler(
    filename =  function() {
      paste("Defualt_Age", "png", sep=".")
    },
    content = function(file) {
      png(file)
      print(makeplot22())
      dev.off()  # turn the device off
    })   
  output$downloaddata <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(data, con)
    }
  )
  output$table <- renderTable({
    data[1:100,]
  })
  
  
  



}



