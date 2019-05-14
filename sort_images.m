%randomly sorts images in a folder into 2 groups, Test and Trainval
%Test and Trainval folders are created as subfolders within the original folder
%by default, 20% of images are sorted into Test, and 80% into Trainval
clc; clear;

myFolder = '\\client\c$\Users\Bryce\Desktop\ArabidopsisPhotos1.20.2019\Backup'; %replace with filepath to folder where images are saved
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.png');
images = dir(filePattern);

%make list of image names in myFolder
image_names = cell(1, length(images));
for image_count = 1:1:length(images)
    image_names{image_count} = string(images(image_count).name);
end

%scramble image names into random order
ii = randperm(numel(image_names));
image_names = image_names(ii);

%make Test and Trainval subfolders
mkdir(strcat(myFolder, '\Test'))
mkdir(strcat(myFolder, '\Trainval'));

test_count = 0;

%move first 20% of images in scrambled list into Test subfolder
%move remaining images in scrambles list into Trainval subfolder
for image_count = 1:1:numel(image_names)
    original_filepath = strcat(myFolder, '\', string(image_names(image_count)));
    if image_count < numel(image_names)/5
        new_filepath = strcat(myFolder, '\Test\', string(image_names(image_count)));
        movefile(original_filepath, new_filepath);
        test_count = test_count + 1;
    else
        new_filepath = strcat(myFolder, '\Trainval\', string(image_names(image_count)));
        movefile(original_filepath, new_filepath);
    end
end

%display number of original images, and number of images sorted into Test
%and Trainval
fprintf('Of %d images, %d were sorted into Test, and %d into Trainval.\n', image_count, test_count, image_count - test_count)
