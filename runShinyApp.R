logfile = dir()
logfile = logfile[grepl('[0-9]+',logfile)]
LOG <- which(!is.na(as.numeric(logfile)))
file.remove(logfile[LOG])

library(shiny, lib.loc="./R-Portable/App/R-Portable/library/")
library(openair, lib.loc="./R-Portable/App/R-Portable/library/")
source("./shiny/PolarPlotShiny.r")

shiny::runApp("./shiny/",port=8888,launch.browser=TRUE)