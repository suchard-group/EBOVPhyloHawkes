setwd("~/EBOVPhyloHawkes/")

library(readr)
library(stringr)
library(lubridate)

df <- read_csv("data/taxaWithLocations.csv", col_names = FALSE)
dates <- str_sub(df$X1,-10,-1)
dates2 <- decimal_date(as.Date(dates))

df2 <- read_csv("data/unsequencedData.csv")

df3 <- data.frame(dateDecimal=c(dates2,df2$dateDecimal),
                  Sequenced=c(rep("Sequenced",1367),rep("Unsequenced",21811)))
df3$originalOrder <- 1:23178
saveRDS(df3,file="data/originalOrderDates.rds")
