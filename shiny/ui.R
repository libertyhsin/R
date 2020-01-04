shinyUI(fluidPage(
  titlePanel("Openair by shiny"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "File input(.csv):", accept=".csv"),
	  tags$hr(),
	  uiOutput("selVOC"),
      sliderInput("sliderSize", label = "dataSize(%)", min = 0, max = 100, value = c(0,10)),
      sliderInput("slider1", label = "FrontSize", min = 0, max = 30, value = 15),
	  tags$hr(),
	  helpText("Parameters in Polar Plot"),
	  numericInput("k", "Input k", value=100, width="30%"), 
	  checkboxInput("CalZero", "Calculate zero value", value = TRUE),
	  tags$hr(),
      radioButtons("radio", label = "Choose download plot", choices = list("Wind Rose" = 1, "Polar Plot" = 2)),
	  downloadButton("download", "Download"),
  	  downloadButton("alldownload", "ALL Download"),
	  tags$hr(),
	  tags$h5("Note: Press Quit before exit."),
	  actionButton("action", label = "Quit", class = "btn-primary")
      ),
   mainPanel(
	  tabsetPanel(
	    tabPanel("Summary", tableOutput("summary")),
	    tabPanel("Summary Plot", plotOutput("summaryPlot")),
	    tabPanel("Calendar Plot", plotOutput("calendarPlot")),
		tabPanel("Plot WindSpeed", plotOutput("distPlotWs", width = "150%")),
		tabPanel("Wind Rose", plotOutput("pollutionPlot", width = "150%")),
		tabPanel("Polar Plot", plotOutput("polarPlot", width = "150%"))
	   )
	)
  )
))