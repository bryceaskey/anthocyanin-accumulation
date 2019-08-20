# Given an image of a leaf, create false color heatmap image based on predicted NAI
# Inputs: leaf image, and trained regression

makeHeatmap <- function(heatmapPath, transformParams, modelAccuracies, allModels){
  
  # use most accurate model
  modelName <- modelAccuracies$modelName[1]
  colorSpace <- modelAccuracies$modelColorSpace[1]
  regressionModel <- allModels[[colorSpace]][[modelName]]
  
  # get list of image names in folder
  imageNames <- list.files(heatmapPath)
  
  # initialize vector to store average NAI values for each image
  averageNAI <- vector()
  
  # loop over all images in folder specified by imagePath
  for(i in 1:length(imageNames)){
    print(paste("Now making heatmap of image", imageNames[i]))
    leafImage <- readImage(paste(heatmapPath, "/", imageNames[i], sep=""))
    
    # initialize empty matrix to store color information for heatmap image
    heatmap <- array(0, dim=c(nrow(leafImage), ncol(leafImage), 4))
    
    # convert image into appropriate color space to match regression model, and center and scale pixel values
    if(colorSpace != "sRGB"){
      conLeafImage <- array(0, dim=c(nrow(leafImage), ncol(leafImage), 4))
      for(row in 1:nrow(leafImage)){
        for(col in 1:ncol(leafImage)){
          if(leafImage[row, col, 4] == 1){
            conLeafImage[row, col, 4] <- 1
            sRGBpixel <- data.frame(R=leafImage[row, col, 1], G=leafImage[row, col, 2], B=leafImage[row, col, 3])
            # color space conversion
            convertedPixel <- convertColorSpace(sRGBpixel, colorSpace)
            # centering and scaling
            convertedPixel <- predict(transformParams[[colorSpace]], convertedPixel)
            # insert converted pixel into image
            conLeafImage[row, col, 1:3] <- convertedPixel[1:3]
          }
        }
      }
    }
    # if model is in sRGB color space, no color space conversion necessary, but centering and scaling still needed
    else{
      conLeafImage <- array(0, dim=c(nrow(leafImage), ncol(leafImage), 4))
      for(row in 1:nrow(leafImage)){
        for(col in 1:ncol(leafImage)){
          if(leafImage[row, col, 4] == 1){
            conLeafImage[row, col, 4] <- 1
            sRGBpixel <- data.frame(R=leafImage[row, col, 1], G=leafImage[row, col, 2], B=leafImage[row, col, 3])
            # centering and scaling
            convertedPixel <- predict(transformParams[[colorSpace]], sRGBpixel)
            # insert converted pixel into image
            conLeafImage[row, col, 1] <- convertedPixel[[1]]
            conLeafImage[row, col, 2] <- convertedPixel[[2]]
            conLeafImage[row, col, 3] <- convertedPixel[[3]]
          }
        }
      }
    }
    
    allNAI <- vector()
    
    # make prediction of NAI with model based on color data, and assign appropriate color to heatmap matrix
    for(row in 1:nrow(conLeafImage)){
      for(col in 1:ncol(conLeafImage)){
        if(conLeafImage[row, col, 4] == 1){
          heatmap[row, col, 4] <- 1
          leafPixel <- conLeafImage[row, col, 1:3]
          if(colorSpace=="sRGB"){
            predNAI <- predict(regressionModel, cbind.data.frame(R=leafPixel[1], G=leafPixel[2], B=leafPixel[3]))
          }else if(colorSpace=="HSV"){
            predNAI <- predict(regressionModel, cbind.data.frame(H=leafPixel[1], S=leafPixel[2], V=leafPixel[3]))
          }else if(colorSpace=="YIQ"){
            predNAI <- predict(regressionModel, cbind.data.frame(Y=leafPixel[1], I=leafPixel[2], Q=leafPixel[3]))
          }else if(colorSpace=="YCbCr"){
            predNAI <- predict(regressionModel, cbind.data.frame(Y=leafPixel[1], Cb=leafPixel[2], Cr=leafPixel[3]))
          }else{
            predNAI <- predict(regressionMode, cbind.data.frame(L=leafPixel[1], a=leafPixel[2], b=leafPixel[3]))
          }
          
          # create vector of NAI values for each leaf pixel
          allNAI <- append(allNAI, predNAI)
          
          # assign false color to heatmap image pixel based on predicted NAI
          if(predNAI < 20){
            heatmap[row, col, 1:3] <- c(231, 213, 217)/255
          }else if(predNAI < 40){
            heatmap[row, col, 1:3] <- c(223, 170, 186)/255
          }else if(predNAI < 60){
            heatmap[row, col, 1:3] <- c(215, 127, 155)/255
          }else if(predNAI < 80){
            heatmap[row, col, 1:3] <- c(207, 85, 124)/255
          }else if(predNAI < 100){
            heatmap[row, col, 1:3] <- c(199, 42, 93)/255
          }else{
            heatmap[row, col, 1:3] <- c(191, 0, 63)/255
          }
        }
      }
    }
    writeImage(heatmap, paste(heatmapPath,  "/", strsplit(imageNames[i], split=".", fixed=TRUE)[[1]][[1]], "Heatmap.png", sep=""))
    averageNAI <- append(averageNAI, mean(allNAI))
  }
  return(data.frame(averageNAI=averageNAI, row.names=imageNames)) # need to return average predicted NAI for all images analyzed
}