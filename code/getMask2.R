setwd("~/EBOVPhyloHawkes/")

#cat(c(rep(1,1366),rep(0,21811)),sep=" ",file="data/mask2.txt")
cat(c(rep(1,365),rep(0,4009)),sep=" ",file="data/mask2.txt")
# 365 sequenced with locations/times