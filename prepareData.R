# Function to read .csv file containing actual anthocyanin absorbance data, and merge with image color data
# Inputs are:
#   list of data frames with image color data
#   name of .csv file with absorbance data
#   column number containing samples #'s (should correspond with image names) - 0's will be added to beginning automatically
#   column number containing Normalized Anthocyanin Index (NAI)
# Outputs are:
#   list containing data frames with color data in each color space (1st 3 columns), and NAI (4th column)

prepareData <- function(imageData, absorbanceDataPath, sampleNumColumn, NAIColumn){
  
  # read .csv file with absorbance data into environment
  absorbanceData <- read.csv(file=absorbanceDataPath, header=TRUE, stringsAsFactors=FALSE)
  
  # store color space names
  colorSpaceNames <- names(imageData)
  
  # initialize empty list to store output modified data frames
  output <- list()
  
  # loop through each color space
  for(i in 1:length(imageData)){
    colorSpaceData <- imageData[[i]]
    NAI <- vector(mode="numeric", length=nrow(colorSpaceData)) # empty vector to store NAI for each image
    # loop through each image
    for(j in 1:nrow(colorSpaceData)){
      imageName <- row.names(colorSpaceData)[j]
      imageName <- gsub("(?<![0-9])0+", "", imageName, perl = TRUE) # remove leading zeros
      sampleNum <- strtoi(strsplit(imageName, split=".", fixed=TRUE)[[1]][[1]]) # remove ".png" from end of image name
      # match sample number from image name to sample number in absorbance data, and insert NAI into vector
      rowInd <- match(sampleNum, absorbanceData[ , sampleNumColumn])
      NAI[j] <- absorbanceData[rowInd, NAIColumn]
    }
    # add vector with NAI values into data frame with image color data as a 4th column
    colorSpaceData <- cbind(colorSpaceData, NAI)
    output[[colorSpaceNames[i]]] <- colorSpaceData
  }
  return(output)
}