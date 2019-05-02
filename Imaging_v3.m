clc; clear;

myFolder = '\\client\c$\Users\Bryce\Desktop\ArabidopsisPhotos1.20.2019'; %replace with filepath to folder where images are saved
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.png');
images = dir(filePattern);

all_means = zeros(length(images), 5, 3); %RGB/HSV/YIQ/Lab/YCbCr
predictions = zeros(length(images), 1);

%analyzes all files with extension .png in myFolder
%images are read in numeric order based on name -> starts at lowest and
%counts up
for image_count = 1:1:length(images)
    baseFileName = images(image_count).name;
    fprintf('Now reading %s\n', baseFileName)
    fullFileName = fullfile(myFolder, baseFileName);
    image = imread(fullFileName);
    [height, width, pages] = size(image);
    leaf_pixel_count = 0;
    leaf_pixels = zeros(height, width);
    RGB_image = double(image);

    %count leaf pixels in image -> leaf_pixel_count
    %in leaf_pixels, assign a 1 to leaf pixels
    for row = 1:1:height
        for column = 1:1:width
            total = sum(RGB_image(row, column, :));
            if total ~= 765 && total ~= 0
                leaf_pixel_count = leaf_pixel_count + 1;
                leaf_pixels(row, column) = 1;
            end
        end
    end

    %convert RGB image into different color spaces
    RGB_image = uint8(RGB_image);
    HSV_image = rgb2hsv(RGB_image);
    YIQ_image = rgb2ntsc(RGB_image);
    Lab_image = rgb2lab(RGB_image);
    YCbCr_image = double(rgb2ycbcr(RGB_image));
    RGB_image = double(RGB_image);

    %separate leaf pixel data in all color spaces
    all_pixels = zeros(leaf_pixel_count, 5, 3); %RGB/HSV/YIQ/Lab/YCbCr
    pixel_count = 1;
    for row = 1:1:height
        for column = 1:1:width
            if leaf_pixels(row, column) == 1
                all_pixels(pixel_count, 1, :) = RGB_image(row, column, :);
                all_pixels(pixel_count, 2, :) = HSV_image(row, column, :);
                all_pixels(pixel_count, 3, :) = YIQ_image(row, column, :);
                all_pixels(pixel_count, 4, :) = Lab_image(row, column, :);
                all_pixels(pixel_count, 5, :) = YCbCr_image(row, column, :);
                pixel_count = pixel_count + 1;
            end
        end
    end

    %average leaf pixel data in each color space
    for clr_space = 1:1:5
        for clr_comp = 1:1:3
            all_means(image_count, clr_space, clr_comp) = mean(all_pixels(:, clr_space, clr_comp));
        end
    end
end

%separate data in all color spaces into different variables
RGB_means = reshape(all_means(:, 1, :), [length(images), 3]);
HSV_means = reshape(all_means(:, 2, :), [length(images), 3]);
YIQ_means = reshape(all_means(:, 3, :), [length(images), 3]);
Lab_means = reshape(all_means(:, 4, :), [length(images), 3]);
YCbCr_means = reshape(all_means(:, 5, :), [length(images), 3]);
