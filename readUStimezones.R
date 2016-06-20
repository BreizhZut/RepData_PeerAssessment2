library(lubridate)
UStz <- read.csv("UStimezones.csv")
row.names(UStz) <- UStz$Abbreviation
UStz$Abbreviation <- NULL
# convert into time
UStz$Offset.standard<-hms(UStz$Offset.standard)
UStz$Offset.daylight<-hms(UStz$Offset.daylight)