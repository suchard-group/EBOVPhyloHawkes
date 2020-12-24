setwd("~/EBOVPhyloHawkes/")

library(readr)

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

# TODO: translate date to year decimal format

# TODO: add centroid values

# TODO: add km2 values



