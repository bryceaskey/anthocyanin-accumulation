# anthocyanin-accumulation
MATLAB code used to process leaf images, train regressions, and evaluate regressions for accuracy.

BEFORE RUNNING CODE:
- remove background pixels from all images
- save each leaf as a separate '.png' file in a single folder

# sort_images.m
Randomly sorts images in a specified folder into 2 subfolders, Test and Trainval.
By default, 20% of images are sorted into Test, and 80% into Trainval

# mean_color_index_values.m
Calculates mean color index values in 5 color spaces for images in a specified folder.

# 
