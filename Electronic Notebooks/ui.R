library(shinydashboard)
source("data.R")

ui <- dashboardPage(
  dashboardHeader(title = "Performance of Implementing ELNs"),
  dashboardSidebar(sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("archive")),
    menuItem("Survey", tabName = "survey",icon = icon("laptop"))
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #First tab content
      tabItem(tabName = "intro",
              fluidRow(
                column(12,
                       #Description of app
                       h1("Introduction"),
                       box(background = "blue", width = 12,
                           h4("Electronic Laboratory Notebooks (ELNs) have been used as a tool to help students learning in their lab courses in recent years. Traditionally in those science laboratory courses, students use paper notebooks to take notes, record observation data, take pictures or plot results. Compared to a tradition notebook, an ELN is less time consuming, more organized, easy to access and easy to embed images. Moreover, electronic laboratory notebook simplifies data copy and backups and it supports collaboration between many users. Despite their advantages over traditional notebooks, no study has directly tested Electronic Laboratory Notebooks performance among researchers. The purpose of our study is to find out whether the ELNs format improves their students grades and how effective of ELNs on improving the quality of their students' study. 
")),#end of box
                       br(),
                       box(background = "blue", width = 12,
                           h4("To evaluate the implementation of electronic laboratory notebooks (ELNs) in a biotechnology class at a large research university, two faculty members performed electronic pre/post-surveys with their students over four semesters to evaluate their experience with using electronic laboratory notebooks (ELNs) compared to using the traditional paper-based laboratory notebook format. We are particularly interested in judging the statistical significance of their responses to Likert scale questions. 
To study whether the ELNs format improves students' grades, the grades of students' notebooks report during two semesters have also been recorded. We evaluate any differences in their lab report grades between electronic notebook and traditional paper-based laboratory notebook. 
                              ."))#end of box
                       
                )#end of column
                           )#end of fluidrow
                           ),#end of tabitem 1
      tabItem(tabName = "survey",
              fluidRow(
                column(3,
                       uiOutput("title1"),
                       selectizeInput("term", "Year and Term:", selected = "2016 Fall",choices = levels(data$term)),
                       br(),
                       selectizeInput("question", "Question:", choices = colnames(data[1:4])),
                       br()
                ), #end of column
                column(9,
                       fluidRow(
                         plotOutput("survey_question", height = 500)
                       )#end of fluidrow
                )#end of column


              )#endo of fluid Row
      ) #end of tabitem 2
#       tabItem(tabName = "grades",
#               fluidRow(
#                 column(3,
#                        uiOutput("title2"),
#                        selectizeInput("education2", "Education level:", choices = levels(data$EDUCATION)),
#                        downloadButton("downloadplot21","Download Plot"),
#                        br(),
#                        checkboxInput("compare2", h4("Compare between levels and SEX?", style = "color:red;")),
#                        br(),
#                        h5("Balance Limits by Age Groups & Education"),
#                        downloadButton("downloadplot22","Download Plot")
# 
#                 ), #end of column
#                 column(9,
#                        fluidRow(
#                          plotOutput("plot21", height = 500),
#                          br(),
#                          plotOutput("plot22", height = 500)
#                        )#end of fluidrow
#                 )#end of column
#               )#end of fluid Row
#       ) #end of tabitem 3
      )#ent of all tabitems
    )#end of dashboard body
  
  )#end of dashboard page



