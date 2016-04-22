library(cvTools)

# load the data
load('training_returns.RData')

# Pairwise Granger Causality model
len <- dim(training)[1]
T <- dim(training)[2]
#p--time lag
p <- 5

source('PGC_CV.R')

sink('Results_PGC_CV', append = F)
# Train dataset
# Check causality direction from j to i.
for (i in 1:T) {
    for (j in 1:T) {
        if (i == j) {
            next
        }

        # Perform cross validation on j => i relationship on the best regression.
        response <- embed(cbind(training[, i], training[, j]), p + 1)
        prev <- response[, -(1:2)]
        cvMSE <- cross_validation(prev, response[,1], 5, 5)
        cat(sprintf("%d\t%d\t%.10f\t%.10f\n", j, i, mean(cvMSE), sd(cvMSE)))
    }
}
sink()

