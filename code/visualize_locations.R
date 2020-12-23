setwd("~/EBOVPhyloHawkes/")

library(readr)
library(ggmap)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")

df <- read_table2("output/Makona_1610_Hawkes_Locations_Prior.log", skip = 3)
P  <- dim(df)[2]
R  <- dim(df)[1]
N  <- 1366 # number of locations
df <- df[,(P+1-2*N):P]
Locs <- list()
for (i in 1:R) {
  Locs[[i]] <- matrix(df[i,], byrow=TRUE, ncol=2) 
}

# get map
bb <- c(left=-17.5,
        bottom=3.5,
        right=-5.3,
        top=13)

bg <- get_stamenmap(bbox = bb,
                           zoom = 6,
                           maptype="toner-background")

                           #maptype="toner-2010")
gg <- ggmap(bg) 

gg1 <- gg + geom_point(data=data.frame(x=unlist(Locs[[R]][,1]),
                                       y=unlist(Locs[[R]][,2])),
                       alpha=0.5, color="red2",
                       aes(x=x,y=y),inherit.aes = FALSE) +
  annotate(geom = "label",fontface="bold",label="Guinea",x=-11,y=11,label.size=0.5) +
  annotate(geom = "label",fontface="bold",label="Sierra\nLeone",x=-13.5,y=7.5,label.size=0.5)+
  annotate(geom = "label",fontface="bold",label="Liberia",x=-8.3,y=5.8,label.size=0.5)+
  theme_nothing()
gg1
