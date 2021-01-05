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

# add rate functions
lowest <- min(df$Displacements)-50
expfun <- dexp(seq(from=0,to=5,length.out = 6000))-1
Displacements <- c(expfun*abs(redPath[length(redPath)]-lowest)+redPath[length(redPath)],
                   expfun*abs(yellowPath[length(yellowPath)]-lowest)+yellowPath[length(yellowPath)],
                   expfun*abs(purplePath[length(purplePath)]-lowest)+purplePath[length(purplePath)],
                   expfun*abs(greenPath[length(greenPath)]-lowest)+greenPath[length(greenPath)])
Time <- c( (max(df$Time[df$Colors=="Red"])+1):(max(df$Time[df$Colors=="Red"])+6000),
           (max(df$Time[df$Colors=="Yellow"])+1):(max(df$Time[df$Colors=="Yellow"])+6000),
           (max(df$Time[df$Colors=="Purple"])+1):(max(df$Time[df$Colors=="Purple"])+6000),
           (max(df$Time[df$Colors=="Green"])+1):(max(df$Time[df$Colors=="Green"])+6000))
Colors <- c(rep("Red",6000),
            rep("Yellow",6000),
            rep("Purple",6000),
            rep("Green",6000))
df2 <- data.frame(Displacements,Time,Colors)

df3 <- rbind(df,df2)

gg <- ggplot(df3,aes(x=Time,y=Displacements,color=Colors))+
  #geom_segment(x = 0,y=0,yend=0,xend=max(Time),color="black",size=1.5) +
  geom_line(size=1.5,alpha=1) +
  scale_color_manual(values=c("#5a8ba0","#845d36","#81a66c","#532383","#b63129","#afa750")) +
  theme_void()+
  theme(legend.position = "none") 
gg

  