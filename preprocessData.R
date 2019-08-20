# Function to get parameters for data scaling and centering.
# Parameters needed for data transformation during training and testing of models, and during heatmap creation.
# Function inputs:
#   imageData - output of meanColorIndexValues.R. A list of data frame which contain mean color index values for each image in the imagePath directory in 5 color spaces.

preprocessData <- function(imageData){
  transformParams <- list(NA, 5)
  for(i in 1:length(imageData)){
    colorSpaceData <- imageData[[i]]
    params <- preProcess(colorSpaceData[ , 1:3])
    transformParams[[i]] <- params
  }
  names(transformParams) <- names(imageData)
  return(transformParams)
}