%% Load the test track image
close all
clear all
clc

% Load the image
image_road_rgb = imread('..\images\colors_8pm_cloudy.jpg');

% image_road_rgb = imread('..\images\colors_11am_sunny.jpg');
%% Smooth the image
%image_road_blur = imgaussfilt(image_road_rgb, 15);
image_road_blur = image_road_rgb;

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

%% Show figures and plots to analy
% Original image
fig_1 = figure(1);
imshow(image_road_rgb);
title('Original');

% Blurred image
fig_11 = figure(11);
imshow(image_road_blur);
title('Original blurred');

% Image in HSV color
fig_2 = figure(2);
imshow(image_road_hsv)
title('HSV image');

% Visualize the rescaled image
figure(3)
imshow(image_road_rescale)
title('Rescaled image');

% Visualize the H value of the rescaled matrix
figure(4)
imshow(image_road_rescale(:,:,1))
title('H space only from HSV image')

% Visualize the H value of the rescaled matrix
figure(45)
imshow(image_road_rescale(:,:,2))
title('S space only from HSV image')

% Visualize the V value of the rescaled matrix
figure(5)
imshow(image_road_rescale(:,:,3))
title('V space only from HSV image')

%% Visualize the S vs H plot
figure(6)
clf;
plot(all_h, all_s, '.','Markersize',0.05)
xlabel('Hue')
ylabel('Sat')
title('Hue versus Saturation');


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
figure(999); mesh(counts); % Show the results on a mesh
xlabel('Hue')
ylabel('Saturation');

% Create an accumulation array, show in contour. This does NOT remove zero
% values, because the contour command does not work right if the zeros are
% removed.
counts_contour = accumarray([rounded_s,rounded_h], 1);  %remember Y corresponds to rows
counts_contour(1:15,:) = nan; % Shut off values for hue less than 0.15, which are values of 15 or less (since we multiply by 100)
figure(998); contour(counts_contour,30); % Show the results on a mesh
xlabel('Hue')
ylabel('Saturation');

% Put the results in a scaled image. 
figure(997);
imagesc(fliplr(counts_contour), 'XData', (rounded_h-1)/Nbins + 1/(2*Nbins), 'YData', (rounded_s-1)/Nbins + + 1/(2*Nbins));
xlabel('Hue')
ylabel('Saturation');
hold on

%% Visualize the S vs H plot
figure(66)
clf;
hold on;
for ith_point = 1:1000:length(all_h)
    rgb_color = hsv2rgb([all_h(ith_point) all_s(ith_point) 0.8]);
    plot(all_h(ith_point), all_s(ith_point), '.','Markersize',0.5,'Color',rgb_color);
end
xlabel('Hue')
ylabel('Sat')
title('Hue versus Saturation');



%% Try a manual method first (to see if it works)
indices_yellow_line = find((image_road_rescale(:,:,1)>0.1) & (image_road_rescale(:,:,1)<0.13) & (image_road_rescale(:,:,2)>0.35));

% Set entire image to zero
image_yellow_line = 0*image_road_rgb;

% Set the "found" values back to the original image
image_yellow_line(indices_yellow_line) = image_road_rgb(indices_yellow_line);

% Show the results
figure(67);
clf;
imshow(image_yellow_line);

%% Try a manual method first (to see if it works)
indices_white_line = find((image_road_rescale(:,:,1)>0.01) & (image_road_rescale(:,:,1)<0.2) & (image_road_rescale(:,:,2)>0.1));

% Set entire image to zero
image_white_line = 0*image_road_rgb;

% Set the "found" values back to the original image
image_white_line(indices_white_line) = image_road_rgb(indices_white_line);

% Show the results
figure(68);
clf;
imshow(image_white_line);

%% Try a manual method first (to see if it works)
indices_yellow_line = find((image_road_rescale(:,:,2)>0.35));

% Set entire image to zero
image_yellow_line = 0*image_road_rgb;

% Set the "found" values back to the original image
image_yellow_line(indices_yellow_line) = image_road_rgb(indices_yellow_line);

% Show the results
figure(69);
clf;
imshow(image_yellow_line);


%% Figure out where threshold should be in saturation
figure(661);
histogram(all_s,300);
xlabel('Saturation value');


%% Visualize the V vs H plot
figure(7)
plot(all_h, all_v, '.')
xlabel('Hue')
ylabel('Val')

% Visualize the V vs s plot
figure(8)
plot(all_s, all_v, '.')
xlabel('Sat')
ylabel('Val')


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