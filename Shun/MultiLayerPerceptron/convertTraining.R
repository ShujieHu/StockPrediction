# This program is trying to convert the 
# .RData file into numpy arrays, which can be used 
# on TensorFlow neural networks.

load('training_returns.RData')
n <- dim(training)[2]
T <- dim(training)[1]

# Create a matrix of (T-1) dimension and 2 * n
# Since the following n columns are used to generate labels.
res <- matrix(0, T - 1, 2*n)
for (i in 1 : T - 1) {
    for (j in 1 : n) {
        res[i, j] = training[i, j]
    }

    for (j in (n + 1) : (2*n)) {
        if (training[i + 1, j - n] >= 0) {
            res[i, j] = 1;
        } else {
            res[i, j] = 0;
        }
    }
}

write.table(res, file = "Training", append = FALSE, quote = F, sep = " ", eol = "\n", row.names = F, col.names = F)

