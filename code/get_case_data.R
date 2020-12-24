setwd("~/EBOVPhyloHawkes/")

library(readr)
library(stringr)

df1 <- read_csv("data/just_cases/Guinea-2016-05-11.csv")
df2 <- read_csv("data/just_cases/Liberia-2016-05-11.csv")
df3 <- read_csv("data/just_cases/SL-2016-05-11.csv")

df <- rbind(df1,df2,df3)
remove(df1)
remove(df2)
remove(df3)

df <- df[df$`Indicator type`=="New",]
df <- df[,c("Country","Location","Case definition","Ebola data source",
            "Epi week", "Numeric")]
df <- df[order(df$Country,df$Location,df$`Epi week`),]
df <- df[complete.cases(df),]

# combine confirmed and probable cases
df2 <- aggregate(Numeric ~ Country + Location +
                    `Ebola data source` + `Epi week`,FUN=sum,data=df)

# take max of situation report and patient databases
df3 <- aggregate(Numeric ~ Country + Location + `Epi week`,
                 FUN=max,data=df2)
df <- df3
remove(df2)
remove(df3)

# remove rows for which count == 0
df <- df[df$Numeric > 0,]

# translate date to year decimal format
df$year <- str_match(df$`Epi week`,"\\(\\s*(.*?)\\s*\\-")[,2]
df$year <- as.numeric(df$year)
df$week <- str_match(df$`Epi week`,"\\-W\\s*(.*?)\\s*\\)")[,2]
df$week <- as.numeric(df$week)/52
df$dateDecimal <- df$year + df$week

#
### add centroid and km2 values
#

# change locations format to be same as location data format
locs_df <- read.csv("data/Location_Data_2016-05-27.csv") # reference data

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

df$Location <- tolower(df$Location) # get caps right 
df$Location <- sapply(df$Location,simpleCap)
df$Location <- str_replace_all(df$Location, fixed(" "), "") # remove whitespace
df$Location <- str_replace_all(df$Location, fixed("Area"), "") # remove area from western area
df$Location <- str_replace_all(df$Location, fixed("'"), "") # re nzerekore

# check whether df$Locations %in% locs_df$Locations
df$Location[! df$Location %in%  locs_df$Location]
df$Location <- str_replace_all(df$Location, fixed("Rivercess"), "RiverCess") # re rivercess

df$Location[! df$Location %in%  locs_df$Location]
df$Location <- str_replace_all(df$Location, fixed("Yomou"), "Yamou") # re yamou

df$Location[! df$Location %in%  locs_df$Location] # we're good to go

df <- merge(df,locs_df,by="Location")
df <- df[,c("Country","Location","Pop_Centroid_X",
            "Pop_Centroid_Y","Area_km_2","dateDecimal","Numeric")]

# no "uncount"
library(dplyr)
library(tidyr)

df2 <- df %>% pivot_longer(cols = Numeric) %>% uncount(value)
df <- df2[,-dim(df)[2]]

write.csv(df,file="data/unsequencedData.csv",quote = FALSE)
