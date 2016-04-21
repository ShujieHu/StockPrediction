# Specify a pair of stocks and perform case study
# 14 => 74

# Load the training data
load('training_returns.RData')
stocks <- training

i <- 74 
j <- 14
p <- 1 
response <- embed(cbind(stocks[, i], stocks[, j]), p + 1)
prev <- response[, -(1:2)]
model <- lm(response[,1] ~ prev)

load('testing_returns.RData')
T <- dim(testing)[1]
n <- dim(testing)[2]

# Strategy: i_t - i_t-1 = alpha + (beta - 1) * i_t-1 + gamma * j_t-1
profit <- 0.0
for (t in 1:(T - 1)) {
    x <- data.frame(cbind(stocks[t, i], stocks[t, j]))    
    if (predict(model, x) > 0) {
        cat(sprintf("buy at testing data set time point: %d\n", t))
        profit <- profit + testing[t + 1, i]
        cat(sprintf("current profit: %f\n", profit))
    }
    #if ( < 0) {
    #    cat(sprintf("short at testing data set time point: %d\n", t))
    #    profit <- profit - testing[t + 1, i] + testing[t, i]
    #}
}
