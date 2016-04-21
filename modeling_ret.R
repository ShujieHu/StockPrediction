# load the data
load('training_returns.RData')
load('testing_returns.RData')

# Pairwise Granger Causality model
len <- dim(training)[1]
T <- dim(training)[2]
p <- 4

sink('results_p4_returns', append = F)
# Train dataset
for (i in 1:T) {
    for (j in 1:T) {
        if (i == j) {
            next
        }
        response <- embed(cbind(training[, i], training[, j]), p + 1)
        prev <- response[, -(1:2)]
        self <- prev[, ((1:p) * 2) - 1]

        res_self <- lm(response[,1] ~ self)
        res_paired <- lm(response[,1] ~ prev)
        ssqR <- sum(res_self$resid^2)
        ssqU <- sum(res_paired$resid^2)
        fscore <- ((ssqR - ssqU)/(p + 1))/(ssqU/(nrow(response) - 2 * p - 1))

        cat(sprintf("%d\t%d\t%f\t%f\n", i, j, fscore, ssqU))
    }
}
sink()

