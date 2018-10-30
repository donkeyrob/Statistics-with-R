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


server <- function(input, output) {

  getData <- reactive({
    newData <- data %>% filter(EDUCATION == input$education)
  })
  output$edu_vs_sex <- renderPlot({
    newdata <- getData()
    # Balance limits by gender and education
    d1 <- ggplot(data, aes(factor(SEX), (LIMIT_BAL/1000),fill = EDUCATION)) + 
      geom_boxplot() + xlab("Gender") + ylab("BLimit(x1000 NT$)") + 
      scale_fill_brewer(palette = "Accent")
    # Balance limits by education and gender
    d2 <- ggplot(data, aes(factor(EDUCATION), (LIMIT_BAL/1000), fill=SEX)) + 
      geom_boxplot() + xlab("Education") + ylab("BLimit(x1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    
    if(input$compare == F){
      ggplot(newdata, aes(factor(SEX), (LIMIT_BAL/1000))) + 
        geom_boxplot() + xlab("Gender") + ylab("BLimit(x1000 NT$)") + 
        scale_fill_brewer(palette = "Accent")
    } else if(input$flip){
      d2
    } else {
      d1
    }
    
  })
  output$mar_vs_sex <- renderPlot({
    getData <- reactive({
      newData <- data %>% filter(MARRIAGE == input$marriage)
    })
    newdata <- getData()
    # Balance limits by education and gender
    d3 <- ggplot(data, aes(factor(SEX), (LIMIT_BAL/1000), fill=MARRIAGE)) + 
      geom_boxplot() + xlab("Gender") + ylab("Balance Limit ( x 1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    
    d4 <- ggplot(data, aes(factor(MARRIAGE), (LIMIT_BAL/1000), fill=SEX)) + 
      geom_boxplot() + xlab("Marital Status") + ylab("Balance Limit ( x 1000 NT$)") + 
      scale_fill_brewer(palette = "Paired")
    
    if(input$compare == F){
      ggplot(newdata, aes(factor(SEX), (LIMIT_BAL/1000))) + 
        geom_boxplot() + xlab("Gender") + ylab("Balance Limit ( x 1000 NT$)") + 
        scale_fill_brewer(palette = "Paired")
      } else if(input$flip){
      d3
    } else {
      d4
    }
    
  })
}
