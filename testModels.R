# Function to evaluate accuracy of all trained models using test set data.
# Outputs data frame with model name, the color space it was trained in, RMSE, r^2, and MAE.
# Models in data frame are ordered from smallest to largest RMSE.

testModels <- function(allModels){
  
  # initialize vectors to model accuracy data
  numModels <- length(allModels[[i]]) - 2
  modelName <- rep(NA, numModels)
  modelColorSpace <- rep(NA, numModels)
  modelRMSE <- rep(NA, numModels)
  modelRsquared <- rep(NA, numModels)
  modelMAE <- rep(NA, numModels)
  
  modelCount <- 0
  
  # loop through each color space
  for(i in 1:length(allModels)){
    colorSpaceData <- allModels[[i]]
    trainedModels <- colorSpaceData[3:(numModels + 2)]
    testData <- colorSpaceData[[2]]
    for(j in 1:length(trainedModels)){
      modelCount <- modelCount + 1
      
      # predict NAI for each data point in test set, and compare to actual NAI to calculate RMSE, R^2, and MAE
      model <- trainedModels[[j]]
      predictedNAI <- as.vector(predict.train(model, testData[ , 1:3]))
      actualNAI <- as.vector(testData[ , 4])
      modelAccuracy <- postResample(predictedNAI, actualNAI)
      
      # create matrix of values to create data frame with accuracy info for all trained models across all color spaces
      modelName[modelCount] <- names(trainedModels)[j]
      modelName[modelCount] <- names(trainedModels)[j]
      modelColorSpace[modelCount] <- names(allModels)[i]
      modelRMSE[modelCount] <- modelAccuracy[1]
      modelRsquared[modelCount] <- modelAccuracy[2]
      modelMAE[modelCount] <- modelAccuracy[3]
    }
  }
  
  # create data frame with accuracy values for each model
  allModelAccuracies <- data.frame(modelName, modelColorSpace, modelRMSE, modelRsquared, modelMAE, stringsAsFactors=FALSE)
  colnames(allModelAccuracies) <- c("modelName", "modelColorSpace", "RMSE", "Rsquared", "MAE")
  
  # sort models by RMSE
  allModelAccuracies <- allModelAccuracies[order(allModelAccuracies$RMSE), ]
  
  return(allModelAccuracies)
}