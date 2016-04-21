# load the data
load('stocks.RData')

# Pairwise Granger Causality model
len <- dim(stocks)[1]
n <- 0.8 * len
T <- dim(stocks)[2]
p <- 1

sink('results', append = F)
testdata <- stocks[seq(n + 1, len),]
stocks <- stocks[seq(1:n),]
# Train dataset
for (i in 1:T) {
    for (j in 1:T) {
        if (i == j) {
            next
        }
        response <- embed(cbind(stocks[, i], stocks[, j]), p + 1)
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

