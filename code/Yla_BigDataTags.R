setwd("/Users/Yla/Documents/workspace2/BigData/Data")


## Calculate for DS
ds = read.csv("BigDataTags_dsv2.csv")
dst = read.csv("PostTotals_dsv2.csv")

ds$ChiSqP = rep(NA,nrow(ds))
freq = c(dst[1,"TotalBigData"]/dst[1,"TotalPosts"],dst[1,"TotalNotBigData"]/dst[1,"TotalPosts"])
for(i in 1:nrow(ds)){
	x2 = chisq.test(ds[i,c("NumBigData","NumNotBigData")],p=freq)
	ds[i,"ChiSqP"] = x2$p.value
}
ds = ds[order(ds$ChiSqP),]
ds$IsBigData = ifelse(ds$ChiSqP<0.05,1,0)
ds$IsBigDataCut = ifelse(ds$ChiSqP<0.05&ds$TotalPosts>=5&ds$NumBigData>1,1,0)
write.csv(ds,"BigDataFinal_ds.csv",row.names=F,na="")

## Calculate for CV
cv = read.csv("BigDataTags_cvv2.csv")
cvt = read.csv("PostTotals_cvv2.csv")

cv$ChiSqP = rep(NA,nrow(cv))
freq = c(cvt[1,"TotalBigData"]/cvt[1,"TotalPosts"],cvt[1,"TotalNotBigData"]/cvt[1,"TotalPosts"])
for(i in 1:nrow(cv)){
	x2 = chisq.test(cv[i,c("NumBigData","NumNotBigData")],p=freq)
	cv[i,"ChiSqP"] = x2$p.value
}
cv = cv[order(cv$ChiSqP),]
cv$IsBigData = ifelse(cv$ChiSqP<0.05,1,0)
cv$IsBigDataCut = ifelse(cv$ChiSqP<0.05&cv$TotalPosts>=5&cv$NumBigData>1,1,0)
write.csv(cv,"BigDataFinal_cv.csv",row.names=F,na="")

## Calculate for SO
#so = read.csv("BigDataTags_sov2.csv")
#so$NumNotBigData = so$TotalPosts - so$NumBigData
#write.csv(so,"BigDataTags_sov3.csv",row.names=F,na="")
so = read.csv("BigDataTags_sov3.csv")
sot = read.csv("PostTotals_sov2.csv")

so$ChiSqP = rep(NA,nrow(so))
freq = c(sot[1,"TotalBigData"]/sot[1,"TotalPosts"],sot[1,"TotalNotBigData"]/sot[1,"TotalPosts"])
for(i in 1:nrow(so)){
	x2 = chisq.test(so[i,c("NumBigData","NumNotBigData")],p=freq)
	so[i,"ChiSqP"] = x2$p.value
}
so = so[order(so$ChiSqP),]
so$IsBigData = ifelse(so$ChiSqP<0.05,1,0)
so$IsBigDataCut = ifelse(so$ChiSqP<0.05&so$TotalPosts>=5&so$NumBigData>1,1,0)
write.csv(so,"BigDataFinal_so.csv",row.names=F,na="")






