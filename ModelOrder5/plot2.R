# use 'yvalues.RData' to plot for enlarged area

load('yValuesForPlot.RData')
t <- 1:length(yhat)
trange <- 1:100
pdf("plotting2.pdf")
plot(t[trange], yreal[trange], main = 'Plot of the true returns and the predicted returns', ylab = 'Returns', xlab = 'Time', ylim=c(-0.002, 0.002))
points(t[trange], yhat[trange], type='l', col='red')

