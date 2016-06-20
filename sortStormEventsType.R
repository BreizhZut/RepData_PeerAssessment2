message("Sorting event types") 
message(paste("before correction",nlevels(as.factor(stormData$EVTYPE))))
# correct evtype by captilizing
unsortedev <- stormData$EVTYPE
unsortedev <- toupper(unsortedev)
# correct for spelling and cleaning up
unsortedev <- sub("AVALANCE","AVALANCHE",unsortedev)
unsortedev <- sub("COSTAL","COASTAL",unsortedev)
unsortedev <- sub("DEVEL","DEVIL",unsortedev)
unsortedev <- sub("DRIEST","DRYEST",unsortedev)
unsortedev <- sub("FLOOODING","FLOODING",unsortedev)
unsortedev <- sub("LIGNTNING","LIGHTNING",unsortedev)
unsortedev <- sub("LIGTNING","LIGHTNING",unsortedev)
unsortedev <- sub("LIGHTING","LIGHTNING",unsortedev)
unsortedev <- sub("TEMPERATURES","TEMPERATURE",unsortedev)
unsortedev <- sub("RECORD TEMPERATURE","TEMPERATURE RECORD",unsortedev)
unsortedev <- sub("TORNDO","TORNADO",unsortedev)
unsortedev <- sub("TORNDAO","TORNADO",unsortedev)
unsortedev <- sub("REMNANTS OF FLOYD","HURRICANE FLOYD",unsortedev)
unsortedev <- sub("VOG","FOG",unsortedev)
unsortedev <- sub("WAYTER","WATER",unsortedev)
unsortedev <- sub("WND","WIND",unsortedev)
unsortedev <- sub("WINTRY","WINTER",unsortedev)
unsortedev <- sub("WINTERY","WINTER",unsortedev)
unsortedev <- sub("/"," ",unsortedev)
unsortedev <- sub(" AND "," ",unsortedev)
unsortedev[grep("SUMMARY",unsortedev)] <- "SUMMARY"
#unsortedev[grepl("TEMPERATURE",unsortedev) & grepl("RECORD",unsortedev)] <- "TEMPERATURE RECORD"
message(paste("after correction",nlevels(as.factor(unsortedev))))

# set new variable 
evsorted <- rep(NA,length(unsortedev))

evsorted[grepl("TROPICAL",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"
evsorted[grepl("HURRICANE",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"
evsorted[grepl("TYPHOON",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"
evsorted[grepl("STORM",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"
evsorted[grepl("WIND",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"
evsorted[grepl("TURBULENCE",unsortedev) & is.na(evsorted)] <- "Storm/Hurricane/Wind"


evsorted[grepl("THUNDER",unsortedev) & is.na(evsorted)] <- "Thunder"
evsorted[grepl("LIGHTNING",unsortedev) & is.na(evsorted)] <- "Thunder"
evsorted[grepl("TSTM",unsortedev) & is.na(evsorted)] <- "Thunder"

evsorted[grepl("WALL CLOUD",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("TORNADO",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("FUNNEL",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("ROTATING",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("GUSTNADO",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("LANDSPOUT",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("WATERSPOUT",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("DUST DEVIL",unsortedev) & is.na(evsorted)] <- "Tornado"
evsorted[grepl("MICROBURST",unsortedev) & is.na(evsorted)] <- "Tornado"

evsorted[grepl("FLOOD",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("FLD",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("DAM",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("STREAM",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("MUD",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("SLIDE",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("SLUMP",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"
evsorted[grepl("AVALANCHE",unsortedev) & is.na(evsorted)] <- "Flood/Slide/Avalanche"

evsorted[grepl("VOLCANIC",unsortedev) & is.na(evsorted)] <- "Volcanic/Fire"
evsorted[grepl("SMOKE",unsortedev) & is.na(evsorted)] <- "Volcanic/Fire"
evsorted[grepl("FIRE",unsortedev) & is.na(evsorted)] <- "Volcanic/Fire"
evsorted[grepl("RED FLAG CRITERIA",unsortedev) & is.na(evsorted)] <- "Volcanic/Fire"

evsorted[grepl("MARINE",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("COASTAL",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("WAVE",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("CURRENT",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("TIDE",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("SEAS",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("SURF",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("BEACH",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("SWELLS",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("DROWNING",unsortedev) & is.na(evsorted)] <- "Coastal"
evsorted[grepl("TSUNAMI",unsortedev) & is.na(evsorted)] <- "Coastal"

evsorted[grepl("RAIN",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("DOWNBURST",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("WATER",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("PRECIP",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("WET",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("FOG",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("HEAVY",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("SLEET",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("BLIZZARD",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("SNOW",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("ICE",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("HAIL",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("FROST",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("GLAZE",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("ICY",unsortedev) & is.na(evsorted)] <- "Precipitations"
evsorted[grepl("MIX",unsortedev) & is.na(evsorted)] <- "Precipitations"


evsorted[grepl("TEMPERATURE RECORD",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("HYPOTHERMIA",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("LOW",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("HOT",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("DRY",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("HEAT",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("WARM",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("DRYEST",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("DUST",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("HYPERTHERMIA",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("DROUGH",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("SEICHE",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("HIGH",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("WINTER",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("COLD",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("COOL",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("FREEZE",unsortedev) & is.na(evsorted)] <- "Temperature Record"
evsorted[grepl("FREEZING",unsortedev) & is.na(evsorted)] <- "Temperature Record"


#evsorted[is.na(evsorted)] <- "Other"
unsortlist<- as.data.frame(table(as.factor(unsortedev[is.na(evsorted)])))
names(unsortlist)<-c("entry","nb")
message(paste("Entries remaining",sum(unsortlist$nb))) 
print(unsortlist)
sortlist<- data.frame(table(as.factor(evsorted)))
names(sortlist)<-c("EVTYPE","nb")
message("New categories") 
print(sortlist)

rm(list=c("sortlist","unsortlist","unsortedev"))

