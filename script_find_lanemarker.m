% The script is used to find the centerline of lane markers by thresholding the image using HSV,
%  and actually, only V is used.
% I still think there is space for improvement, now the centerline is more like a curve than a straight line, 
% this needs to be fixed. Converting pixels to LLA coordinates is another problem, 
% I guess it results from the wrong latitude and longitude limits. 
% Apart from that, different colors of pavement will cause failure, and I do not have a good idea to solve this. 

%% Load the test track image
close all
clear all
clc
map_struct = load('testTrackImage.mat');
map_mat = map_struct.big_imag;
% map_struct = load('ParkingLotData.mat');
% map_mat = map_struct.original_map;
fig_1 = figure(1)
imshow(map_mat)
% Set layout
fig_1.CurrentAxes.InnerPosition = fig_1.CurrentAxes.OuterPosition;
X_original_lim = fig_1.CurrentAxes.XLim;
Y_original_lim = fig_1.CurrentAxes.YLim;

%Select the detection area
disp('Zoom in to select detection area, hit any button to continue')
pause;

%% Get the image of the detection region, cluster the V value
X_lim = round(fig_1.CurrentAxes.XLim);
Y_lim = round(fig_1.CurrentAxes.YLim);
frame = getframe(fig_1);
image_road_rgb= frame.cdata;
% fig_2 = figure(2)
% imshow(image_road_rgb)
% fig_2.CurrentAxes.InnerPosition = fig_2.CurrentAxes.OuterPosition;

% Convert the RGB to HSV
image_road_hsv = rgb2hsv(image_road_rgb);
h_value = image_road_hsv(:,:,1);
s_value = image_road_hsv(:,:,2);
v_value = image_road_hsv(:,:,3);
figure(2)
imshow(image_road_hsv)

% Rescale the hsv values
% rescaled_h = rescale(filled_h);
% rescaled_s = rescale(filled_s);
rescaled_v = rescale(v_value);
image_road_rescaled = image_road_hsv;
image_road_rescaled(:,:,3) = rescaled_v;

% Cluster V values
sz = size(rescaled_v);
Nrows = sz(1);
Ncols = sz(2);
% % 
% all_h = reshape(rescaled_h,Nrows*Ncols,1);
% all_s = reshape(rescaled_s,Nrows*Ncols,1);
all_v = reshape(rescaled_v,Nrows*Ncols,1);
[idx, V_center] =kmeans(all_v, 2);


%% Build hsv mask

clc
lower_val = min(V_center);
upper_val = max(V_center);
valueMask = (rescaled_v >= upper_val); % Since the lane marker is always brighter than the pavement
figure(3);
imshow(valueMask)


%% Smooth the jagged edges
% Use conv2 to add blur to the image for 2 times
windowSize = 45;
kernel = ones(windowSize) / windowSize^2;
image_road_jagged = valueMask;
for i =1:2
    image_road_blur= conv2(image_road_jagged , kernel, 'same');
    binaryImage = image_road_blur > 0.1;
    image_road_jagged = binaryImage;
    
end
figure(4)
imshow(binaryImage)
% Show the center line of the lane marker
reducedmap = bwskel(binaryImage);
figure(8);
imshow(reducedmap)


%% Get the latitude and longtitude vector
try
    temp = allImages(1).Nsteps_offset_lon;
catch
    load('testTrackData.mat');
end

sample_lonVec = allImages(1).lonVec;
sample_latVec = allImages(1).latVec;
sample_imag   = allImages(1).imag;
Nrows = length(sample_imag(:,1,1));
Ncols = length(sample_imag(1,:,1));

Nlons = length(sample_lonVec);
Nlats = length(sample_latVec);

NLonSteps = length(stepsLon);
NLatSteps = length(stepsLat);
% Preallocate vectors
big_lonVec = zeros(NLonSteps*Nlons,1);
% Fill big_lonVec
for ithLong = 1:NLonSteps
    % Create number
    imageNumber = ithLong;  
    % Grab results
    lonVec = allImages(imageNumber).lonVec;
    % Calculated indices
    indices = (1:Ncols)' + (ithLong-1)*Ncols;
    big_lonVec(indices) = lonVec;
end
% For debugging: figure; plot(diff(big_lonVec))
% Preallocate vectors
big_latVec = zeros(NLatSteps*Nlats,1);

% Fill big_latVec
for jthLat = 1:NLatSteps
    
    % Create number
    imageNumber = 10*(jthLat-1)+1;
       
    % Grab results
    latVec = allImages(imageNumber).latVec;
    
    % Calculated indices - as jthLat numbers get larger, latitude gets smaller
    %indices = (1:Nrows)' + (NLatSteps-jthLat)*Nrows;
    indices = (1:Nrows)' + (jthLat-1)*Nrows;
    big_latVec(indices) = latVec;
    
end

%% The following sections still have some problems

%% Find the latitude and longtitude limits for the current figure, and Convert pixels to LLA coordinates

%Get limits
lon_value = big_lonVec(X_lim).';
lat_value = big_latVec(Y_lim).';
lat_lim =sort(lat_value);
lon_lim =sort(lon_value);
%  Convert pixels to LLA coordinates
rasterSize = [Nrows Ncols];
R = georefcells(lat_lim, lon_lim, rasterSize);
flipmap = flipud(reducedmap);
[r,c] = find(flipmap);
[lat_data, lon_data] = intrinsicToGeographic(R,c,r);

%% Visualize the resultes
fig_r = figure(10);
% fig_r.Position = fig_2.Position;
satellite_basemap_name = 'satellite';

%  Geobubble
gb1 = geobubble(lat_data, lon_data, 'Basemap',satellite_basemap_name );
gb1.MapLayout = 'maximized';
% gb1.ZoomLevel = starting_zoom;
gb1.BubbleWidthRange = 1;
%% Fill all h and s value with the background value, test only
unique_h = unique(h_value);
unique_s = unique(s_value);
unique_v = unique(v_value);
n_unique_h = length(unique_h); 
num_lst = zeros(n_unique_h,1);

for n_unique = 1:n_unique_h
    k = h_value(h_value == unique_h(n_unique));
    num_lst(n_unique,1) = length(k);
end
figure(4354)
bar(unique_h, num_lst)

[max_num, max_index] = max(num_lst);
bg_h = unique_h(max_index);
image_road_fill = image_road_hsv;
filled_h = h_value;
filled_h(:) = bg_h;
image_road_fill(:,:,1) = filled_h;
figure(5)
imshow(image_road_fill)

% 
% % Fill all s value with the background color

n_unique_s = length(unique_s); 
num_lst = zeros(n_unique_s,1);


for n_unique = 1:n_unique_s
    k = s_value(s_value == unique_s(n_unique));
    num_lst(n_unique,1) = length(k);
end


[max_num_s, max_index_s] = max(num_lst);
bg_s = unique_s(max_index_s);

filled_s = s_value;
filled_s(:) = bg_s;
image_road_fill(:,:,2) =0;
figure(5)
imshow(image_road_fill)

% Fill all v value with the background color
% unique_v = unique(v_value);
% 
% n_unique_v = length(unique_v); 
% num_lst = zeros(n_unique_v,1);
% 
% for n_unique = 1:n_unique_v
%     k = v_value(v_value == unique_v(n_unique));
%     num_lst(n_unique,1) = length(k);
% end
% 
% 
% [max_num_v, max_index_v] = max(num_lst);
% bg_v = unique_v(max_index_v);
% 
% filled_v = v_value;
% filled_v(:) = bg_v;
% image_road_fill(:,:,3) = filled_v;
% figure(5)
% imshow(image_road_fill)
