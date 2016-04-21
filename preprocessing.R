#read the data into R
#cleaned data with prices only
mydata <- read.csv('5_min_data_group_1_cleaned.csv', header= T)
stocks <- mydata[, -1] 
stocks <- stocks[-9291, ]

#normalization of the prices
len <- dim(stocks)[1]
T <- dim(stocks)[2]
for (i in 1 : T) {
    temp = stocks[1,i]
    for (j in 1 : len) {
        stocks[j,i] <- stocks[j,i]/temp
    }
}
save(stocks, file = 'stocks.RData')

# Split Trainging dataset and testing dataset and
# Store them separately.
cvratio <- 0.8

n <- cvratio * len
training <- stocks[seq(1:n),]
testing <- stocks[seq(n + 1, len),]

save(training, file = 'training.RData')
save(testing, file = 'testing.RData')
