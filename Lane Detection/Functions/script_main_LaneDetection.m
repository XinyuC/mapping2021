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
i = 1;
image_rgb = images_rgb{i};
image_hsv = rgb2hsv(image_rgb);
h_value = image_hsv(:,:,1);
s_value = image_hsv(:,:,2);
v_value = image_hsv(:,:,3);
clean_image_hsv = image_hsv; % Create a copy of the HSV image;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sz = size(image_hsv); % Grab the size of the image
Nrows = sz(1); % Extract the number of rows
Ncols = sz(2); % Extract the number of columns
Npages = sz(3);% Extract the number of pages
v_low = 0.4; % Set the cut off value for Value
s_low = 0.35; % Set the cut off value for Saturation
h_low = 0.08; % Set the lower cut off value for Hue
h_high = 0.16; % Set the higher cut off value for Hue
for j = 1:Ncols;
    clean_image_hsv(v_value(:,j)< v_low, j, :) = nan;
    clean_image_hsv(s_value(:,j)< s_low, j, :) = nan;
    clean_image_hsv((h_value(:,j) >= h_high)|(h_value(:,j) <= h_low), j, :) = nan;
end
image_s = clean_image_hsv(:,:,2);
image_v = clean_image_hsv(:,:,3);
figure(1)
clf;
imshowpair(image_rgb, clean_image_hsv,'montage');

%%
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
clc
image_hsv = fcn_LaneDet_dataPreparation(image_rgb);
% Call fcn_LaneDet_removeNoise
clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv);
sz = size(clean_image_hsv);
Nrows = sz(1);
Ncols = sz(2);
clean_hs_array = reshape(clean_image_hsv(:,:,1:2), Nrows*Ncols, 2);
hs_target = clean_hs_array(~isnan(clean_hs_array(:,1)),:);
[hs_clean, hs_TF] = rmoutliers(hs_target);
h_lower = min(hs_clean(:,1));
h_upper = max(hs_clean(:,1));
s_lower = min(hs_clean(:,2));
s_upper = max(hs_clean(:,2));
hue_mask = (clean_image_hsv(:,:,1) < h_upper)&(clean_image_hsv(:,:,1) > h_lower);
sat_mask = (clean_image_hsv(:,:,2) < s_upper)&(clean_image_hsv(:,:,2) > s_lower);
figure(3)
imshow(hue_mask);
% axis([0 1 0 1]);
figure(4)
imshow(sat_mask);
% axis([0 1 0 1]);
% h_target = clean_hs_array(clean_hs_array(:,1)==nan);
% s_target = clean_hs_array(:,2);

% A = rmoutliers(clean_hs_array);
% A = clean_hs_array(~isnan(clean_hs_array));
% [idx, C] =kmeans(clean_hs_array ,2);
%%
h_target = clean_hs_array(clean_hs_array(:,1) ~=0 ,1);
% plot(clean_hs_array(:,1), clean_hs_array(:,2),'.')