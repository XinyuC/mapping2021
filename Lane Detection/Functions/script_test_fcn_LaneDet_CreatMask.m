%% Prepare the script
close all
clear all
clc

%% Add path


folder_name = '..\images\test\';
addpath(folder_name)

%% Load all the images in the folder
image_location= '..\Images\test\*.jpg';
image_files = dir(image_location);
nfiles = length(image_files);

for n = 1:nfiles;
       current_image_name = image_files(n).name;
       current_image_folder = image_files(n).folder;
       current_image = imread(current_image_name);
       images_names{n} = current_image_name;
       images_rgb{n} = current_image;
end
%% Test 
close all
i = 1;
image_rgb = images_rgb{i};
[hMask, sMask, hsMask]= fcn_LaneDet_createYellowMask(image_rgb);
figure(1)
imshow(hMask)
title('Hue Mask')
figure(2)
imshow(sMask)
title('Saturation Mask')
fig3 = figure(3)
imshow(hsMask)
title('HS Mask')

%% Morphologically open image
se = strel('disk',5);
clean_image = imopen(hsMask, se);