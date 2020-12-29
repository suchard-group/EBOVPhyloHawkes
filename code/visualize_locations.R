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


################################################################################

library("ggplot2")
theme_set(theme_bw())
library("sf")

library("rnaturalearth")
library("rnaturalearthdata")
library(rgeos)
library(ggspatial)
library(data.table)

world <- ne_countries(scale = "medium", returnclass = "sf")

world_points<- st_centroid(world)
world_points <- cbind(world, st_coordinates(st_centroid(world$geometry)))
world_points <- world_points[world_points$sovereignt %in% c("Guinea","Sierra Leone","Liberia"),]

palet <- RColorBrewer::brewer.pal(11,"Spectral")

gg2 <- ggplot(data = world) + geom_sf(fill= "antiquewhite") +
  geom_point(data=df4,
             alpha=0.5, size=1, pch=21,color="black",
             aes(x=x,y=y,fill=Sequenced),inherit.aes = FALSE) +
  #scale_fill_manual(values=c(palet[9],palet[3]))+
  annotate(geom = "text",fontface="bold",label="Guinea",x=-11.1,y=11,size=4) +
  annotate(geom = "text",fontface="bold",label="Sierra\nLeone",x=-13,y=7,size=4)+
  annotate(geom = "text",fontface="bold",label="Liberia",x=-8.3,y=5.5,size=4)+
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.5, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering) +
  coord_sf(xlim = c(-17.5, -5.3), ylim = c(3.5, 13), expand = FALSE) +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Viral case data from the 2014-2016 Ebola outbreak") +
  guides(fill = guide_legend(override.aes = list(size=5),
                             title="Viral RNA"))+
  theme(panel.grid.major = element_line(color = gray(.5),
                                        linetype = "dashed", size = 0.5),
        panel.background = element_rect(fill = "aliceblue"),
        legend.box.spacing = unit(0.0, "cm"))
        # legend.box.margin = margin(0, 0, 0.0, 0, "cm"),
        # legend.margin = margin(0.0, 0.0, 0.0, 0.0, "cm")) +
  # guides(fill = guide_legend(override.aes = list(size=3),
  #                              title="Viral RNA"))

gg2

ggsave("figures/LocationsPlot.png",gg2,device="png",width = 5,height = 4)

