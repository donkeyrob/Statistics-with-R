#Read data
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
