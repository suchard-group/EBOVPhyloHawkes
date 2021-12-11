setwd("~/EBOVPhyloHawkes/")
library(coda)

# df <- readr::read_table2("output/Makona_1610_Hawkes_Locations_GLM.log", 
#                          skip = 3)
# 
# df <- df[,5:12]

# df <- readRDS("output/thinnedSample.rds")
# df <- df[,1:8]

df <- read_table2("output/final.log", skip = 3)
#df <- df[,c(-1,-7)]
df2 <- read_table2("output/final2.log", skip = 3)
#df2 <- df2[,c(-1,-7)]
df3 <- read_table2("output/final3a.log", skip = 3)
#df3 <- df3[,c(-1,-7)]
df4 <- read_table2("output/final3.log", skip = 3)
df4 <- df4[df4$state <= 100500000, ]
#df4 <- df4[,c(-1,-7)]

df <- rbind(df,df2,df3,df4)

time.effect <- df$time.effect # time effect
theta0      <- df$theta

d1  <- dim(df)[1]
d2 <- dim(df)[2]
df2 <- df[,13:d2]
df2 <- cbind(df2,matrix(1,d1,21811))

df <- readRDS("data/originalOrderDates.rds") 

df2 <- theta0*df2*exp(outer(time.effect,df$dateDecimal-min(df$dateDecimal)))

postMeans <- colMeans(df2) 
sum(postMeans>1)
