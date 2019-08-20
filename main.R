# Calls all functions necessary for calculating mean color index values, sorting data into training/validation and test sets, training models, evaluating model accuracy, and heatmap generation with most accurate model.
# Once code has started running, the user is prompted to input:
#   mainPath - directory where all code files are saved
#   imagePath - directory where all images which will be used to regression training and testing are saved
#   absorbancePath - full file path to .csv file containing sample names and corresponding NAI
#     sampleNumColumn - column number in .csv file which contains sample names
#     sampleNAIColumn - column number in .csv file which contains NAI data
#   heatmapPath - directory where all images which heatmaps will be generated from are saved

# set working directory
mainPath <- readline(prompt="Enter full path to main directory (where all code files are saved): ")
if(getwd() != mainPath){
  setwd(mainPath)
}

# set directory containing all leaf images
imagePath <- readline(prompt="Enter full path of folder containing leaf images for regression training and testing: ")

# set directory containing actual NAI data
absorbanceDataPath <- readline(prompt="Enter full path of .csv file containing actual NAI values for each sample: ")
sampleNumColumn <- strtoi(readline(prompt="Enter the column number of the .csv file which contains sample names: "))
NAIColumn <- strtoi(readline(prompt="Enter the column number of the .csv file which contains NAI values: "))

# set directory containing all heatmap images
heatmapPath <- readline(prompt="Enter full path of folder containing leaf images to make false color heatmaps of: ")

# install necessary packages if not already installed, and load them into environment
packageList <- c("OpenImageR", "ggplot2", "caret", "kernlab", "monomvn", "fastICA", "lars", "brnn", "pls", "randomForest", "quantregForest", "Cubist", "penalized", "gbm", "plyr", "plsRglm", "spls")
newPackages <- packageList[!(packageList %in% installed.packages()[,"Package"])]
if(length(newPackages) > 0){
  install.packages(newPackages)
}
library(OpenImageR)
library(ggplot2)
library(caret)
library(kernlab)
library(monomvn)
library(fastICA)
library(lars)
library(brnn)
library(pls)
library(randomForest)
library(quantregForest)
library(Cubist)
library(penalized)
library(gbm)
library(plyr)
library(plsRglm)
library(spls)

# load functions into environment
source("meanColorIndexValues.R")
source("convertColorSpace.R")
source("prepareData.R")
source("preprocessData.R")
source("trainModels.R")
source("testModels.R")
source("makeHeatmap.R")

# calculate mean color index values in 5 color spaces: sRGB, HSV, YIQ, YCbCr, and L*a*b*
imageData <- meanColorIndexValues(imagePath)

# get parameters to center and scale color data in each color space
transformParams <- preprocessData(imageData)

# merge absorbance data from .csv file with color data
allData <- prepareData(imageData, absorbanceDataPath, sampleNumColumn, NAIColumn)

# train models with data from each color space
allModels <- vector("list", 5)
for(i in 1:length(allData)){
  allModels[[i]] <- trainModels(allData[[i]], transformParams[[i]])
}
names(allModels) <- c("sRGB", "HSV", "YIQ", "YCbCr", "Lab")

# evaluate the accuracy of each model using test data set, and create data frame with accuracy results
modelAccuracies <- testModels(allModels)

# create heatmaps illustrating spatial distribution anthocyanin accumulation for all images in a folder, and calculate average NAI for each image
heatmapAvgNAI <- makeHeatmap(heatmapPath, transformParams, modelAccuracies, allModels)
