library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
# grade15a = read_excel('Grade Data\\LabReport1_Fall2015-A.xlsx')
# r = nrow(grade15a)
# c = ncol(grade15a)
# t()
# a = grade15a[9,3:28]
# b = as.data.frame(a)
# hist(b)
# typeof(b)
# c = t(b)
# hist(c)
# grade16a = read_excel('Grade Data\\LabReport1_Fall2016-A.xlsx')
# nrow(grade16a)
# ncol(grade16a)
# a = grade16a[9,3:36]
#boxplot

## survey

#get correct name and questions
s16post = read_csv('Survey Data\\Post-Survey Fall 2016.csv')
namecol = colnames(s16post)
questions = s16post[1,]


#Set repeat
# a = str_split_fixed("Pre-Survey Fall 2016.csv", " ", n =3)
# 
# substrYear <- function(x){
#   substr(x, nchar(x)-7, nchar(x)-4)
# }
# 
# substrType <- function(x){
#   a = substr(x, 1, 4)
#   if (a == 'Post'){
#     ans = 'Post'
#   } else {
#     ans = 'Pre'
#   }
#   return(ans)
# }
################################# get final df##########################
finaldf = data.frame()
for (i in list.files('Survey Data')) {
  survey = read_csv(paste0('Survey Data/',i))
  t = survey[c(-1,-2),]
  t = t[complete.cases(t),]
  t = t[2:5]
  colnames(t) = namecol[2:5]
  a = str_split_fixed(i,' ', n = 3)
  t['term'] = paste(substr(a[3],1,4),a[2])
  t['type'] = a[1]
  finaldf = rbind(finaldf,t)
}
data = finaldf
data$term = as.factor(data$term)
#######################################################################
#plot
# ggplot(finaldf,aes(eval(as.name("Q2_2"))))+
#   geom_bar(aes(y = (..count..)/sum(..count..),fill = type), position = "dodge")+
#   title('questions[2]')+
#   scale_y_continuous(labels = scales::percent, name = "Proportion")+
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
