setwd("~/EBOVPhyloHawkes/")

library(ggplot2)

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
df <- df[,13:d2]

means <- apply( df , 2 , mean)
lower <- apply( df , 2 , quantile , probs = 0.025)
upper <- apply( df , 2 , quantile , probs = 0.975)
signf <- 1>upper | 1 <lower
df2 <- data.frame(means,lower,upper,Significant=signf)
df2 <- df2[order(df2$lower,decreasing = TRUE),]
df2$Virus <- factor(1:dim(df2)[1])

library(wesanderson)
pal <- wes_palette("Zissou1", 100, type = "continuous")

gg <- ggplot(df2,aes(x=Virus,y=means,color=Significant)) +
  geom_linerange(aes(ymin=lower,ymax=upper),alpha=0.7) + 
  scale_color_manual(values = c(pal[1],pal[100])) +
  geom_point(color="black") +
  ylab("Relative rate") + xlab("Viral observation") +
  ggtitle("95% Credible intervals and posterior means for 1,367 virus-specific rates") +
  theme_classic() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
gg

ggsave(file="figures/ratesCIs.pdf",width = 10,height=3,device = "pdf")

system2(command = "pdfcrop", 
        args    = c("~/EBOVPhyloHawkes/figures/ratesCIs.pdf", 
                    "~/EBOVPhyloHawkes/figures/ratesCIs.pdf") 
)
