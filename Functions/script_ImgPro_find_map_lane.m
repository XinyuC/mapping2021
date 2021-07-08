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
% pause;


%% Get the image of the detection region, cluster the V value
% close(fig_3)
X_lim = round(fig_1.CurrentAxes.XLim);
Y_lim = round(fig_1.CurrentAxes.YLim);
frame = getframe(fig_1);
image_road_rgb= frame.cdata;

% fig_2.CurrentAxes.InnerPosition = fig_2.CurrentAxes.OuterPosition;

% Smooth the image
image_road_blur = imgaussfilt(image_road_rgb, 30);
% image_road_blur = image_road_rgb;
% Convert the RGB to HSV
image_road_hsv = rgb2hsv(image_road_blur);
% Scale the HSV data to the interval [0, 1]
image_road_rescale = image_road_hsv;
image_road_rescale(:,:,1) = rescale( image_road_hsv(:,:,1));
image_road_rescale(:,:,2) = rescale( image_road_hsv(:,:,2));
image_road_rescale(:,:,3) = rescale( image_road_hsv(:,:,3));
rescaled_h = image_road_rescale(:,:,1);
rescaled_s = image_road_rescale(:,:,2);
rescaled_v = image_road_rescale(:,:,3);

% Reshape the N x M matrix to an NxM x 1 array
sz = size(image_road_rescale);
Nrows = sz(1);
Ncols = sz(2);
Npages = sz(3);
all_hsv = reshape(image_road_rescale, Nrows*Ncols, Npages);
all_h = all_hsv(:,1);
all_s = all_hsv(:,2);
all_v = all_hsv(:,3);
all_hs = [all_h, all_s];


%% Resize the image to a small one
image_road_small = imresize(image_road_rescale, 0.1);
sz_small = size(image_road_small);
all_hsv_small = reshape(image_road_small, sz_small(1)*sz_small(2), 3);
all_h_small = all_hsv_small(:,1);
all_s_small = all_hsv_small(:,2);
all_v_small = all_hsv_small(:,3);




%% Show figures and plots to analy
% Image in HSV color
% fig_2 = figure(2);
% imshow(image_road_hsv)

% Visualize the rescaled image
% figure(3)
% imshow(image_road_rescale)

% Visualize the H value of the rescaled matrix
figure(4)
imshow(image_road_rescale(:,:,1))

% Visualize the V value of the rescaled matrix
% figure(5)
% imshow(image_road_rescale(:,:,3))

% Visualize the S vs H plot
% figure(6)
% plot(all_h, all_s, '.')
% xlabel('Hue')
% ylabel('Sat')

% Visualize the V vs H plot
% figure(7)
% plot(all_h, all_v, '.')
% xlabel('Hue')
% ylabel('Val')

% Visualize the V vs s plot
% figure(8)
% plot(all_s, all_v, '.')
% xlabel('Sat')
% ylabel('Val')


%% K-mean cluster for h
k_h =2;
[idx_h, C_h] =kmeans(all_h,k_h);
upper_hue = mean(C_h);
lower_hue = min(C_h);



%% K-mean cluster for s
k_s = 2;
[idx_s, C_s] =kmeans(all_s,k_s);
lower_sat = min(C_s);
upper_sat = max(C_s);

%% K-mean cluster for v
k_v = 2;
[idx_v, C_v] =kmeans(all_v,k_v);
lower_val = min(C_v);
upper_val = max(C_v);


%% Build HSV mask
hueMask =(rescaled_h <upper_hue);
figure(9)
imshow(hueMask)

satMasklow= (rescaled_s < lower_sat);
satMaskhigh = (rescaled_s > upper_sat);
satMask = satMasklow|satMaskhigh;
figure(10)
imshow(satMask)

% hsMask = hueMask&satMask;
% figure(34)
% imshow(hsMask)

valMask =(rescaled_v > upper_val);
figure(11)
imshow(valMask)


hsvMask = hueMask&satMask&valMask;
figure(12)
imshow(hsvMask)


%% Plot clusters
figure(13)
for idx =1: k_h
    plot(all_h(idx_h==idx, 1), all_s(idx_h==idx, 1), '.')
%     plot3(all_h(idx_h==idx, 1), all_s(idx_h==idx, 1),all_v(idx_h == idx,1), '.')
    hold on
end
xlabel('Hue')
ylabel('Sat')


figure(14)
for idx =1: k_s
    plot(all_s(idx_s==idx, 1), all_v(idx_s==idx, 1), '.')
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
    hold on

end
xlabel('Sat')
ylabel('Value')


figure(15)
for idx =1: k_v
    plot(all_s(idx_v==idx, 1), all_v(idx_v==idx, 1), '.')
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
    hold on
end
xlabel('Hue')
ylabel('Value')