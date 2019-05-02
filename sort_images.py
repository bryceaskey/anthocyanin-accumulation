#randomly sorts images in a folder into 2 groups, Test and Trainval
#Test and Trainval folders are created as subfolders within the folder which orginally contained the num_images
#by default, 20% of images are sorted into Test, and 80% into Trainval

import os
import random

#specify file path to folder with images, and generate list of all images contained in the folder
file_path = r'C:\Users\Bryce\Desktop\ArabidopsisPhotos1.20.2019\Backup'
file_names = os.listdir(path = file_path)

#make Test and Trainval subfolders
os.mkdir(file_path + '\\Trainval')
os.mkdir(file_path + '\\Test')

#all images assigned to Trainval group
trainval = file_names

#randomly select 20% of images for Test group
num_images = len(file_names)
test = random.sample(file_names, int(num_images/5))

#remove Test images from Trainval group, and move to Test folder
for image in test:
    trainval.remove(image)
    old = file_path + '\\' + image
    new = file_path + '\\Test\\' + image
    os.rename(old, new)

#move Trainval images to Trainval folder
for image in trainval:
    old = file_path + '\\' + image
    new = file_path + '\\Trainval\\' + image
    os.rename(old, new)
