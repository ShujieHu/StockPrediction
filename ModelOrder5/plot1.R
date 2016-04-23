# use 'yvalues.RData' to plot

load('yValuesForPlot.RData')
t <- 1:length(yhat)
trange <- 1:100
pdf("PRC_yvst.pdf")
plot(t[trange], yreal[trange], main = 'Plot of the true returns and the predicted returns', ylab = 'Returns', xlab = 'Time')
points(t[trange], yhat[trange], type='l', col='red')
#dev.off

