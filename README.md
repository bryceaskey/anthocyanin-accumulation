## Before running code:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder
- create a .csv file with columns for sample names (should match with image names) and their corresponding NAI

## Primary functions:
### main.R -
Calls all functions necessary for calculating mean color index values, sorting data into training/validation and test sets, training models, evaluating model accuracy, and heatmap generation with most accurate model.
Once code has started running, the user is prompted to input:
- mainPath - directory where all code files are saved
- imagePath - directory where all images which will be used to regression training and testing are saved
- absorbancePath - full file path to .csv file containing sample names and corresponding NAI
  - sampleNumColumn - column number in .csv file which contains sample names
  - NAIColumn - column number in .csv file which contains NAI data
- heatmapPath - directory where all images which heatmaps will be generated from are saved

Alternatively, individual functions can be called manually by the user. To use this apporach, the main working directory which contains all code files must first be set with the command setwd(). All functions and packages must be loaded into the R environment manually using the source(), install.packages(), and library() commands. See lines 27 - 58 of main.R to view all necessary functions and packages.

### meanColorIndexValues.R - 
Function to calculate mean color index values in 5 color spaces for a set of images in a directory. The function can be called from the console with the following syntax: imageData <- meanColorIndexValues(imagePath)
- imagePath - directory where all code files are saved

### preprocessData.R - 
Function to calculate parameters necessary for centering and scaling of mean color index values. The function can be called from the console with the following syntax: transformParameters <- preprocessData(imageData)
- imageData - output of meanColorIndexValues.R. A list of data frame which contain mean color index values for each image in the imagePath directory in 5 color spaces.

### prepareData.R - 
Function to automate the merging of sample NAI data with mean color index values. The function can be called from the console with the following syntax: allData <- prepareData(imageData)
- imageData - output of meanColorIndexValues.R. A list of data frames which contain mean color index values for each image in the imagePath directory in 5 color spaces.
- csvFilepath - full path to .csv file containing sample names and corresponding NAI
- sampleNumColumn - column number in .csv file which contains sample names
- NAIColumn - column number in .csv file which contains NAI data

### trainModels.R -
Function to train 22 regression models from the "caret" package with training data. Input data must first be merged, centered, and scaled with the functions preprocessData.R and prepareData.R. The function can be called from the console with the following syntax: colorSpaceModels <- trainModels(allData[[i]], transformParameters[[i]]).
- allData - output of prepareData.R. A list of data frames which contain mean color index values for each image in the imagePath directory in 5 color spaces, and their corresponding NAI.
- transformParameters - output of preprocessData.R. Parameters necessary for centering and scaling of mean color index values.
- i - a number 1-5 which corresponds to each of the 5 color spaces (1 - sRGB, 2 - HSV, 3 - YIQ, 4 - YCbCr, 5 - Lab)

To automate model training for all 5 color spaces at once, and to combine all models into a single variable, a for loop can be used as shown in lines 69-74 of main.R.

### testModels.R -
Function to evaluate accuracy of all trained models using test data. Creates a data frame with the RMSE, r^2, and MAE for each model, sorted from lowest to highest RMSE. The function can be called from the console with the following syntax: modelAccuracies <- testModels(allModels)
- allModels - output of trainModels.R across all color spaces. Contains all trained models, and test data for model accuracy evaluation.


### makeHeatmap.R - 
Function to create false-color heatmaps based on NAI predicted by a trained model. Heatmaps are saved to the same directory which contains the original images. The function also output the average NAI for each of the heatmap images. The function can be called from the console with the following syntax: heatmapAvgNAI <- makeHeatmap(heatmapPath, transformParameters, modelAccuracies, allModels)
- heatmapPath - directory containing images to generate heatmaps of. All images must have background pixels removed, and each should only contain a single leaf.
- transformParameters - output of preprocessData.R. Parameters necessary for centering and scaling of mean color index values.
- modelAccuracies - output of testModels.R. List of accuracy parameters for all models.
- allModels - output of trainModels.R. Contains all trained models. By default, the most accurate model is selected for use in heatmap generation.

## Secondary functions:
### convertColorSpace.R - 
Function to convert sRGB pixel data into different color spaces. Available color spaces: HSV, YIQ, YCbCr, and Lab. The function is called by meanColorIndexValues.R and makeHeatmap.R.

## Data:
### Appendix S1 - 
A table containing RMSE, r^2, and MAE values for the 110 regressions tested. Regressions are sorted from lowest to highest RMSE.
