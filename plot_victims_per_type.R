if(!exists("cleanStorm")) {
    source("cleanStormData.R")
}

## compute the total number of victims per type and year
cleanStormvic <- subset(cleanStorm,!is.na(victim))
victimYear <- aggregate(cleanStorm$victim,by=list(cleanStormvic$type,year(cleanStormvic$bgndate)),"sum")
names(victimYear) <- c("type","year","victims")
## use the lattice system to plot the result
library(lattice)
p <- xyplot(victims~year|type,data=victimYear,
            layout=c(2,4),
            aspect = "fill",
            ylab = "nb of fatalities or injuries",
            xlab = "year",
            pch=19,
            col="black",
            grid = TRUE,
            alpha=0.5,
            scales = list(y = list(log = 10, equispaced.log = FALSE)),
            ylim =c(1,2e4)
            )

print(p)
