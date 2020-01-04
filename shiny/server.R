shinyServer(function(input, output) {
    filedata <- reactive({
		if(input$action) q()
        infile <- input$file
        if(is.null(infile)) return(NULL)
        read.csv(infile$datapath, header=TRUE, stringsAsFactors=F,encoding='big5')
    })
	output$selVOC <- renderUI({
	    data <- filedata()
        if(is.null(data)) selectInput("select", "Select Target VOC", "")
		names <- colnames(data)
		selectInput("select", "Select Target VOC", names[c(-1,-2,-3)])
    })
	output$summary <- renderTable({
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
        data[(c(ceiling((dim(data)[1])*input$sliderSize[1]/100)+1):ceiling((dim(data)[1])*input$sliderSize[2]/100)),]
    })
	output$summaryPlot <- renderPlot({
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
        summaryPlot(ReadAllData(data))
        }, width=1000, height=1000)
	output$calendarPlot <- renderPlot({
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
		calendarPlot(ReadAllData(data), pollutant = input$select, par.settings=list(fontsize=list(text=input$slider1)))
        }, width=1000, height=1000)
	output$distPlotWs <- renderPlot({
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
        PolarPlotMain(data, "ws", 1, input$slider1)
        }, width=600, height=600)
    output$pollutionPlot <- renderPlot({
		if(input$action) q()
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
        inform <- PolarPlotMain(data, input$select, 1, input$slider1)
		if(length(inform) != 1) inform <- "0"
        validate(
		  need(inform != "1", message = paste("Not enough data to fit surface.\nTry reducing the value of the smoothing parameter, k to less than.\n\nPlease decrease k.")),
		  need(inform != "2", message = paste("Error Code", inform)),
  		  need(inform != "3", message = paste("Error Code", inform, "\n\nPlease check", input$select, "data.")))
		}, width=600, height=600)
	output$polarPlot <- renderPlot({
		if(input$action) q()
	    data <- filedata()
		validate(need(!is.null(data), message = "Please Select a file."))
        inform <- PolarPlotMain(data, input$select, 2, input$slider1, input$k, input$CalZero)
		if(length(inform) != 1) inform <- "0"
        validate(
		  need(inform != "1", message = paste("Not enough data to fit surface.\nTry reducing the value of the smoothing parameter, k to less than.\n\nPlease decrease k.")),
		  need(inform != "2", message = paste("Error Code", inform)),
  		  need(inform != "3", message = paste("Error Code", inform, "\n\nPlease check", input$select, "data.")))
		}, width=600, height=600)
	output$download <- downloadHandler(
	    filename = function(){
		    subname <- switch(input$radio,
			        "1" = "_WindRose",
					"2" = "_PolarPlot")
			paste(input$select,subname,".jpeg",sep="")
		},
		content = function(file){
		    jpeg(file, width=800,height=800)
            if(input$radio==1) PolarPlotMain(filedata(), input$select, input$radio, input$slider1)
            if(input$radio==2) PolarPlotMain(filedata(), input$select, input$radio, input$slider1, input$k, input$CalZero)
			dev.off()
		}
	)
	output$alldownload <- downloadHandler(
	    filename = function(){
		    subname <- switch(input$radio,
			        "1" = "_WindRose",
					"2" = "_PolarPlot")
			paste("Result",subname,".jpeg",sep="")
		},
		content = function(file){	    
    	        data <- filedata()		
                if(is.null(data)) return(NULL)
				subname <- switch(input$radio,
			         "1" = "_WindRose",
					 "2" = "_PolarPlot")
		        names <- colnames(data)[c(-1,-2,-3)]
				
				SaveFolder <- file.path(getwd(), "Image")
				if(!file.exists(SaveFolder)){
                    dir.create(SaveFolder)
                }
	            for(i in 1:length(names))
				{		    			
    		        jpeg(paste(SaveFolder,"/",names[i], subname, ".jpeg", sep=""), width=800, height=800)
        			jpegname <- paste(names[i], subname, ".jpeg",sep="")
                    if(input$radio==1) PolarPlotMain(data, names[i], input$radio, input$slider1)
                    if(input$radio==2) PolarPlotMain(data, names[i], input$radio, input$slider1, input$k, input$CalZero)
					dev.off()
				}			   
			}
	)
})