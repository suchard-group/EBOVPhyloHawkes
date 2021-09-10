setwd("~/EBOVPhyloHawkes/")

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

d1 <- dim(df)[1]
d2 <- dim(df)[2]
df2 <- df[,13:d2]

lower <- apply( df2 , 2 , quantile , probs = 0.025)
upper <- apply( df2 , 2 , quantile , probs = 0.975)
higher <- 1 <lower
below  <- 1 > upper

taxaWithLocations <- readr::read_csv("data/nodes_with_locations_ordered_by_tree.txt",col_names = FALSE)

high_taxa <- taxaWithLocations[higher,]
write.table(high_taxa,file = "output/high_signif_taxa.csv",col.names = FALSE,
          quote = FALSE,row.names = FALSE)

low_taxa <- taxaWithLocations[below,]
write.csv(low_taxa,file = "output/low_signif_taxa.csv",col.names = FALSE,
          quote = FALSE,row.names = FALSE)
