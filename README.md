# RepData_PeerAssessment2


This project involves exploring the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.

Original source can be downloaded from [Storm data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2)


This directory contains the additional csv file created for this project: 
`UStimezones.csv`. This find associate for multiple time zones:

* its abbreviation (first column)
* its name (second columns), 
* and the corresponding time different to the UTC timezone 
    * for standard time (third column)
    * for daylight saving (fourth column) if relevant

## Objectif

* Produce a `Rmd` file detailing the study. It must contain: 
	*   a synopsis
	*   a processing section (starting from the original data)
	*   a result section
	*   between 1 and 3 figures
	*   display all the code 
* Pubish the document on [RPubs](http://rpubs.com/)

## Content

We provide in this repository, the necessary files needed to complete this project and the script necessary to reproduce the results.

### Study
* Rmd source: `RidersOnTheStorms.pdf`
* Resulting pdf: `RidersOnTheStorms.pdf`
* The result can also be uploaded as:  
[Tornadoes vs Hurricanes: Exploratory analysis of the health and economic effect of storm in the United States](http://rpubs.com/BreaizhZut/190758) 

### Processing scripts

Script are the following:

* `readStormData.R` if the `StormData` `data.frame` has not been loaded read file `r sourcedata` into `data.frame` `StormData`
* `readUStimezones.R` read `data.frame` `UStz` from file `UStimezones.csv` created for this project. Requires package `lubridate`
* `fixStormTimes.R` uses columns `BGNDATE`, `BGNTIME`,`ENDNDATE`, `ENDTIME` and `TIMEZONE` of `data.frame` `StormData` to create:
    * `POSIXct` vector `bgndate`
    * `POSIXct` vector `enddate`
    * Require `readUStimezones.R` and package `lubridate`
* `fixStormEventsType.R` uses column `EVTYPE` of `data.frame` `StormData` and re-categorizes events in new character vector `evsorted`
* `fixStormPropDamage.R` uses columns `PROPDMG`, `PROPDMGEXP`, `CROPDMG`, `CROPDMGEXP` of `data.frame` `StormData` to create a numeric vector `PropDam` corresponding to the damage estimate.
* `cleanStormData.R` the main script creates `data.frame` `cleanStorm`
    * calls `readStormData.R`
    * calls `fixStormTimes.R` if `bgndate` and `enddate` have not been created
    * calls `fixStormEventsType.R` if `evsorted` has not been created
    * calls `fixStormPropDamage.R` if `PropDam` has not been created
    * collect these vectors into a new `data.frame` `cleanStorm`
    * clear memory of vectors `bgndate`, `enddate`, `evsorted` and `PropDam`.     If one of the previous script was use independently, this script won't rerun the full analysis, on the first call, but will on the second.  

### Analysis scripts

The figure can be regenerated using the following script

* `plot_victims_per_type.R` (figure 1)
    * calls `cleanStormData.R` if the tidy data set `cleanStorm` has not been created
    * displays a panel figure of the total number of victim per year as a function of time
    * requires packages `lubridate` and `lattice`
* `plot_damage_per_type.R`  (figure 2)
    * calls `cleanStormData.R` if the tidy data set `cleanStorm` has not been created
    * displays a panel figure of the total number damage estimate per year as a function of time
    * requires packages `lubridate` and `lattice`
* `plot_victim_damage.R` (figure 3)
    * calls `cleanStormData.R` if the tidy data set `cleanStorm` has not been created
     * displays a scatter plot of the average number of damage opposed to the damage estimate
    * requires packages `ggplot2` and `lattice`