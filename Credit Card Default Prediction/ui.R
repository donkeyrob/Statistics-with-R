library(shinydashboard)
source("Read_data.R")

ui <- dashboardPage(
  dashboardHeader(title = "Credit Card Default Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "About", icon = icon("archive")),
    menuItem("Balance", tabName = "Balance",icon = icon("laptop")),
    menuItem("Default", tabName = "Default",icon = icon("laptop")),
    menuItem("Data", tabName = "data",icon = icon("table")),
    menuItem("Supervised Model", tabName = "spvmodel",icon = icon("gear")),
    menuItem("Unsupervised Model", tabName = "unsvmodel",icon = icon("gear"))
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #First tab content
      tabItem(tabName = "About",
              fluidRow(
                column(6,
                       #Description of app
                       h1("dataset Information"),
                       box(background = "blue", width = 12,
                           h4("This dataset contains information on default payments,
                              demographic factors, credit data, history of payment, 
                              and bill statements of credit card clients in Taiwan from
                              April 2005 to September 2005.")),
                       h1("Goals and Plan"),
                       box(background = "blue", width = 12,
                           h4("This dataset was used to learn basic techniques of data 
                              manipulation and machine learning. The idea is to use the dataset
                              UCI_Credit_Card to improve basic skills of data cleaning, data analysis,
                              data visualization and machine learning.")),
                       tags$a(href="https://www.kaggle.com/lucabasa/credit-card-default-a-very-pedagogical-notebook",
                              "Click here to See Full Analysis"),
                       h1("Logistic Regression"),
                       box(background = "blue", width = 12,
                           h4("Logistic Regression model can be applied to classification problem like this.")
                       ),
                       withMathJax(),
                       helpText("logitic regression model: $$log(\\frac{p(X)}{1-p(X)}) = \\beta_0+ \\beta_1X$$")
                       
                ),#end of column
                column(6,
                       #Description of app
                       h1("Content Explanation"),
                       box(background = "blue", width = 12,
                           h4("There are 25 variables:"),
                           h5("ID: ID of each client "),
                           h5("LIMIT_BAL: Amount of given credit in NT dollars (includes individual and family/supplementary credit"),
                           h5("SEX: Gender (1=male, 2=female)  "),
                           h5("EDUCATION: (1=graduate school, 2=university, 3=high school, 4=others, 5=unknown, 6=unknwn)"),
                           h5("MARRIAGE: Marital status (1=married, 2=single, 3=others)"),
                           h5("AGE: Age in years"),
                           h5("PAY_0: Repayment status in September, 2005 (-1=pay duly, 1=payment delay for one month, 2=payment delay for two months, ... 8=payment delay for eight months, 9=payment delay for nine months and above)"),
                           h5("PAY_2: Repayment status in August, 2005 (scale same as above)"),
                           h5("PAY_3: Repayment status in July, 2005 (scale same as above)"),
                           h5("PAY_4: Repayment status in June, 2005 (scale same as above)"),
                           h5("PAY_5: Repayment status in May, 2005 (scale same as above)"),
                           h5("PAY_6: Repayment status in April, 2005 (scale same as above)"),
                           h5("BILL_AMT1: Amount of bill statement in September, 2005 (NT dollar)"),
                           h5("BILL_AMT2: Amount of bill statement in August, 2005 (NT dollar)"),
                           h5("BILL_AMT3: Amount of bill statement in July, 2005 (NT dollar)"),
                           h5("BILL_AMT4: Amount of bill statement in June, 2005 (NT dollar)"),
                           h5("BILL_AMT5: Amount of bill statement in May, 2005 (NT dollar)"),
                           h5("BILL_AMT6: Amount of bill statement in April, 2005 (NT dollar)"),
                           h5("PAY_AMT1: Amount of previous payment in September, 2005 (NT dollar)"),
                           h5("PAY_AMT2: Amount of previous payment in August, 2005 (NT dollar)"),
                           h5("PAY_AMT3: Amount of previous payment in July, 2005 (NT dollar)"),
                           h5("PAY_AMT4: Amount of previous payment in June, 2005 (NT dollar)"),
                           h5("PAY_AMT5: Amount of previous payment in May, 2005 (NT dollar)"),
                           h5("PAY_AMT6: Amount of previous payment in April, 2005 (NT dollar)"),
                           h5("default.payment.next.month: Default payment (1=yes, 0=no)")
                       )#end of box
                )#end of column
              )#end of fluidrow
              ),#end of tabitem 1
      tabItem(tabName = "Balance",
              fluidRow(
                column(3,
                         uiOutput("title1"),
                         selectizeInput("education", "Education level:", selected = "graduate school",choices = levels(data$EDUCATION)),
                         downloadButton("downloadplot","Download Plot"),
                         br(),
                         selectizeInput("marriage", "Marital Status:", choices = levels(data$MARRIAGE)),
                         downloadButton("downloadplot2","Download Plot"),
                         br(),
                         checkboxInput("compare", h4("Compare between levels?", style = "color:red;")),
                         #conditional check
                         conditionalPanel(condition = "input.compare",
                                          checkboxInput("flip","Compare between sex?")),
                         br(),
                         h5("Age"),
                         downloadButton("downloadplot3","Download Plot")
                       
                       ), #end of column
                column(9,
                       fluidRow(
                         plotOutput("edu_vs_sex", height = 500),
                         br(),
                         plotOutput("mar_vs_sex", height = 500),
                         br(),
                         plotOutput("bal_vs_age", height = 500, click = "plot_click"),
                         verbatimTextOutput("info")
                        )#end of fluidrow
                       )#end of column
                
                
                )#endo of fluid Row
              ), #end of tabitem 2
      tabItem(tabName = "Default",
              fluidRow(
                column(3,
                       uiOutput("title2"),
                       selectizeInput("education2", "Education level:", choices = levels(data$EDUCATION)),
                       downloadButton("downloadplot21","Download Plot"),
                       br(),
                       checkboxInput("compare2", h4("Compare between levels and SEX?", style = "color:red;")),
                       br(),
                       h5("Balance Limits by Age Groups & Education"),
                       downloadButton("downloadplot22","Download Plot")
                       
                ), #end of column
                column(9,
                       fluidRow(
                         plotOutput("plot21", height = 500),
                         br(),
                         plotOutput("plot22", height = 500)
                       )#end of fluidrow
                )#end of column
               )#end of fluid Row
        ), #end of tabitem 3
      #tab item 4
      tabItem(tabName = "data",
              fluidRow(
                h1("First 100 observations of the data"),
                downloadLink("downloaddata","Click here to download the entire dataset"),
                tableOutput("table")
                )#end of fluidrow
              ),#end of tabitem data
      #tab item supervised model
      tabItem(tabName = "spvmodel",
              fluidRow(
                column(3,
                       selectizeInput("subset","Variable Selection:", choices = c("Full model","Subset model")
                                      ,selected = "Full model"),
                       sliderInput("ntrees", "Number of Trees:", min = 10, max = 200, value = 10, step = 10),
                       br(),
                       selectizeInput("metrics","Evaluation Metrics:", choices = c("Accuracy", "Recall"),
                                      selected = "Accuracy")
                ),# end of column
                column(9,
                       fluidRow(
                         textOutput("logistic"),
                         br(),
                         #Add another format of result
                         textOutput("random_forest")
                       )#end of fluidrow
                )#end of column
              )#end of larger fluidrow
      ),#end of tabitem 4
      #tabItem 5
      tabItem(tabName = "unsvmodel",
              fluidRow(
                column(3,
                       numericInput("nclust","Number of Clusters:", value = 2, min=2,max = 5,step =1),
                       br(),
                       selectizeInput("xaxis", "X axis", choices = colnames(data3),selected = "AGE"),
                       selectizeInput("yaxis", "Y axis", choices = colnames(data3),selected = "LIMIT_BAL")
                       ),#end of column
                column(9,
                      fluidRow(
                        plotOutput("plot_unsv")
                      )#end of son fluidrow
                    )#end of column 9
                )#end of parent fluid row 
              )#end of tabItem 5
      
    )#ent of all tabitems
  )#end of dashboard body
  
)#end of dashboard page



