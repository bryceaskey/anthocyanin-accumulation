## Before running code:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder
- create a .csv file with columns for sample names (should match with image names) and their corresponding NAI

## Primary functions:
### main.R -
Calls all functions necessary for calculating mean color index values, sorting data into training/validation and test sets, training models, evaluating model accuracy, and heatmap generation with most accurate model.
Once code has started running, the user is prompted to input:
- mainPath -> full directory where all code files are saved
- imagePath -> full directory where all images which will be used to regression training and testing are saved
- absorbancePath -> full file path to .csv file containing sample names and corresponding NAI
  - sampleNumColumn -> column number in .csv file which contains sample names
  - sampleNAIColumn -> column number in .csv file which contains NAI data
- heatmapPath -> full directory where all images which heatmaps will be generated from are saved

## Data:
## Appendix S1
A table containing RMSE, r^2, and MAE values for the 110 regressions tested. Regressions are sorted from lowest to highest RMSE.
