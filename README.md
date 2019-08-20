## Before running code:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder
- create a .csv file with columns for sample names (should match with image names) and their corresponding NAI

## Primary functions:
### main.R -
Calls all functions necessary for calculating mean color index values, sorting data into training/validation and test sets, training models, evaluating model accuracy, and heatmap generation with most accurate model.
Once code has started running, the user is prompted to input:
- mainPath - full directory where all code files are saved
- imagePath - full directory where all images which will be used to regression training and testing are saved
- absorbancePath - full file path to .csv file containing sample names and corresponding NAI
  - sampleNumColumn - column number in .csv file which contains sample names
  - sampleNAIColumn - column number in .csv file which contains NAI data
- heatmapPath - full directory where all images which heatmaps will be generated from are saved

Alternatively, individual functions can be called manually by the user. To use this apporach, the main working directory which contains all code files must first be set with the command setwd(). All functions and packages must be loaded into the R environment manually using the source(), install.packages(), and library() commands. See lines 20 - 51 of main.R to view all necessary functions and packages.

### meanColorIndexValues.R - 
Function to calculate mean color index values in 5 color spaces for a set of images in a directory. The function can be called from the console with the following syntax: imageData <- meanColorIndexValues(imagePath)
- imagePath - full directory where all code files are saved

### preprocessData.R - 
Function to calculate parameters necessary for centering and scaling of mean color index values. The function can be called from the console with the following syntax: transformParameters <- preprocessData(imageData)
- imageData - output of meanColorIndexValues.R. A list of data frame which contain mean color index values for each image in the imagePath directory in 5 color spaces.

### prepareData.R - 
Function to automate the merging of sample NAI data with mean color index values. The function can be called from the console with the following syntax: allData <- prepareData(imageData)
- imageData - output of meanColorIndexValues.R. A list of data frames which contain mean color index values for each image in the imagePath directory in 5 color spaces.

### trainModels.R -
Function to train 22 regression models from the "caret" package with mean color index values in 5 color spaces. Input data must first be merged, centered, and scaled with the functions preprocessData.R and prepareData.R. The function can be called from the console with the following syntax: colorSpaceModels <- trainModels(allData[[i]], transformParameters[[i]]).
- allData - output of prepareData.R. A list of data frames which contain mean color index values for each image in the imagePath directory in 5 color spaces, and their corresponding NAI.
- transformParameters - output of preprocessData.R. Parameters necessary for centering and scaling of mean color index values.
- i - a number 1-5 which corresponds to each of the 5 color spaces (1 - sRGB, 2 - HSV, 3 - YIQ, 4 - YCbCr, 5 - Lab)

To automate model training for all 5 color spaces at once, and to combine all models into a single variable, a for loop can be used as shown in lines

### testModels.R -
Function to 


### makeHeatmap.R - 

## Data:
## Appendix S1
A table containing RMSE, r^2, and MAE values for the 110 regressions tested. Regressions are sorted from lowest to highest RMSE.
