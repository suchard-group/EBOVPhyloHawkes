setwd("~/EBOVPhyloHawkes/")

library(readr)
library(ggmap)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")

df <- read_table2("output/locations.log", skip = 3)
R  <- dim(df)[1]
df2 <- df[,-1]

Locs <- matrix(df2[R,], byrow=TRUE, ncol=2) 
readRDS("data/originalOrderDates.rds") # df3
# temporary fix remove one line
Locs <- Locs[-1,] # TODO: investigate
df3 <- df3[order(df3$dateDecimal),]
df3$Sequenced <- factor(df3$Sequenced)
df4 <- data.frame(x=unlist(Locs[,1]),y=unlist(Locs[,2]),
                  Sequenced=df3$Sequenced)

df4 <- df4[order(df4$Sequenced,decreasing = TRUE),]

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

gg1 <- gg + geom_point(data=df4,
                       alpha=1, size=0.1,
                       aes(x=x,y=y,color=Sequenced),inherit.aes = FALSE) +
  annotate(geom = "text",fontface="bold",label="Guinea",x=-11.1,y=11,size=3) +
  annotate(geom = "text",fontface="bold",color="white",label="Sierra\nLeone",x=-13.7,y=7.5,size=3)+
  annotate(geom = "text",fontface="bold",label="Liberia",x=-8.3,y=5.5,size=3)+
  theme_nothing()
gg1

ggsave("figures/LocationsPlot.png",gg1,device="png",width = 4,height = 3)

