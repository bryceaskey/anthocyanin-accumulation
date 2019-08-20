# Given a set of images, calculate the mean color index values for each image in 5 color spaces: sRGB, HSV, YIQ, YCbCr, and L*a*b*.
# Save color data for each color space into a data frame in the environment.
# Function inputs:
#   imagePath - directory where all code files are saved

meanColorIndexValues <- function(imagePath){
  # get list of image names in folder specified by imagePath
  imageNames <- list.files(paste(imagePath))
  
  # initalize matrices to store mean color index values in each color space
  sRGBmeans <- matrix(NA, nrow=length(imageNames), ncol=3)
  HSVmeans <- matrix(NA, nrow=length(imageNames), ncol=3)
  YIQmeans <- matrix(NA, nrow=length(imageNames), ncol=3)
  YCbCrmeans <- matrix(NA, nrow=length(imageNames), ncol=3)
  Labmeans <- matrix(NA, nrow=length(imageNames), ncol=3)
  
  # loop over all images in folder specified by imagePath
  for(i in 1:length(imageNames)){
    print(paste("Now processing image", imageNames[i]))
    leafImage <- readImage(paste(imagePath, "/", imageNames[i], sep=""))
    
    # create empty vectors to store sRGB values for all leaf pixels in image
    leafPixelCount <- sum(leafImage[ , , 4] == 1)
    R <- vector(mode="numeric", length=leafPixelCount)
    G <- vector(mode="numeric", length=leafPixelCount)
    B <- vector(mode="numeric", length=leafPixelCount)
    
    # create dataframe of sRGB values for all leaf pixels in an image
    leafPixelCount <- 1
    for(row in 1:nrow(leafImage)){
      for(col in 1:ncol(leafImage)){
        if(leafImage[row, col, 4] == 1){
          R[leafPixelCount] <- leafImage[row, col, 1]
          G[leafPixelCount] <- leafImage[row, col, 2]
          B[leafPixelCount] <- leafImage[row, col, 3]
          leafPixelCount <- leafPixelCount + 1
        }
      }
    }
    allsRGBpixels <- data.frame(R, G, B, stringsAsFactors=FALSE)
    
    # convert all leaf pixels from sRGB into other color spaces
    allHSVpixels <- convertColorSpace(allsRGBpixels, outputColorSpace="HSV")
    allYIQpixels <- convertColorSpace(allsRGBpixels, outputColorSpace="YIQ")
    allYCbCrpixels <- convertColorSpace(allsRGBpixels, outputColorSpace="YCbCr")
    allLabpixels <- convertColorSpace(allsRGBpixels, outputColorSpace="Lab")
    
    # calculate mean color index values for each component of each color space
    sRGBmeans[i, ] <- c(mean(allsRGBpixels$R), mean(allsRGBpixels$G), mean(allsRGBpixels$B))
    HSVmeans[i, ] <- c(mean(allHSVpixels$H), mean(allHSVpixels$S), mean(allHSVpixels$V))
    YIQmeans[i, ] <- c(mean(allYIQpixels$Y), mean(allYIQpixels$I), mean(allYIQpixels$Q))
    YCbCrmeans[i, ] <- c(mean(allYCbCrpixels$Y), mean(allYCbCrpixels$Cb), mean(allYCbCrpixels$Cr))
    Labmeans[i, ] <- c(mean(allLabpixels$L), mean(allLabpixels$a), mean(allLabpixels$b))
  }
  
  # create data frame with mean color index values for each image in each color space
  sRGBmeans <- as.data.frame(sRGBmeans, row.names=imageNames, stringsAsFactors=FALSE)
  names(sRGBmeans)[1:3] <- c("R", "G", "B")
  HSVmeans <- as.data.frame(HSVmeans, row.names=imageNames, stringsAsFactors=FALSE)
  names(HSVmeans)[1:3] <- c("H", "S", "V")
  YIQmeans <- as.data.frame(YIQmeans, row.names=imageNames, stringsAsFactors=FALSE)
  names(YIQmeans)[1:3] <- c("Y", "I", "Q")
  YCbCrmeans <- as.data.frame(YCbCrmeans, row.names=imageNames, col.names=c("Y", "Cb", "Cr"), stringsAsFactors=FALSE)
  names(YCbCrmeans)[1:3] <- c("Y", "Cb", "Cr")
  Labmeans <- as.data.frame(Labmeans, row.names=imageNames, col.names=c("L", "a", "b"), stringsAsFactors=FALSE)
  names(Labmeans)[1:3] <- c("L*", "a*", "b*")
  
  # combine all data into single list for function to output
  allImageData <- list(sRGBmeans, HSVmeans, YIQmeans, YCbCrmeans, Labmeans)
  names(allImageData) <- c("sRGB", "HSV", "YIQ", "YCbCr", "Lab")
  
  return(allImageData)
}