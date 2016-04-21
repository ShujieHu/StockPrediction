load('training_returns.RData')

library(quantmod)
GETSYMBOl1<- function(symbol,src,fromdate,todate) {getSymbols(symbol,src=src,from=fromdate,to=todate,auto.assign=FALSE)}

sink('CorrelationMatrix', append = F)
covmatrix <- cor(training)
highval <- max(covmatrix[covmatrix != max(covmatrix)])
a <- NULL;
b <- NULL;
for (i in 1 : 99) {
	 for (j in 1 : 99) {
	 	if (covmatrix[i, j] == highval) { a <- i; b <- j}

        cat(sprintf("%d\t%d\t%f\n", i, j, covmatrix[i,j]))
	 }
}
#already find the correlated stocks do pairs trading
#model <- lm(stock1 ~ stock2 - 1)
#library(egcm)
# plot(egcm(mydata$GS, mydata$MS))

