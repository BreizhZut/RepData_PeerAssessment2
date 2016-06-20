if(!exists("stormData")) {
    sourcedata <- "repdata%2Fdata%2FStormData.csv.bz2"
    if(!file.exists(sourcedata)){
        stop(paste("Missing file",sourcedata))
    } else {
        message(paste("Loading data from:",sourcedata))
    }
    stormData <- read.csv(sourcedata,na.strings = c("", " "))
    # remove filename
    rm(sourcedata)
} else {
    message("Data is already loaded")
}
names(stormData) <- gsub("_","",names(stormData))
# capitalize timezone
stormData$TIMEZONE <- toupper(stormData$TIMEZONE)
# correct for mispelled or unknown timezones
stormData$TIMEZONE <- sub("CSC","CST",stormData$TIMEZONE)
stormData$TIMEZONE <- sub("UNK","CST",stormData$TIMEZONE)
stormData$TIMEZONE <- sub("SCT","CST",stormData$TIMEZONE)
stormData$TIMEZONE <- sub("ESY","EST",stormData$TIMEZONE)
