%creates a false color heatmap NAI values predicted by a regression at each pixel in an image, for each image in a folder
%trained regression must be loaded into workspace first
%heatmap images are saved as .png files to folder containing original images
%to distinguish heatmap images, "Heatmap_" is added to beginning of the original file name

myFolder = '\\client\c$\Users\bca08_000\Desktop\Testing\Test'; %replace with filepath to folder where images are saved
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.png');
images = dir(filePattern);

color_space = 'Name of color space'; %replace with name of color space which regression was trained with data from
%e.g. sRGB, HSV, YIQ, L*a*b*, or YCbCr

%create array to store average predicted NAI for each image
avg_NAI = cell(length(images) + 1, 2);
avg_NAI{1, 1} = "Image Name";
avg_NAI{1, 2} = "Average Predicted NAI";

%analyzes all files with extension .png in myFolder
%images are read in numeric order based on name -> starts at lowest and counts up
for image_count = 1:1:length(images)
    baseFileName = images(image_count).name;
    fprintf('Now reading %s\n', baseFileName)
    fullFileName = fullfile(myFolder, baseFileName);
    RGB_image = imread(fullFileName);
    [height, width, pages] = size(RGB_image);
    leaf_pixel_count = 0;
    leaf_pixels = zeros(height, width);
    RGB_image = double(RGB_image);
    
    %count leaf pixels in image -> leaf_pixel_count
    %in leaf_pixels, assign a 1 to leaf pixels
    for row = 1:1:height
        for column = 1:1:width
            total = sum(RGB_image(row, column, :));
            if total ~= 765 && total ~= 0
                leaf_pixels(row, column) = 1;
                leaf_pixel_count = leaf_pixel_count + 1;
            end
        end
    end
    
    %create new image for heatmap
    heatmap = zeros(height, width, pages);
    total_NAI = 0;
    RGB_image = uint8(RGB_image); %image must be in uint8 to change color space
    
    if strcmp(color_space, 'sRGB') == 1
        target_image = double(RGB_image);
    elseif strcmp(color_space, 'HSV') == 1
        target_image = rgb2hsv(RGB_image);
    elseif strcmp(color_space, 'YIQ') == 1 
        target_image = rgb2ntsc(RGB_image);
    elseif strcmp(color_space, 'L*a*b*') == 1
        target_image = rgb2lab(RGB_image);
    elseif strcmp(color_space, 'YCbCr') == 1
        target_image = double(rgb2ycbcr(RGB_image));
    else
        disp('Color space not recognized');
        return;
    end
    
    %apply regression to each leaf pixel to predict NAI at each pixel
    %assign pixel color in heatmap image based on predicted NAI
    for row = 1:1:height
        for column = 1:1:width
            if leaf_pixels(row, column) == 1
                pixel = reshape(target_image(row, column, :), [1, 3]);
                NAI = ExampleRegressionName.predictFcn(pixel); %replace with name of desired regression
                total_NAI = total_NAI + NAI;
                if NAI < 20
                    heatmap(row, column, :) = [231, 213, 217]; %pale white
                elseif NAI < 40
                    heatmap(row, column, :) = [223, 170, 186];
                elseif NAI < 60
                    heatmap(row, column, :) = [215, 127, 155];
                elseif NAI < 80
                    heatmap(row, column, :) = [207, 85, 124];
                elseif NAI < 100
                    heatmap(row, column, :) = [199, 42, 93];
                else
                    heatmap(row, column, :) = [191, 0, 63]; %dark pink
                end
            end
        end
    end
    
    %export heatmap image as a .png file to folder with original images
    %to name heatmap images, add 'heatmap_' to beginning of original image name
    heatmap = uint8(heatmap);
    filename = strcat(myFolder, '/Heatmap_', baseFileName);
    imwrite(heatmap, filename);
    
    %calculate average NAI by dividing total_NAI by number of leaf pixels
    avg_NAI{image_count + 1, 1} = cellstr(baseFileName);
    avg_NAI{image_count + 1, 2} = total_NAI/leaf_pixel_count;
end

clearvars -except avg_NAI
