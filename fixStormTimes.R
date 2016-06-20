source("readUStimezones.R")
library(lubridate)

message("Checking dates")
# Look at the data before correction
bgnexist <- !is.na(stormData$BGNDATE)
endexist <- !is.na(stormData$ENDDATE)

# first delete midnight
bgndate <- sub(" 0:00:00","",stormData$BGNDATE,fixed=T)
enddate <- sub(" 0:00:00","",stormData$ENDDATE,fixed=T)
stormData$bgn <- NULL
stormData$end <- NULL

message("Reformatting times BGNTIME")
# Fixing BGNTIME
# copy time
evtime <- stormData$BGNTIME
evtime[!bgnexist] <- NA
# Init time convertion
timeshift <- hms(rep("0:00:00",nrow(stormData)))
# First deal with the timezone 
for(tz_loc in unique(stormData$TIMEZONE)) {
    selecttz <- stormData$TIMEZONE==tz_loc
    timeshift[selecttz] <- -1.*UStz[tz_loc,"Offset.standard"]
}
rm(list=c("tz_loc","selecttz"))
# remove spaces 
evtime <- gsub(" ","",evtime)
# now lets look at the PM/AM issue
isPM <- grepl("PM",evtime) & !grepl("^12",evtime)
# now let's remove the PM/AM 
evtime <- sub("[PA]M","",evtime)
# correct timeshift
timeshift[isPM] <- timeshift[isPM] + hms("12:00:00")
rm(isPM)
# Replace 2400 by 0000
evtime <- sub("2400","0000",evtime,fixed=T)
# Replace O by 0
evtime <- sub("O","0",evtime)
# Correct missing 0
badform <- grep("^[0-9][0-9][0-9]$",evtime)
evtime[badform] <- paste0("0",evtime[badform])
message(paste("  Missing 0:",length(badform)))
# Check minute permutation and replace them 4 occurence (better than putting 0)
worsetime <- grep("^[0-9][0-9][7-9][0-5]",evtime)
sb1 <- substring(evtime[worsetime],4)
sb2 <- substring(evtime[worsetime],3)
substring(evtime[worsetime],4) <-sb2
substring(evtime[worsetime],3) <-sb1
rm(list=c("sb1","sb2"))
message(paste("  Reversed minute digits:",length(worsetime)))
rm(worsetime)
# Check hour digits permutation and replace them 
worsetime <- grep("^[3-9][0-2][0-5][0-9]",evtime)
sb1 <- substring(evtime[worsetime],1)
sb2 <- substring(evtime[worsetime],2)
substring(evtime[worsetime],1) <-sb2
substring(evtime[worsetime],2) <-sb1
rm(list=c("sb1","sb2"))
message(paste("  Reversed hour digits:",length(worsetime)))
rm(worsetime)
# find time not formatted properly
badform <-grep("^[0-2][0-9][0-5][0-9]",evtime)
if(length(badform) > 0){
    # Reformat times
    evtime[badform] <- paste(
        substring(evtime[badform],1,2),
        substring(evtime[badform],3,4),
        "00",
        sep=":"
    )
}
rm(badform)
# set time to midnight is none was provided or format could not be c
notime <- bgnexist & (is.na(evtime) | !grepl(":",evtime))
evtime[notime] <- "0:00:00"
timeshift[notime] <- hms("0:00:00")
message(paste("Set to midnight",sum(notime)))
toreset <-as.character(stormData$BGNTIME[notime])
resettime <- data.frame(table(as.factor(toreset)))
names(resettime) <- c("BGNTIME","nb")
print(resettime)
rm(list=c("notime","resettime","toreset"))
# now add our time to the date
bgndate[bgnexist] <- paste(bgndate[bgnexist],evtime[bgnexist])
# convert into POSIXct object
bgndate <- mdy_hms(bgndate,tz="UTC")
# take timezone into account and PM shif
bgndate[bgnexist] <- bgndate[bgnexist] + timeshift[bgnexist]
rm(timeshift)
rm(evtime)
stormData$bgn <- bgndate
message("BGNDATE interpretation")
print(head(stormData[bgnexist,c("BGNDATE","BGNTIME","TIMEZONE","bgn")]))
print(tail(stormData[bgnexist,c("BGNDATE","BGNTIME","TIMEZONE","bgn")]))

failed <- bgnexist & is.na(stormData$bgn)
if(sum(failed)){
    print("Failed to parse")
    print(head(stormData[failed,c("BGNDATE","BGNTIME","TIMEZONE","bgn")]))
}
rm(failed)

message("Reformatting times ENDTIME")
# Fixing ENDTIME
# copy time make all letter upper case
evtime <- toupper(stormData$ENDTIME)
evtime[!endexist] <- NA
# Init time convertion
timeshift <- hms(rep("0:00:00",nrow(stormData)))
# First deal with the timezone 
for(tz_loc in unique(stormData$TIMEZONE)) {
    selecttz <- stormData$TIMEZONE==tz_loc
    timeshift[selecttz] <- -1.*UStz[tz_loc,"Offset.standard"]
}
# Take into account the timezone written in the time
for(tz_loc in unique(stormData$TIMEZONE)) {
    selectbadtz <- grepl(tz_loc,evtime) & stormData$TIMEZONE!=tz_loc
    if(sum(selectbadtz) > 0 ) {
        timeshift[selectbadtz] <- -1*UStz[tz_loc,"Offset.standard"]
#        print(paste("Timezone corrected",tz_loc,sum(selecttz)))
#        print(head(stormData[selecttz,c("ENDTIME","TIMEZONE")]))
    }
#    selecttz <- grepl(tz_loc,evtime)
#    print(paste("Timezone included",tz_loc,sum(selecttz),"bad",sum(selectbadtz)))
    rm(selectbadtz)
    # Remove the timezone we find in order to avoid error
    evtime <- sub(tz_loc,"",evtime)
}
rm(list=c("tz_loc","selecttz"))
# remove spaces 
evtime <- gsub(" ","",evtime)
# now lets look at the PM/AM issue
isPM <- grepl("PM",evtime) & !grepl("^12",evtime)
# correct timeshift
timeshift[isPM] <- timeshift[isPM] + hms("12:00:00")
rm(isPM)
# now let's remove the PM/AM 
evtime <- sub("[PA]M","",evtime)
# Replace 2400 by 0000
evtime <- sub("2400","0000",evtime,fixed=T)
# Replace O by 0
evtime <- sub("O","0",evtime)
# Correct missing 0
badform <- grep("^[0-9][0-9][0-9]$",evtime)
evtime[badform] <- paste0("0",evtime[badform])
message(paste("  Missing 0:",length(badform)))
# Check minute permutation and replace them
worsetime <- grep("^[0-9][0-9][7-9][0-5]",evtime)
sb1 <- substring(evtime[worsetime],4)
sb2 <- substring(evtime[worsetime],3)
substring(evtime[worsetime],4) <-sb2
substring(evtime[worsetime],3) <-sb1
rm(list=c("sb1","sb2"))
message(paste("  Reversed minute digits:",length(worsetime)))
rm(worsetime)
# Check hour digits permutation and replace them
worsetime <- grep("^[3-9][0-2][0-5][0-9]",evtime)
sb1 <- substring(evtime[worsetime],1)
sb2 <- substring(evtime[worsetime],2)
substring(evtime[worsetime],1) <-sb2
substring(evtime[worsetime],2) <-sb1
rm(list=c("sb1","sb2"))
message(paste("  Reversed hour digits:",length(worsetime)))
rm(worsetime)
# find time not formatted properly
badform <-grep("^[0-2][0-9][0-5][0-9]",evtime)
if(length(badform) > 0){
    # Reformat times
    evtime[badform] <- paste(
        substring(evtime[badform],1,2),
        substring(evtime[badform],3,4),
        "00",
        sep=":"
    )
}
rm(badform)
# set time to midnight is none was provided
notime <- endexist & (is.na(evtime) | !grepl(":",evtime))
message(paste("Set to midnight",sum(notime)))
toreset <-as.character(stormData$ENDTIME[notime])
resettime <- data.frame(table(as.factor(toreset)))
names(resettime) <- c("ENDTIME","nb")
print(resettime)
evtime[notime] <- "0:00:00"
timeshift[notime] <- hms("0:00:00")
rm(list=c("notime","resettime","toreset"))
# now add our time to the date
enddate[endexist] <- paste(enddate[endexist],evtime[endexist])
# convert into POSIXct object
enddate <- mdy_hms(enddate,tz="UTC")
# take timezone into account and PM shif
enddate[endexist] <- enddate[endexist] + timeshift[endexist]
rm(timeshift)
rm(evtime)
stormData$end <- enddate
message("ENDDATE interpretation")
print(head(stormData[endexist,c("ENDDATE","ENDTIME","TIMEZONE","end")]))
print(tail(stormData[endexist,c("ENDDATE","ENDTIME","TIMEZONE","end")]))

failed <- endexist & is.na(stormData$end)
if(sum(failed)){
    print("Failed to parse")
    print(stormData[failed,c("ENDDATE","ENDTIME","TIMEZONE","end")])
}
rm(failed)
rm(list=c("bgnexist","endexist"))
