setwd("~/EBOVPhyloHawkes/")

library(ggplot2)
library(readr)
library(reshape2)
library(scales)
library(RColorBrewer)
library(plyr)
library(grid)
library(gridExtra)


reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

###################################################################

library(wesanderson)
colors <- wes_palette("Zissou1", 14, type = "continuous")


# get R time for 25k points



df <- read.table("~/EBOVPhyloHawkes/output/report.txt", quote="\"", comment.char="")
bench_df <- df[df$V4==25000,]
bench_df$V10 <- bench_df$V10 / bench_df$V6
bench_df <- bench_df[,c(2,3,10)]
bench_df$V2[c(1,2)] <- 1

bench_df$V10[bench_df$V2==0] <- bench_df$V10[bench_df$V2==0] 
colnames(bench_df) <- c("Threads", "SIMD", "Seconds")
bench_df$Seconds <- bench_df$Seconds / 1000

bench_df$SIMD <- c("Non-vectorized","SSE",rep("AVX",11),"GPU") #rep(c("Non-vectorized","SSE",rep("AVX",10),"GPU"),2)
colnames(bench_df)[1] <- "Cores"
df1 <- bench_df

df1$Speedup <- rep(0,dim(df1)[1])
#df1$Seconds <- (df1$Seconds[1:(length(df1$Seconds)/2)] + df1$Seconds[(length(df1$Seconds)/2 + 1):length(df1$Seconds)]) /2
#df1 <- df1[1:(length(df1$Seconds)/2),]
df1$Speedup <- df1$Seconds[3] / df1$Seconds 

df1$Cores <- as.numeric(df1$Cores)
df1$SIMD <- factor(df1$SIMD)
df2 <- df1[df1$Cores==0,]
df2 <- rbind(df2,df2,df2,df2,df2,df2,df2,df2,df2,df2,df2)
df2$Cores <- c(1,2,4,6,8,10,12,14,16,18,20)
df3 <- df1[df1$Cores!=0 & df1$SIMD != "AVX",]
df4 <- df1[df1$Cores!=0 & df1$SIMD == "AVX",]


df4$SIMD <- droplevels.factor(df4$SIMD)
colnames(df4)[2] <- "Method"

gg <- ggplot(df4, aes(x=Cores,y=Speedup)) +
  geom_line(color=colors[9],size=1.1) +
  geom_point(data=df3[1,],mapping = aes(x=Cores,y=Speedup),inherit.aes = FALSE,color=colors[1]) +
  geom_point(data=df3[2,],mapping = aes(x=Cores,y=Speedup),inherit.aes = FALSE,color=colors[5]) +
  geom_text(aes(x=4.3,y=0.5,label="Non-vectorized"),
             inherit.aes = FALSE,show.legend = FALSE,
             check_overlap = TRUE,color=colors[1]) +
  geom_text(aes(x=2.2,y=0.8,label="SSE"),
            inherit.aes = FALSE,show.legend = FALSE,
            check_overlap = TRUE,color=colors[5]) +
  geom_text(aes(x=2.2,y=4,label="AVX"),
            inherit.aes = FALSE,show.legend = FALSE,
            check_overlap = TRUE,color=colors[9]) +
  geom_text(aes(x=2.1,y=100,label="GPU"),
            inherit.aes = FALSE,show.legend = FALSE,
            check_overlap = TRUE,color=colors[12]) +
  geom_line(data=df2,aes(x=Cores,y=Speedup),inherit.aes = FALSE, color=colors[12],
            size=1.1) +
  scale_x_continuous(breaks=c(1,2,4,6,8,10,12,14,16,18,20),
                     labels = c("1","2",'4','6','8','10','12',"14","16","18","20"))+
  scale_y_continuous(trans = "log2",breaks=c(0.5,1,2,4,8,16,32,64,128),
                     labels=c("1/2","1","2","4","8","16","32","64","128")) +
  ylab("Relative speedup at 25k observations") +
  xlab("CPU threads") +
  ggtitle("Hawkes log-likelihood gradient calculations") +
  theme_classic()
gg
# 
# ggsave('performFigure.pdf', gg, device = 'pdf', path = 'figures/',
#        width = 6,height=4)


df <- read.table("~/EBOVPhyloHawkes/output/report.txt", quote="\"", comment.char="")


time_by_N <- df[df$V4!=25000,]
time_by_N <- time_by_N[,-c(1,3,5,7,8,9,11)]
colnames(time_by_N) <- c('Cores',
                         'N',
                         'its',
                         'Gradient')

time_by_N$Gradient <- time_by_N$Gradient / time_by_N$its

time_by_N <- time_by_N[,-3]
#time_by_N <- time_by_N[,-3]
#time_by_N <- time_by_N[,-4]


# time_by_N <- time_by_N[time_by_N$Cores==1 |
#                          time_by_N$Cores==2 |
#                          time_by_N$Cores==4 |
#                          time_by_N$Cores==6 |
#                          time_by_N$Cores==8 |
#                          time_by_N$Cores==10 |
#                          time_by_N$Cores==0,]
time_by_N$Cores <- factor(time_by_N$Cores)

df <- time_by_N
df$Seconds <- time_by_N$Gradient /1000
df <- df[,-3]

df$Cores <- revalue(df$Cores, c("0"="GPU"))
df$Threads <- factor(df$Cores)
df$Threads = factor(df$Cores,levels(df$Cores)[c(2:14,1)])


gg2 <- ggplot(df,aes(x=N,y=Seconds,color=Threads)) +
  geom_smooth(se=FALSE) +
  scale_color_manual(values = colors)+
  ylab('Seconds per gradient evaluation') +
  xlab('Number of observations')+
  coord_cartesian(ylim=c(0,60),xlim=c(10000,85000)) +
  #scale_x_continuous(labels=c("0","3.1e+06","1.3e+07","2.8e+07","5e+07"))+
  theme_classic()  
gg2

df <- read.table("~/EBOVPhyloHawkes/output/report.txt", quote="\"", comment.char="")


time_by_N <- df[df$V4!=25000,]
time_by_N <- time_by_N[,-c(1,3,5,7,8,9,10)]
colnames(time_by_N) <- c('Cores',
                         'N',
                         'its',
                         'Gradient')

time_by_N$Gradient <- time_by_N$Gradient / time_by_N$its

time_by_N <- time_by_N[,-3]
#time_by_N <- time_by_N[,-3]
#time_by_N <- time_by_N[,-4]


# time_by_N <- time_by_N[time_by_N$Cores==1 |
#                          time_by_N$Cores==2 |
#                          time_by_N$Cores==4 |
#                          time_by_N$Cores==6 |
#                          time_by_N$Cores==8 |
#                          time_by_N$Cores==10 |
#                          time_by_N$Cores==0,]
time_by_N$Cores <- factor(time_by_N$Cores)

df <- time_by_N
df$Seconds <- time_by_N$Gradient /1000
df <- df[,-3]

df$Cores <- revalue(df$Cores, c("0"="GPU"))
df$Threads <- factor(df$Cores)
df$Threads = factor(df$Cores,levels(df$Cores)[c(2:14,1)])


gg4 <- ggplot(df,aes(x=N,y=Seconds,color=Threads)) +
  geom_smooth(se=FALSE) +
  scale_color_manual(values = colors)+
  ylab('Seconds per Hessian evaluation') +
  xlab('Number of observations')+
  coord_cartesian(ylim=c(0,60),xlim=c(10000,85000)) +
  #scale_x_continuous(labels=c("0","3.1e+06","1.3e+07","2.8e+07","5e+07"))+
  theme_classic()  
gg4

ggsave('performFigure.pdf',grid.arrange(gg,gg2,gg3,gg4,ncol=2) , device = 'pdf', path = 'figures/',
       width = 9,height=4)

