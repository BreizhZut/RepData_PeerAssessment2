if(!exists("cleanStorm")) {
    source("cleanStormData.R")
}
## subsetting data.frame with event having non zero impact on health and economy
cleanStormbad <- subset(
    cleanStorm,
    !is.na(cleanStorm$victim) &
    !is.na(cleanStorm$propDam) &
    cleanStorm$victim> 1 &
    cleanStorm$propDam>1e6
    )
library(lubridate)
## changing units to million $
cleanStormbad$propDam = cleanStormbad$propDam/1e6
## Computing mean per type and year
meandamage <- aggregate(cleanStormbad$propDam,by=list(cleanStormbad$type,year(cleanStormbad$bgndate)),"mean")
names(meandamage) <- c("type","year","mean.damage")
meanvictim <- aggregate(cleanStormbad$victim,by=list(cleanStormbad$type,year(cleanStormbad$bgndate)),"mean")
names(meanvictim) <- c("type","year","mean.victim")
## Keep count of the number of events
count <- aggregate(rep(1,nrow(cleanStormbad)),by=list(cleanStormbad$type,year(cleanStormbad$bgndate)),"sum")
names(count) <- c("type","year","count")
#print(head(meandamage))
#print(head(meanvictim))
#print(head(count))
## Merging data.frames
meantypeyear <- merge(meanvictim,meandamage,by=c("year","type"))
meantypeyear <- merge(meantypeyear,count,by=c("year","type"))
meantypeyear$count <- log10(meantypeyear$count)
rm(list=c("meanvictim","meandamage","count","cleanStormbad"))

print(head(meantypeyear))
library(ggplot2)
ggp <- ggplot(data=meantypeyear,aes(mean.victim,mean.damage)) +
    geom_point(aes(color=type,size=count),alpha=0.6)+
    scale_x_log10()+
    scale_y_log10()+
    labs(
        x="Nb of fatalities or injuries",
        y="Damage [Million $]",
        size="Nb of events [log]"
    ) +
    scale_color_manual(values=c("#707070", "#404000","#207070","#000080","#900090","#009000","#c00000"))+
    ## change theme
    theme_bw(base_family="Times")+
    ## Remove box around legend symbols
    theme(legend.key = element_blank())    

print(ggp)
