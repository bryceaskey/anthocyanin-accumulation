BEFORE RUNNING CODE:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder

# sort_images.m
Randomly sorts images in a specified folder into 2 subfolders, Test and Trainval. By default, 20% of images are sorted into Test, and 80% into Trainval. Before running code, replace "\\\example\filepath" with filepath to folder containing images to be sorted. 

# mean_color_index_values.m
Calculates mean color index values in 5 color spaces for images in a specified folder. Output mean color index values are stored in cell arrays, which can be copied and pasted into a spreadsheet. Before running code, replace "\\\example\filepath" with filepath to folder containing images to be analyzed. 

# regression_testing.m
Uses regressions trained in a single color space to make predictions of NAI values. Output predictions are stored in the cell array "predicted", with each row of data representing all predictions for a single image. Before running code, all regressions must be loaded into the workspace, and named to match the name they are given in the code. Also, the "test" variable must be created, and contain mean color index values for the Test images in a single color space. The "test" variable must be of type double, and contain only mean color index values (i.e. no column headers or row labels). 

# make_heatmap.m
Uses a single trained regression to make NAI predictions at each pixel in an image, for all images in a folder. Generates a false color heatmap of anthocyanin accumulation based on NAI values at each pixel. Heatmap images are saved to the same folder which contains the original images. The average predicted NAI of all pixels in each image is stored in the cell array "avg_NAI". Before running code, replace "\\\example\filepath" with filepath to folder containing images to be analyzed.

# Appendix S1
An Excel spreadsheet containing mean color index values for leaf images in all color spaces used, actual and predicted Normalized Anthocyanin Index (NAI) values for all leaves, and calculated metrics used to evaluate regression accuracy.
