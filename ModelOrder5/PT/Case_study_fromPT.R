# Specify a pair of stocks and perform case study
# 22 => 74

# Load the training data
load('training_returns.RData')
stocks <- training

i <- 99 
j <- 27
p <- 5 
response <- embed(cbind(stocks[, i], stocks[, j]), p + 1)
prev <- response[, -(1:2)]
model <- lm(response[,1] ~ prev)

load('testing_returns.RData')
T <- dim(testing)[1]
n <- dim(testing)[2]

#initialize an array of predicted values for future plotting
yhat <- rep(0, T - p)
yreal <- testing[-(1:p),i]

# Strategy: i_t - i_t-1 = alpha + (beta - 1) * i_t-1 + gamma * j_t-1
#temp <- embed(cbind(testing[,i], testing[,j]), p + 1)
#prevtemp <- temp[,-(1:2)]
#yhat <- predict(model, data.frame(prev=prevtemp))

#profit <- 0.0
profit <- 1.0
plainprofit <- 1.0
for (t in 1:(T - p)) {
    #x <- data.frame(prev=rbind(testing[(t + p - 1) :t, i], testing[(t + p - 1):t, j]))    
   prev=rbind(testing[(t + p - 1) :t, i], testing[(t + p - 1):t, j])
   prev <- as.vector(prev)
   x <- c(1, prev)

   yhat[t] <- sum(model$coefficients * x)
   plainprofit <- plainprofit * (1 +yreal[t])
    if (yhat[t] > 0) {
        #cat(sprintf("buy at testing data set time point: %d\n", t))
       # profit <- profit + yreal[t] 
        profit <- profit * (1 +yreal[t])
        #cat(sprintf("current profit: %f\n", profit))
    }
    #if ( < 0) {
    #    cat(sprintf("short at testing data set time point: %d\n", t))
    #    profit <- profit - testing[t + 1, i] + testing[t, i]
    #}
}
print(profit)
print(plainprofit)
save(yhat, yreal, file='yValues_fromPT.RData')
