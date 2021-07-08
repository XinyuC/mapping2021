%% Prepare the script
close all
clear all
clc

%%

% folder_name = '..\images\';
folder_name = '..\images\downloads\';
addpath(folder_name)

%% Load all the images in the folder
% image_location = 'F:\Lecture\Summer2021\mapping2021\images\*.jpg';
% image_location = '..\downloads\*.jpg';
image_location= '..\images\downloads\*.jpg';
image_files = dir(image_location);
nfiles = length(image_files);

for n = 1:nfiles;
       current_image_name = image_files(n).name;
       current_image_folder = image_files(n).folder;
       current_image = imread(current_image_name);
       current_image_hsv = rgb2hsv(current_image);
       images_names{n} = current_image_name;
       images_rgb{n} = current_image;
       images_hsv{n} = current_image_hsv;
end

%%

i = 3;
image_hsv = images_hsv{i};
h_page = image_hsv(:,:,1);
s_page = image_hsv(:,:,2);
v_page = image_hsv(:,:,3);
%% Data preprossing

% Rescale the HSV data
image_newscale = image_hsv;
% Conver hue value to angles in radians
image_newscale(:,:,1) =  2*pi*h_page;
% image_newscale(:,:,1) =  h_page;
% Scale the SV data to the interval [0, 1]
image_newscale(:,:,2) = rescale( image_hsv(:,:,2));
image_newscale(:,:,3) = rescale( image_hsv(:,:,3));
rescaled_h = image_newscale(:,:,1);
rescaled_s = image_newscale(:,:,2);
rescaled_v = image_newscale(:,:,3);

% Reshape the N x M matrix to an NxM x 1 array

sz = size(image_newscale);
Nrows = sz(1);
Ncols = sz(2);
Npages = sz(3);
all_hsv = reshape(image_newscale, Nrows*Ncols, Npages);
all_h = all_hsv(:,1);
all_s = all_hsv(:,2);

all_v = all_hsv(:,3);
all_hs =all_hsv(:,1:2);

% Shut off values for saturation less than 0.15.
% Low saturation values mean that the
% lighting is very poor, or the pixels are basically versions of grey.
filtered_hs = all_hs((all_s > 0.15), :);
filtered_h = filtered_hs(:,1);
filtered_s = filtered_hs(:,2);
%%
[s_routliers, TF_s] = rmoutliers(filtered_s);

% [s_routliers, TF_s] = rmoutliers(filtered_s);
final_hs = filtered_hs((~TF_s), :);
final_h = final_hs(:,1);
final_s = final_hs(:,2);
% Remove duplicates, 
unique_hs = unique(final_hs, 'rows');
% unique_hs = final_hs;
unique_h = unique_hs(:,1);
unique_s = unique_hs(:,2);
s_mean = mean(unique_s);


k = 8;
[x, y] = pol2cart(unique_h, unique_s);
final_data = [x, y];
% % final_data = unique_hs;
[idx, C] =kmeans(final_data ,k,'Distance', 'sqeuclidean');
figure(22)
clf
for i_clust =1: k       

        polarplot(unique_h(idx == i_clust), unique_s(idx == i_clust),'.', 'Markersize', 1.5)
%         plot(filtered_h(idx == i_clust), filtered_s(idx == i_clust),'.', 'Markersize', 1.5)
        hold on
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
%         xlabel('x')
%         ylabel('y')
        str = sprintf('Top View with %d Clusters', k);
        title(str)
end


%%
[x_yellow, y_yellow] = pol2cart(0.125*2*pi, 0.8);

[x_centers, y_centers] = pol2cart(C(:,1),C(:,2));
% dist = vecnorm([x_centers, y_centers]  - [x_yellow, y_yellow],2,2);
% polarplot(theta, rho, 'kx')
dist = vecnorm(C  - [x_yellow, y_yellow],2,2);

% dist = abs(C- 0.16);

[minDist,markerIndex] = min(dist);
%%
main_cluster = unique_hs(idx == markerIndex,:);
% marker_cluster = main_cluster;
main_h = main_cluster(:,1);
main_s = main_cluster(:,2);
% [main_h_routliers, main_TF_h] = rmoutliers(main_h,'percentiles',[10 90]);
[main_h_routliers, main_TF_h] = rmoutliers(main_h);
[main_s_routliers, main_TF_s] = rmoutliers(main_s);
marker_cluster =main_cluster((~main_TF_h)&(~main_TF_s),:);
figure(56789)
polarplot(main_cluster(:,1),main_cluster(:,2), '.', 'Markersize', 1.5)
title('Marker Cluster')
figure(5678)
polarplot(marker_cluster(:,1),marker_cluster(:,2), '.', 'Markersize', 1.5)
title('Marker Cluster Without outliers')
%%
%{
figure(1)

polarplot(all_h, all_s, '.', 'Markersize', 1.5)

figure(2)
clf;
polarplot(final_h,final_s,'.', 'Markersize', 1.5) 


%%
% [x, y] = pol2cart(clean_h, clean_s); % Convert the polar coordinate to to two-dimensional Cartesian coordinates.
[x, y] = pol2cart(unique_h, unique_s); % Convert the polar coordinate to to two-dimensional Cartesian coordinates.
% final_data = [x, y];
final_data = unique_hs;

k = 4;
[idx, C] =kmeans(final_data ,k,'Distance', 'sqeuclidean');
figure(22)
clf
for i_clust =1: k       

        polarplot(unique_h(idx == i_clust), unique_s(idx == i_clust),'.', 'Markersize', 1.5)
%         plot(filtered_h(idx == i_clust), filtered_s(idx == i_clust),'.', 'Markersize', 1.5)
        hold on
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
%         xlabel('x')
%         ylabel('y')
        str = sprintf('Top View with %d Clusters', k);
        title(str)
end




[x_yellow, y_yellow] = pol2cart(0.13*2*pi, 0.3);

[x_centers, y_centers] = pol2cart(C(:,1),C(:,2));
dist = vecnorm([x_centers, y_centers]  - [x_yellow, y_yellow],2,2);
% polarplot(theta, rho, 'kx')
% dist = vecnorm(C  - [x_yellow, y_yellow],2,2);

% dist = abs(C- 0.16);

[minDist,markerIndex] = min(dist);
%%
main_cluster = unique_hs(idx == markerIndex,:);
% marker_cluster = main_cluster;
main_h = main_cluster(:,1);
main_s = main_cluster(:,2);
% [main_h_routliers, main_TF_h] = rmoutliers(main_h,'percentiles',[10 90]);
[main_h_routliers, main_TF_h] = rmoutliers(main_h);
[main_s_routliers, main_TF_s] = rmoutliers(main_s);
marker_cluster =main_cluster((~main_TF_h)&(~main_TF_s),:);
figure(5678)
polarplot(marker_cluster(:,1),marker_cluster(:,2), '.', 'Markersize', 1.5)
min_h = min(marker_cluster(:,1));
max_h = max(marker_cluster(:,1));
min_s = min(marker_cluster(:,2));
max_s = max(marker_cluster(:,2));

%%
hueMask = (image_newscale(:,:,1) < max_h)&(image_newscale(:,:,1) > min_h);
figure(4)
imshow(hueMask)

%%

satMask = (image_newscale(:,:,2) > min_s);
figure(5)
imshow(satMask)
%%
% &(image_newscale(:,:,2) < max_s);
figure(3)
imshow(image_hsv)
figure(4)
imshow(valMask)



hsMask = hueMask&satMask;
valMask = image_newscale(:,:,3) > 0.9;
figure(4)
imshow(valMask)
hsvMask = hueMask&satMask&valMask;
figure(6)
imshow(hsvMask)

%%
Nbins = 100; % How many intervals H and S space will be divided into

% Push the s-values and h values 
original_h = reshape(h_page, Nrows*Ncols, 1);
rounded_h = round(Nbins*original_h)+1;
rounded_s = round(Nbins*all_s)+1;
counts_contour = accumarray([rounded_s,rounded_h], 1);
%}

%% Perform data density analysis
% See: https://www.mathworks.com/matlabcentral/answers/225934-using-matlab-to-plot-density-contour-for-scatter-plot?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/478785-joint-histogram-2-d?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/520819-need-help-with-surf-x-y-and-temperature?s_tid=srchtitle


Nbins = 100; % How many intervals H and S space will be divided into

% Push the s-values and h values 
rounded_h = round(Nbins*all_h)+1;
rounded_s = round(Nbins*all_s)+1;

% Create an accumulation array, show in mesh
counts = accumarray([rounded_s,rounded_h], 1,[],[],NaN);  %remember Y corresponds to rows

% Next, shut off values for saturation less than 0.15, which are values of 15 or
% less (since we multiply by 100). Low saturation values mean that the
% lighting is very poor, or the pixels are basically versions of grey.
% These won't have any color information that we typically need for lane
% detection.
counts(1:15,:) = nan; 
figure(999); 
mesh(counts); % Show the results on a mesh
xlabel('Hue')
ylabel('Saturation');

% Create an accumulation array, show in contour. This does NOT remove zero
% values, because the contour command does not work right if the zeros are
% removed.
counts_contour = accumarray([rounded_s,rounded_h], 1);  %remember Y corresponds to rows
counts_contour(1:15,:) = nan; % Shut off values for hue less than 0.15, which are values of 15 or less (since we multiply by 100)
fliplr_contour = fliplr(counts_contour);
figure(998); 
contour(counts_contour,30); % Show the results on a mesh
xlabel('Hue')
ylabel('Saturation');

% Put the results in a scaled image. 
flipud_contour = flipud(counts_contour);
figure(997);
imagesc(counts_contour, 'XData', sort((rounded_h-1)/Nbins + 1/(2*Nbins)), 'YData', sort((rounded_s-1)/Nbins + 1/(2*Nbins)));
ax = gca;
ax.YDir = 'normal'
xlabel('Hue')
ylabel('Saturation');
hold on
%}