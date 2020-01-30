logfile = dir()
logfile = logfile[grepl('[0-9]+',logfile)]
LOG <- which(!is.na(as.numeric(logfile)))
file.remove(logfile[LOG])

library(shiny)
library(openair)
source("./shiny/PolarPlotShiny.r")

shiny::runApp("./shiny/",port=8888,launch.browser=TRUE)