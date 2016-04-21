# Specify a pair of stocks and perform case study

# Load the training data
load('training.RData')
stocks <- training

i <- 86
j <- 61
p <- 4
response <- embed(cbind(stocks[, i], stocks[, j]), p + 1)
prev <- response[, -(1:2)]
self <- prev[, ((1:p) * 2) - 1]

res_self <- lm(response[,1] ~ self)
res_paired <- lm(response[,1] ~ prev)

# res_paired is the good model to use.
# i_t = alpha + beta * i_t-1 + gamma * j_t-1

alpha <- res_paired$coefficients[1]
beta <- res_paired$coefficients[2]
gamma <- res_paired$coefficients[3]

load('testing.RData')
T <- dim(testing)[1]
n <- dim(testing)[2]

# Strategy: i_t - i_t-1 = alpha + (beta - 1) * i_t-1 + gamma * j_t-1
beta <- beta - 1
profit <- 0
for (t in 1:(T - 1)) {
    if (alpha + (beta - 1) * testing[t, i] + gamma * testing[t, j] > 0.3) {
        cat(sprintf("buy at testing data set time point: %d\n", t))
        profit <- profit + testing[t + 1, i] - testing[t, i]
    }
    if (alpha + (beta- 1) * testing[t, i] + gamma * testing[t, j] < -0.3) {
        cat(sprintf("short at testing data set time point: %d\n", t))
        profit <- profit - testing[t + 1, i] + testing[t, i]
    }
}
