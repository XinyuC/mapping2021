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

%% 
i = 3;
image_rgb = images_rgb{i};
% Create the yellow
yellow_mask = fcn_LaneDet_yellowThresholding(image_rgb); % Call fcn_LaneDet_yellowThresholding
% Show the mask
figure(1)
imshow(yellow_mask)

%% Morphologically open image
% Erode and dilate the mask
clean_mask = fcn_LaneDet_ErodeAndDilate(yellow_mask);
figure(2)
imshow(clean_mask)


%%
image_hsv = fcn_LaneDet_dataPreparation(image_rgb);
% Call fcn_LaneDet_removeNoise
clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv);
sz = size(clean_image_hsv);
Nrows = sz(1);
Ncols = sz(2);
clean_hs_array = reshape(clean_image_hsv(:,:,1:2), Nrows*Ncols, 2);
clean_hs_array(isnan(clean_hs_array)) = 0;
[idx, C] =kmeans(clean_hs_array ,2);
plot(clean_hs_array(:,1), clean_hs_array(:,2),'.')