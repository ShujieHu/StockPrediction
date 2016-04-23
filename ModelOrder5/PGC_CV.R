cross_validation <- function(X, Y, K, R) {
    library(cvTools)
    folds <- cvFolds(nrow(X), K = K, R = R)
    res <- array(0, K * R)
    for (i in 1:R) {
        for (j in 1:K) {
            test <- folds$subsets[,i][which(folds$which == j)] 
            train <- folds$subsets[,i][which(folds$which != j)] 

            Xtrain <- X[train,] 
            Ytrain <- Y[train]
            Xtest <- X[test,]
            Ytest <- Y[test]

            model <- lm(Ytrain ~ Xtrain)
            #Ypredict <- predict(model, data.frame(Xtest))
            coef <- model$coefficients[-1]
            incept <- model$coefficients[1]
            Ypredict <- Xtest %*% coef + incept
            res[(i - 1) * R + j] <- sum((Ypredict - Ytest)^2) / length(Ypredict) 
        }   
    }   
    return(res) 
}
