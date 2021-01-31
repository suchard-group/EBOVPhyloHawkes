setwd("~/EBOVPhyloHawkes/")
library(coda)

df <- readr::read_table2("output/Makona_1610_Hawkes_Locations_Prior_Run1.log", 
                         skip = 3)

df <- df[,5:11]

df[,1] <- df[,1] + df[,2]
df[,c(1,2,4,7)] <- 1/df[,c(1,2,4,7)] # precisions to lengthscales
df[,c(1,2)] <- df[,c(1,2)]*111 # degrees to km
df[,4] <- df[,4] * 365
df[,7] <- sqrt(df[,7])

df <- df[1000:dim(df)[1],] # remove burnin

df$theta <- df$theta / (df$theta + df$mu0)

df <- as.mcmc(df)

summary(df)