PolarPlotMain <- function(File, VOC, a, fontsize, k=100, CalZero=TRUE){
    UseData <- ReadData(File,VOC)
    info <- Drawing(UseData, VOC, CalZero, k, a, fontsize)
    return(info)
}

ReadData <- function(Temp, VOC){
  RemoveIndex <- which(apply(Temp, 1, function(x) length(x) <4))
  if(length(RemoveIndex) > 0) Temp <- Temp[-RemoveIndex]

  ColNames <- colnames(Temp)
  colnames(Temp)[1] = "date"
  vocPosition <- which(ColNames==VOC)
  Temp[,1] = as.POSIXct(Temp[,1], tz = "GMT")

  Temp[,vocPosition] = as.numeric(as.character(Temp[,vocPosition]))
  return(Temp[,c(1:3,vocPosition)])
}

Drawing <- function(UseData, VOC, CalZero, k, a, fontsize){
  if(!CalZero){
    UseData[(which(UseData[,4]==0)),4] <- NA
	if(all(is.na(UseData[,4]))) return("3")
  }
  tryCatch({
    if(a==1) pollutionRose(UseData, pollutant=VOC, par.settings=list(fontsize=list(text=fontsize)))
    if(a==2) polarPlot(UseData, pollutant = VOC, par.settings=list(fontsize=list(text=fontsize)), k=k)
    },warning = function(war){
    if(conditionMessage(war)==paste("Not enough data to fit surface.\nTry reducing the value of the smoothing parameter, k to less than ", k, ".", sep="")){
      #return(paste("WARNING: ", VOC, "Not enough data to fit surface. Please reduce k."))}else{
      return("1")}else{
      #return(paste("WARNING: ", VOC, war))}
      return("2")}
      },error = function(err) {
      #return(paste("ERROR: ", VOC, err))
	  return("3")}
)
}

ReadAllData <- function(Temp){
  ColNames <- colnames(Temp)
  colnames(Temp)[1] = "date"
  Temp[,1] = as.POSIXct(Temp[,1], tz = "GMT")
  Temp[,2] = as.numeric(as.character(Temp[,2]))
  Temp[,3] = as.numeric(as.character(Temp[,3]))
  for(i in 4:dim(Temp)[2])
  {
    Temp[,i] = as.numeric(as.character(Temp[,i]))
  }
  return(Temp)
}
##############################################################################

# VOC <- "nox"
# fontsize <- 18 #字型大小
# ConDaU0 <- FALSE #濃度等於0忽略不計
# k <- 100 #設定最小需要點數
# a <- 1 #選擇WindRose or PolarPlot

# 會於 資料夾路徑 外層新增 Image 資料夾，最後的圖檔會存於此資料夾中

##############################################################################