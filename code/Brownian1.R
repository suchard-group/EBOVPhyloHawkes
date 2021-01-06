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
Time <- c( seq(from=max(df$Time[df$Colors=="Red"])+1,
           to=(max(df$Time[df$Colors=="Red"])+12000),length.out=6000),
           seq(from=max(df$Time[df$Colors=="Yellow"])+1,
               to=(max(df$Time[df$Colors=="Yellow"])+12000),length.out=6000),
           seq(from=max(df$Time[df$Colors=="Purple"])+1,
               to=(max(df$Time[df$Colors=="Purple"])+12000),length.out=6000),
           seq(from=max(df$Time[df$Colors=="Green"])+1,
               to=(max(df$Time[df$Colors=="Green"])+12000),length.out=6000))
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

ggsave("figures/brownianMotion.png",device = "png", width = 5, height = 3)


# rates figure
d <- 1000
Displacements <- Displacements + abs(min(Displacements))
Time <- c( round(seq.int(from=max(df$Time[df$Colors=="Red"])-d+1,
               to=(max(df$Time[df$Colors=="Red"])+12000-d),length.out = 6000)),
           round(seq.int(from=max(df$Time[df$Colors=="Yellow"])+1-d,
               to=(max(df$Time[df$Colors=="Yellow"])+12000-d),length.out = 6000)),
           round(seq.int(from=max(df$Time[df$Colors=="Purple"])+1-d,
               to=(max(df$Time[df$Colors=="Purple"])+12000-d),length.out = 6000)),
           round(seq.int(from=max(df$Time[df$Colors=="Green"])+1-d,
               to=(max(df$Time[df$Colors=="Green"])+12000-d),length.out = 6000)))
Colors <- c(rep("Red",6000),
            rep("Yellow",6000),
            rep("Purple",6000),
            rep("Green",6000))
# Time2 <- min(Time):max(Time)
# Colors2 <- rep("Black",length(Time2))
#   
df4 <- data.frame(Displacements,Time,Colors)
df4$Colors <- factor(df4$Colors)
df4 <- dplyr::distinct(df4,Time,Colors,.keep_all=TRUE)
df4$Time[df4$Time %% 2 == 0] <- df4$Time[df4$Time %% 2 == 0] - 1


df5 <- aggregate(Displacements~Time,data=df4,sum) 
df5$Colors <- "Black"
#df6 <- merge(df4,df5)
df5 <- df5[,c("Displacements","Time","Colors")]
df5$Time <- df5$Time - 1000
df5$Displacements <- df5$Displacements + 200
df6 <- rbind(df4,df5)

gg <- ggplot(df6,aes(x=Time,y=Displacements,color=Colors))+
  geom_line(size=1.5,alpha=1) +
  scale_color_manual(values=c("#81a66c","#532383","#b63129","#afa750","black")) +
  theme_void()+
  theme(legend.position = "none") 
gg

ggsave("figures/additiveRate.png",device="png",width = 5,height=3)
