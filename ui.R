library(ggplot2)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "About", icon = icon("archive")),
    menuItem("Balance", tabName = "Balance",icon = icon("laptop")),
    menuItem("Default", tabName = "Default",icon = icon("laptop")),
    menuItem("Data", tabName = "data",icon = icon("table"))
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #First tab content
      tabItem(tabName = "about",
              fluidRow(
                #add in latex functionality if needed
                #withMathJax(),
                
                #two columns for each of the two items
                column(6,
                       #Description of app
                       h1("what does this app do?"),
                       box(background = "blue", width = 12,
                           h4("blaa blaa"),
                           h4("blaa2 blaa2")
                       )#end of box
                ),#end of column
                column(6,
                       #Description of app
                       h1("what does this app do?"),
                       box(background = "blue", width = 12,
                           h4("blaa blaa"),
                           h4("blaa2 blaa2")
                       )#end of box
                )#end of column
              )),#end of tabitem 1
      tabItem(tabName = "Balance",

              fluidRow(
                column(3,
                       box(
                         width = 12, title = "Distribution",
                         selectizeInput("education", "Education level:", choices = levels(data$EDUCATION)),
                         br(),
                         selectizeInput("marriage", "Marital Status:", choices = levels(data$MARRIAGE)),
                         br(),
                         checkboxInput("compare", h4("Compare between levels?", style = "color:red;")),
                         #conditional check
                         conditionalPanel(condition = "input.compare",
                                          checkboxInput("flip","Compare between sex?"))
                         
                         ) #end of box
                       ), #end of column
                column(9,
                       box(plotOutput("edu_vs_sex", height = 500)),
                       box(plotOutput("mar_vs_sex", height = 500))
                       
                       )#end of column
                
                
                )#endo of fluid Row
              ), #end of tabitem 2
      tabItem(tabName = "Default",
              fluidRow(
                box(plotOutput("plot2", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )), #end of tabitem 3
      tabItem(tabName = "Data",
              fluidRow(
                
                
              ))
    )
  )
  
)




