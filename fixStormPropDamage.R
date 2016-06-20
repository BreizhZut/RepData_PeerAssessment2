# init the unit aray
unitsexp <- rep(NA,nrow(stormData))

# fetch from stromData the units
#unitsexp[grep("[0-9]",as.character(stormData$PROPDMGEXP))] <- 10.**(as.numeric(
#    stormData$PROPDMGEXP[grep("[0-9]",as.character(stormData$PROPDMGEXP))]
#    ))
unitsexp[grep("[bB]",as.character(stormData$PROPDMGEXP))] <- 1E9
unitsexp[grep("[mM]",as.character(stormData$PROPDMGEXP))] <- 1E6
unitsexp[grep("[kK]",as.character(stormData$PROPDMGEXP))] <- 1E3

# check how many entries have been assigned
message(paste(
    "found units",sum(!is.na(unitsexp)),
    " out of ",sum(!is.na(stormData$PROPDMGEXP))
    ))
# check how many entries with units have assigned values
message(paste(
    "found values", sum(!is.na(unitsexp)&!is.na(stormData$PROPDMG)),
    " out of ",sum(!is.na(stormData$PROPDMGEXP))
    ))

noval <- !is.na(unitsexp)& (is.na(stormData$PROPDMG))
# set unit with no values to NA
if(sum(noval) > 0){
    message(paste("Missing number",sum(noval)))
    print(unique(stormData$PROPDMG[noval]))
    unitsexp[noval] <- NA
}

unitsexp[!is.na(unitsexp)] <- unitsexp[!is.na(unitsexp)] * stormData$PROPDMG[!is.na(unitsexp)]
nounits <- as.data.frame(table(as.character(
    stormData$PROPDMGEXP[is.na(unitsexp) & !is.na(stormData$PROPDMG)]
    )))
names(nounits) <- c("PROPDMGEXP","nb")
print(nounits)
rm(nounits)
PropDam <- unitsexp

# init the unit aray
unitsexp <- rep(NA,nrow(stormData))

# fetch from stromData the units
#unitsexp[grep("[0-9]",as.character(stormData$CROPDMGEXP))] <- 10.**(as.numeric(
#    stormData$CROPDMGEXP[grep("[0-9]",as.character(stormData$CROPDMGEXP))]
#    ))
unitsexp[grep("[bB]",as.character(stormData$CROPDMGEXP))] <- 1E9
unitsexp[grep("[mM]",as.character(stormData$CROPDMGEXP))] <- 1E6
unitsexp[grep("[kK]",as.character(stormData$CROPDMGEXP))] <- 1E3

# check how many entries have been assigned
message(paste(
    "found units",sum(!is.na(unitsexp)),
    " out of ",sum(!is.na(stormData$CROPDMGEXP))
    ))
# check how many entries with units have assigned values
message(paste(
    "found values", sum(!is.na(unitsexp)&!is.na(stormData$CROPDMG)),
    " out of ",sum(!is.na(stormData$CROPDMGEXP))
    ))

noval <- !is.na(unitsexp)& (is.na(stormData$CROPDMG))
# set unit with no values to NA
message(paste("Missing number",sum(noval)))
if(sum(noval) > 0){
    message(paste("Missing number",sum(noval)))
    print(unique(stormData$CROPDMG[noval]))
    unitsexp[noval] <- NA
}

unitsexp[!is.na(unitsexp)] <- unitsexp[!is.na(unitsexp)] * stormData$CROPDMG[!is.na(unitsexp)]

addval <- !is.na(PropDam) & !is.na(unitsexp)
newval <- is.na(PropDam) & !is.na(unitsexp)
PropDam[newval] <- unitsexp[newval]
PropDam[addval] <- PropDam[addval] + unitsexp[addval]
rm(list=c("noval","newval","addval"))

nounits <- as.data.frame(table(as.character(
    stormData$CROPDMGEXP[is.na(unitsexp) & !is.na(stormData$CROPDMG)]
    )))
names(nounits) <- c("CROPDMGEXP","nb")
print(nounits)
rm(nounits)
rm(unitsexp)

message(paste("Damage assigned",sum(!is.na(PropDam))," out of ",nrow(stormData)))
