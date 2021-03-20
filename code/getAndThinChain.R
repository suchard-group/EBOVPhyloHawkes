setwd("~/EBOVPhyloHawkes/")

library(readr)

df <- read_table2("output/Makona_1610_Hawkes_Locations_GLM.log", 
                                                skip = 3)

df <- df[df$state > 5000000,]
df <- df[df$state %% 10000 == 0,]
df <- df[df$state <= 20000000,]

df <- df[,5:dim(df)[2]]

saveRDS(df,"output/thinnedSample.rds")
