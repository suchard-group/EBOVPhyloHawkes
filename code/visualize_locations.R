setwd("~/EBOVPhyloHawkes/")

library(readr)
library(ggmap)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")

df <- read_table2("output/Makona_1610_Hawkes.log", skip = 3)
P  <- dim(df)[2]
R  <- dim(df)[1]
N  <- 1366 # number of locations
df <- df[,(P+1-2*N):P]
Locs <- list()
for (i in 1:R) {
  Locs[[i]] <- matrix(df[i,], byrow=TRUE, ncol=2) 
}

# get map
bb <- c(left=-15.5,
        bottom=4,
        right=-7.3,
        top=12.7)

bg <- get_stamenmap(bbox = bb,
                           zoom = 6,
                           maptype="toner-2010")
gg <- ggmap(bg)

gg1 <- gg + geom_point(data=data.frame(x=unlist(Locs[[R]][,1]),
                                       y=unlist(Locs[[R]][,2])),
                       aes(color="red",x=x,y=y),inherit.aes = FALSE) 
gg1
