setwd("~/EBOVPhyloHawkes")
library(ggplot2)
library(reshape2)

#source("grid_arrange.R")

set.seed(666)

blue <- 60
red <- 190
brown <- 40
yellow <- 205
purple <- 203
green <- 130

rps <- 100
set.seed(4)

bluePath <- cumsum(rnorm(blue*rps))
redPath  <- cumsum(rnorm(red*rps)) 
brownPath <- cumsum(rnorm(brown*rps)) + bluePath[length(bluePath)]
yellowPath <- cumsum(rnorm(yellow*rps)) + bluePath[length(bluePath)]
purplePath <- cumsum(rnorm(purple*rps)) + brownPath[length(brownPath)]
greenPath <- cumsum(rnorm(green*rps)) + brownPath[length(brownPath)]
Displacements <- c(bluePath,redPath,brownPath,yellowPath,purplePath,greenPath)
Time <- c(1:(blue*rps),
          1:(red*rps),
          (blue*rps+1):(blue*rps+brown*rps),
          (blue*rps+1):(blue*rps+yellow*rps),
          (blue*rps+brown*rps+1):(blue*rps+brown*rps+purple*rps),
          (blue*rps+brown*rps+1):(blue*rps+brown*rps+green*rps))

df <- data.frame(Displacements,Time)
plot(df$Time,df$Displacements)

df$Colors <- c(rep("Blue",blue*rps),
               rep("Red",red*rps),
               rep("Brown",brown*rps),
               rep("Yellow",yellow*rps),
               rep("Purple",purple*rps),
               rep("Green",green*rps))
df$Colors <- factor(df$Colors)

gg <- ggplot(df,aes(x=Time,y=Displacements,color=Colors))+
  geom_segment(x = 0,y=0,yend=0,xend=max(Time),color="black") +
  geom_line(size=1.5,alpha=0.8) +
  scale_color_manual(values=c("steelblue3","tan4","yellowgreen","purple4","firebrick2","gold2")) +
  theme_void()+
  theme(legend.position = "none") 
gg

  