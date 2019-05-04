# anthocyanin-accumulation
MATLAB code used to process leaf images, train regressions, and evaluate regressions for accuracy.

BEFORE RUNNING CODE:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder

# sort_images.m
Randomly sorts images in a specified folder into 2 subfolders, Test and Trainval. By default, 20% of images are sorted into Test, and 80% into Trainval
Input:
Output:

# mean_color_index_values.m
Calculates mean color index values in 5 color spaces for images in a specified folder.
Input:
Output:

# regression_testing.m
Uses regressions trained in a color space to make predictions of NAI values.
Input:
Output:

# make_heatmap.m
Uses a single trained regression to make NAI predictions at each pixel in an image, for all images in a folder. Generates a false color heatmap of anthocyanin accumulation based on NAI values at each pixel. Averages the predicted NAI of all pixels in the image.
Input:
Output:
