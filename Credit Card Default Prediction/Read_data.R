#Read data
library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(plyr)
library(shinydashboard)
library(caret)
library(leaps)
library(tree)
library(randomForest)
#read in the data
data <- read_csv("UCI_Credit_Card.csv")
#remove missing records
data <- na.omit(data)
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

#########################################################
#set new dataset for regression
data2 <- data[,1:25]
colnames(data2)[25]<-"default"
#one hot encode the categorical variable
dmy <- dummyVars(" ~ .", data = data2[,-25])
vars <- data.frame(predict(dmy, newdata = data2[,-25]))
data2 <- data.frame(vars,data2$default)
colnames(data2)[ncol(data2)]<-"default"
#split data
set.seed(120118)
train <- sample(1:nrow(data2), size = nrow(data2)*0.8)
test <- setdiff(1:nrow(data2), train)

data.train <- data2[train, ]
data.test <- data2[test, ]

########################################logistic regression###########################################
fit.log <- glm(default~., data = data.train, family = "binomial")
pred.log <- predict(fit.log,newdata = data.test, type = "response")

#transform the probability into binary response.
rslt.log <- rep("0",length(pred.log))
rslt.log[pred.log>0.5] <-"1"
#table the predicts compare to test
tbl.log<-table(rslt.log,data.test$default)
#Calculate accuracy.
acc.log<-sum(diag(tbl.log)/sum(tbl.log))
#Recall
rcl.log<-tbl.log[4]/(tbl.log[4]+tbl.log[3])
#############################subset variables model#############################
#variable selection
fit.log_sub <- glm(default ~ LIMIT_BAL + SEX.female + EDUCATION.graduate.school + 
                     EDUCATION.high.school + EDUCATION.university + MARRIAGE.married + 
                     AGE + PAY_0 + PAY_2 + PAY_3 + PAY_5 + BILL_AMT1 + BILL_AMT2 + 
                     PAY_AMT1 + PAY_AMT2 + PAY_AMT4 + PAY_AMT5 + PAY_AMT6, 
                   data = data.train, family = "binomial") 
#prediction
pred <- predict(fit.log_sub,newdata = data.test, type = "response")
result <- rep("0",length(pred))
result[pred>0.5] <-"1"
#calculate accuracy.
tbl.log_sub<-table(result,data.test$default)
tbl.log_sub
acc.log_sub<-sum(diag(tbl.log_sub)/sum(tbl.log_sub))
rcl.log_sub<-tbl.log_sub[4]/(tbl.log_sub[4]+tbl.log_sub[3])

######################################## random forest model #######################################
# rm <- function(ntree){
#   fit.rm <- randomForest(default ~., data = data.train, mtry = sqrt(ncol(data.train)),
#                          ntree = ntree, importance = T)
#   #prediction
#   pred <- predict(fit.rm,newdata = data.test)
#   #calculate accuracy.
#   tbl.rm<-table(pred,data.test$default)
#   tbl.rm
#   acc.rm<-sum(diag(tbl.rm)/sum(tbl.rm))
#   #Recall
#   rcl.rm<-tbl.rm[4]/(tbl.rm[4]+tbl.rm[3])
# }
####################################### unsupervised model ########################################
nums <- unlist(lapply(data, is.numeric))
data3 <- data[,nums]
data3 <- data3[,-1]

