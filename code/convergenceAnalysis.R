setwd("~/EBOVPhyloHawkes/")

library(readr)
library(coda)
library(ggplot2)
library(cowplot)

library(wesanderson)
pal <- wes_palette("Zissou1", 3, type = "continuous")

df <- read_table2("output/final.log", 
                  skip = 3)
df <- df[,c(-1,-7)]
df2 <- read_table2("output/final2.log", 
                  skip = 3)
df2 <- df2[,c(-1,-7)]
df3 <- read_table2("output/final3a.log", 
                   skip = 3)
df3 <- df3[,c(-1,-7)]
df4 <- read_table2("output/final3.log", 
                   skip = 3)
df4 <- df4[df4$state <= 100500000, ]
df4 <- df4[,c(-1,-7)]

df <- rbind(df,df2,df3,df4)

mc <- as.mcmc(df)
esss <- effectiveSize(mc)

summary(esss)
hist(esss)
df2 <- data.frame(ESS=esss)

gg <- ggplot(df2,aes(x=ESS)) +
  geom_histogram(fill=pal[1],alpha=0.6) +
  ylab("Count (1377 parameters total)") +
  xlab("Effective sample size (ESS)") +
  ggtitle("Diagnostic histogram and quartiles") +
  geom_segment(aes(x = summary(esss)[1], y = -5, xend =summary(esss)[1], yend = 5)) +
  geom_segment(aes(x = summary(esss)[2], y = -5, xend =summary(esss)[2], yend = 5)) +
  geom_segment(aes(x = summary(esss)[3], y = -5, xend =summary(esss)[3], yend = 5)) +
  geom_segment(aes(x = summary(esss)[5], y = -5, xend =summary(esss)[5], yend = 5)) +
  geom_segment(aes(x = summary(esss)[6], y = -5, xend =summary(esss)[6], yend = 5)) +
  annotate(geom="text",label=paste0(round(summary(esss)[1],digits=1)),x=summary(esss)[1],y=-8,size=2) +
  annotate(geom="text",label=paste0(round(summary(esss)[2],digits=1),".0"),x=summary(esss)[2],y=-8,size=2) +
  annotate(geom="text",label=paste0(round(summary(esss)[3],digits=1)),x=summary(esss)[3],y=-8,size=2) +
  annotate(geom="text",label=paste0(round(summary(esss)[5],digits=1)),x=summary(esss)[5],y=-8,size=2) +
  annotate(geom="text",label=paste0(round(summary(esss)[6],digits=1)),x=summary(esss)[6],y=-8,size=2) +
  theme_bw()
gg <- as_grob(gg)

ggsave("figures/diagnostics.pdf",gg,width = 6,height=4,device = "pdf")

df2 <- data.frame(x=df[,183])
colnames(df2) <- "x"
gg2 <- ggplot(df2,aes(x=x)) +
  geom_density(color=pal[2],fill=pal[2],alpha=0.6) +
  xlim(c(-4,10)) +
  ggtitle("An example of multiscale multimodality") +
  ylab("Density") +
  xlab("Relative rate #173") +
  theme_bw()
gg2 <- as_grob(gg2)
ggsave("figures/diagnostics2.pdf",gg2,width = 6,height=4,device = "pdf")


library(png)
library(grid)
library(gridExtra)
img <- readPNG("figures/correlations.png")
g <- rasterGrob(img, interpolate=TRUE)

gg3 <- ggplot() +
  ggtitle("Complex correlation structures") +
  xlab("Example relative rates          ") + ylab("Example relative rates") +
  theme_minimal() +
  ylim(c(0,10)) + xlim(c(0,10)) +
  annotation_custom(g, xmin=-1.1, xmax=10, ymin=-0.2, ymax=10.6) +
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank())
#gg3

ggsave("figures/diagnostics.pdf",grid.arrange(gg,gg2,gg3,nrow=1,ncol=3),
       width = 12,height=4,device = "pdf")

system2(command = "pdfcrop", 
        args    = c("~/EBOVPhyloHawkes/figures/diagnostics.pdf", 
                    "~/EBOVPhyloHawkes/figures/diagnostics.pdf") 
)

