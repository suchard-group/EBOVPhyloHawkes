setwd("~/EBOVPhyloHawkes/")

# df <- readr::read_table2("output/Makona_1610_Hawkes_Locations_GLM.log",
#                          skip = 3)
df <- readRDS("output/thinnedSample.rds")

d1 <- dim(df)[1]
d2 <- dim(df)[2]
df2 <- df[,9:d2]

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
