## use each script to generate new entry
source("readStorm.R")
if(!exists("bgndate") | !exists("enddate")) {
    source("fixStormTimes.R")
}
if(!exists("evsorted")) {
    source("sortStormEventsType.R")
}
if(!exists("PropDam")){
    source("fixStormPropDamage.R")
}
## With these differents script we have made new entries
## Let's make a sample as complete as possible


## First we need the date (time)
## Check for entries with enddate but no bgndate
misbgn <- is.na(bgndate) & !is.na(enddate)
if(sum(misbgn)>0){
    message(paste("Missing start date ",sum(misbgn)))
    # set the begin date as the begin one
    bgndate[misbgn] <- enddate[misbgn]
}
## Second, among those we want only events we could classify
mistype    <- is.na(evsorted) & !is.na(bgndate)
outtype    <- !is.na(evsorted) & is.na(bgndate)
fullselect <- !is.na(bgndate) & !is.na(evsorted)
## Check we don't have any issue with fatalisties or injuries
misvictim  <- fullselect & (is.na(stormData$FATALITIES) | is.na(stormData$INJURIES))
outvictim  <- !fullselect & (stormData$FATALITIES > 0 | stormData$INJURIES >0)
## Check we don't have any issue with Property damage
mispropdam <- fullselect & is.na(PropDam)
outpropdam <- !fullselect & !is.na(PropDam)

## prepare a matrix to print out errors
selectcount <- c(
    nrow(stormData),
    sum(fullselect),
    sum(mistype),
    sum(outtype),
    sum(misvictim) ,
    sum(outvictim) ,
    sum(mispropdam) ,
    sum(outpropdam)
    )
selectcount <- as.matrix(selectcount,ncol=1)
rownames(selectcount) <- c(
    "total",
    "select",
    "na.type",
    "out.type",
    "na.victim",
    "out.victim",
    "na.propdam",
    "out.propdam"
    )
colnames(selectcount) <- "nb of entries"

print(selectcount)
listtypeerr<-as.data.frame(table(as.character(stormData$EVTYPE[outvictim|outpropdam])))
names(listtypeerr) <-c("EVTYPE","nb of entries")
print(listtypeerr)
rm(list=c("mistype","outtype","misvictim","outvictim","mispropdam","outpropdam"))
## Prepare a clean data.frame
cleanStorm <- data.frame(
    state   = stormData$STATE[fullselect],
    county  = stormData$COUNTYNAME[fullselect],
    bgndate = bgndate[fullselect],
    enddate = enddate[fullselect],
    type    = evsorted[fullselect],
    propDam = PropDam[fullselect],
    victim  = stormData$FATALITIES[fullselect]+stormData$INJURIES[fullselect]
)
#rm(list=c("bgndate","enddate","evsorted","PropDam"))
rm(fullselect)
