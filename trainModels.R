# Function to randomly sort color and absorbance data into training and test sets, train a group of regression models, and evaluate their accuracy.

trainModels <- function(colorSpaceData, transformParams){
  
  # ensure data in different color spaces are partitioned into identical training and test sets
  set.seed(50)
  
  # randomly sort data into training and test sets
  inTrain <- createDataPartition(colorSpaceData[ , 4], p=4/5, list=FALSE)
  trainData <- colorSpaceData[inTrain, ]
  testData <- colorSpaceData[-inTrain, ]
  
  # center and scale data
  trainData <- cbind(predict(transformParams, trainData[ , 1:3]), NAI=trainData[ , 4])
  testData <- cbind(predict(transformParams, testData[ , 1:3]), NAI=testData[ , 4])
  
  # set resampleing method for models with 0 tuning parameters
  crossValidation <- trainControl(method="repeatedcv", number=5, repeats=100)
  
  # train models with 0 tuning parameters
  print("gprLinear")
  gprLinear <- train(trainData[ , 1:3], trainData[ , 4], method="gaussprLinear", tuneLength=50, trControl=crossValidation, metric="RMSE", scaled=FALSE)
  print("bayesianRidgeRegression")
  bayesianRidgeRegression <- train(trainData[ , 1:3], trainData[ , 4], method="bridge", tuneLength=50, trControl=crossValidation, metric="RMSE")
  
  # gather models with no tuning parameters into list
  noTuningParams <- list(gprLinear=gprLinear, bayesianRidgeRegression=bayesianRidgeRegression)
  
  # set resampling method for models with 1 tuning parameter - grid search
  gridSearch <- trainControl(method="repeatedcv", number=5, repeats=100, search="grid")
  
  # train models with 1 tuning parameter
  print("gprRadial")
  gprRadial <- train(trainData[ , 1:3], trainData[ , 4], method="gaussprRadial", tuneLength=50, trControl=gridSearch, metric="RMSE", scaled=FALSE)
  print("svmLinear")
  svmLinear <- train(trainData[ , 1:3], trainData[ , 4], method="svmLinear", tuneLength=50, trControl=gridSearch, metric="RMSE", scaled=FALSE)
  print("svmRadialCost")
  svmRadialCost <- train(trainData[ , 1:3], trainData[ , 4], method="svmRadialCost", tuneLength=5, trControl=gridSearch, metric="RMSE", scaled=FALSE)
  print("independentComponent")
  independentComponent <- train(trainData[ , 1:3], trainData[ , 4], method="icr", tuneLength=3, trControl=gridSearch, metric="RMSE")
  print("leastAngle")
  leastAngle <- train(trainData[ , 1:3], trainData[ , 4], method="lars", tuneLength=50, trControl=gridSearch, metric="RMSE")
  print("linear")
  linear <- train(trainData[ , 1:3], trainData[ , 4], method="lm", tuneLength=50, trControl=gridSearch, metric="RMSE")
  print("bayesianNeuralNetwork")
  bayesianNeuralNetwork <- train(trainData[ , 1:3], trainData[ , 4], method="brnn", tuneLength=10, trControl=gridSearch, metric="RMSE")
  print("partialLeastSquares")
  partialLeastSquares <- train(trainData[ , 1:3], trainData[ , 4], method="pls", tuneLength=50, trControl=gridSearch, metric="RMSE")
  print("principalComponentAnalysis")
  principalComponentAnalysis <- train(trainData[ , 1:3], trainData[ , 4], method="pcr", tuneLength=50, trControl=gridSearch, metric="RMSE")
  print("randomForest")
  randomForest <- train(trainData[ , 1:3], trainData[ , 4], method="rf", tuneLength=50, trControl=gridSearch, metric="RMSE")
  print("quantileRandomForest")
  quantileRandomForest <- train(trainData[ , 1:3], trainData[ , 4], method="qrf", tuneLength=50, trControl=gridSearch, metric="RMSE")
  
  # gather models with one tuning parameter into list
  oneTuningParam <- list(gprRadial=gprRadial, svmLinear=svmLinear, svmRadialCost=svmRadialCost, independentComponent=independentComponent, leastAngle=leastAngle, linear=linear, bayesisanNeuralNetwork=bayesianNeuralNetwork, partialLeastSquares=partialLeastSquares, principalComponentAnalysis=principalComponentAnalysis, randomForest=randomForest, quantileRandomForest=quantileRandomForest)
  
  # set resampling method for models with > 1 tuning parameter - use adaptive cross-validation with 5 folds and 50 repeats
  adaptiveResample <- trainControl(method="adaptive_cv", number=5, repeats=50, adaptive=list(min=30, alpha=0.05, method="gls", complete=FALSE), search="random")
  
  # train models with > 1 tuning parameter
  print("gprPolynomial")
  gprPolynomial <- train(trainData[ , 1:3], trainData[ , 4], method="gaussprPoly", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("svmPolynomial")
  svmPolynomial <- train(trainData[ , 1:3], trainData[ , 4], method="svmPoly", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("svmRadial")
  svmRadial <- train(trainData[ , 1:3], trainData[ , 4], method="svmRadial", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("svmRadialSigma")
  svmRadialSigma <- train(trainData[ , 1:3], trainData[ , 4], method="svmRadialSigma", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("cubist")
  cubist <- train(trainData[ , 1:3], trainData[ , 4], method="cubist", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("linearPenalized")
  linearPenalized <- train(trainData[ , 1:3], trainData[ , 4], method="penalized", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("stochasticGradientBoosting")
  stochasticGradientBoosting <- train(trainData[ , 1:3], trainData[ , 4], method="gbm", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("partialLeastSquaresGenLinear")
  partialLeastSquaresGenLinear <- train(trainData[ , 1:3], trainData[ , 4], method="plsRglm", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  print("sparsePartialLeastSquares")
  sparsePartialLeastSquares <- train(trainData[ , 1:3], trainData[ , 4], method="spls", tuneLength=50, trControl=adaptiveResample, metric="RMSE")
  
  # gather models with multiple tuning parameters into list
  multipleTuningParams <- list(gprPolynomial=gprPolynomial, svmPolynomial=svmPolynomial, svmRadial=svmRadial, svmRadialSigma=svmRadialSigma, cubist=cubist, linearPenalized=linearPenalized, stochasticGradientBoosting=stochasticGradientBoosting, partialLeastSquaresGenLinear=partialLeastSquaresGenLinear, sparsePartialLeastSquares=sparsePartialLeastSquares)
  
  # combine all models into single list, and return as output of function
  models <- c(list(trainData=trainData, testData=testData), noTuningParams, oneTuningParam, multipleTuningParams)
  
  return(models)
}