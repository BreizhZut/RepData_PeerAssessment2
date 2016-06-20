# compute the total number of victims per type and year
cleanStormDam <- subset(cleanStorm,!is.na(propDam))
damageYear <- aggregate(cleanStormDam$propDam,by=list(cleanStormDam$type,year(cleanStormDam$bgndate)),"sum")
names(damageYear) <- c("type","year","damage")
## use the lattice system to plot the result
library(lattice)
p <- xyplot((damage/1e9)~year|type,data=damageYear,
            layout=c(2,4),
            aspect = "fill",
            ylab = "Damage [Billion $]",
            xlab = "year",
            pch=19,
            col="black",
            alpha=0.5,
            grid = TRUE,
            scales = list(y = list(log = 10, equispaced.log = FALSE)),
            ylim =c(1e-3,2e3)
            )

print(p)
