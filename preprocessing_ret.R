#read the data into R
#cleaned data with prices only
mydata <- read.csv('5_min_data_group_1_cleaned.csv', header= T)
stocks <- mydata[, -1] 
stocks <- stocks[-9291, ]
returns <- stocks

#calculate the returns 
len <- dim(returns)[1]
T <- dim(returns)[2]
for (i in len : 2) {
    temp = returns[i - 1,]
    returns[i,] <- returns[i,]/temp - 1
}
returns <- returns[-1,]
save(returns, file = 'returns.RData')

# Split Trainging dataset and testing dataset and
# Store them separately.
cvratio <- 0.8

n <- cvratio * len
training <- returns[seq(1:n),]
testing <- returns[seq(n + 1, len - 1),]

save(training, file = 'training_returns.RData')
save(testing, file = 'testing_returns.RData')
