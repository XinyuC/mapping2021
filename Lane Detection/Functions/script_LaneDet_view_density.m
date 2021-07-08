%% Prepare the script
close all
clear all
clc

%%
=
folder_name = '..\Images\test\';
addpath(folder_name)

%% Load all the images in the folder
% image_location = 'F:\Lecture\Summer2021\mapping2021\images\*.jpg';
% image_location = '..\downloads\*.jpg';
image_location= '..\Images\test\*.jpg';
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

i = 1;
image_rgb = images_rgb{i};
image_hsv = images_hsv{i};
image_resize = imresize(image_hsv, 0.1);
h_page = image_hsv(:,:,1);
s_page = image_hsv(:,:,2);
v_page = image_hsv(:,:,3);
image_rescale = image_hsv;
image_rescale(:,:,1) = rescale(h_page);

sz = size(image_hsv);
Nrows = sz(1);
Ncols = sz(2);
Npages = sz(3);
all_hsv = reshape(image_hsv, Nrows*Ncols, Npages);
all_h = all_hsv(:,1);
all_s = all_hsv(:,2);

all_v = all_hsv(:,3);
all_hs = all_hsv(:,1:2);


%% Perform data density analysis
% See: https://www.mathworks.com/matlabcentral/answers/225934-using-matlab-to-plot-density-contour-for-scatter-plot?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/478785-joint-histogram-2-d?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/520819-need-help-with-surf-x-y-and-temperature?s_tid=srchtitle

Nbins = 100; % How many intervals H and S space will be divided into

% Push the s-values and h values 
rounded_h = round(Nbins*all_h)+1;
rounded_s = round(Nbins*all_s)+1;

% Create an accumulation array, show in mesh
counts = accumarray([rounded_s,rounded_h], 1,[],[]);  %remember Y corresponds to rows

% Next, shut off values for saturation less than 0.15, which are values of 15 or
% less (since we multiply by 100). Low saturation values mean that the
% lighting is very poor, or the pixels are basically versions of grey.
% These won't have any color information that we typically need for lane
% detection.
counts(1:2,:) = 0; 
figure(999); 
clf
mesh(counts); % Show the results on a mesh
max_c = imregionalmax(counts);
xlabel('Hue')
ylabel('Saturation');
[r,c] = find(max_c);
hold on
x_plot = linspace(0,10,11);
y_plot = x_plot;
i = 4;
plot3(x_plot(c(i)), y_plot(r(i)), counts(r(i),c(i)),'rx')

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
%% Functionalized scripts
%{
filtered_hs = all_hs(all_s >= 0.15, :);
filtered_h = filtered_hs(:,1);
filtered_s = filtered_hs(:,2);
[routliers_s, TF_s] = rmoutliers(filtered_s); % Remove outliers in Saturation data
% clean_hs = filtered_hs((~TF_s), :); % Grab the clean data
clean_hs = filtered_hs;

%%
image_hsv_015 = image_hsv;
image_hsv_015(:,:,2) = 0.15*ones(Nrows,Ncols);
image_rgb_015 = hsv2rgb(image_hsv_015);
figure(11)
imshow(image_rgb_015)

%%
Nbins = 20;
xEdges = linspace(-1,1,Nbins + 1);
yEdges = linspace(-1,1,Nbins + 1);

hEdges = linspace(0,1,Nbins + 1);
sEdges = linspace(0,1,Nbins + 1);


clf
figure(1)
% h = histogram2(all_h, all_s, hEdges, sEdges,...
%     'DisplayStyle','tile','ShowEmptyBins','on')
h = histogram2(clean_hs(:,1), clean_hs(:,2), hEdges, sEdges,...
    'DisplayStyle','tile','ShowEmptyBins','on')
% fig = gcf
% fig.Visible = 'off'
xlabel('Hue')
ylabel('Saturation')
title('Number of points in each intervals')

[xTxt, yTxt] = ndgrid(h.XBinEdges(2:end)-h.BinWidth(1)/2, ...
    h.YBinEdges(2:end)-h.BinWidth(2)/2);
labels = compose('%.0f', h.Values);
text(xTxt(:), yTxt(:), labels(:), 'VerticalAlignment', 'Middle', 'HorizontalAlignment','Center')
grid on


%%
h_counts = h.Values;
h_counts_T = h_counts.';
counts = h_counts_T;
s_cut = 0.15;
s_cut_idx = round(s_cut/(1/Nbins));
counts_cut = counts;
counts_cut(1:s_cut_idx,:) = 0;

%%
nonzero_counts = nonzeros(counts);
mean_count = mean(nonzero_counts);
counts_final = counts_cut;
counts_final(counts_final < mean_count) = 0;
cut_counts = imregionalmax(counts_cut);
[r_cut, c_cut] = find(cut_counts);
k_cut = length(r_cut);
peak_counts = imregionalmax(counts_final);
[r,c] = find(peak_counts);
k = length(r);


[X, Y] = meshgrid(linspace(0,1,Nbins));
figure(2)
clf
s1 = mesh(X,Y, counts_cut)
hold on
for idx = 1:k_cut;
    plot3(s1.XData(1,c_cut(idx)), s1.YData(r_cut(idx),1), ...
        counts_cut(r_cut(idx),c_cut(idx)),'rx','markersize',10,'linewidth', 2)
end
xlabel('Hue')
ylabel('Saturation');
zlabel('Counts')

title(sprintf('Number of clusters is %d',k_cut))
% 
figure(3)
clf
s2 = mesh(X,Y,counts_final)
hold on
for idx = 1:k;
    plot3(s2.XData(1,c(idx)), s2.YData(r(idx),1), ...
        counts_final(r(idx),c(idx)),'rx','markersize',10,'linewidth', 2)
end
xlabel('Hue')
ylabel('Saturation');
zlabel('Counts')
title(sprintf('Number of clusters is %d',k))
%%

data = [filtered_h, filtered_s];

%%
[idx, C] =kmeans(data,k);
%%
figure(4)
clf
for i_clust =1: k       


        plot(filtered_h(idx == i_clust), filtered_s(idx == i_clust),'.', 'Markersize', 1.5)
        hold on
        str = sprintf('Top View with %d Clusters', k);
        title(str)
end

C_ref = [0.11, 0.5];
dist = vecnorm(C  - C_ref,2,2);
[minDist,markerIndex] = min(dist);
%%
main_cluster = filtered_hs(idx == markerIndex,:);

main_h = main_cluster(:,1);
main_s = main_cluster(:,2);
[main_h_routliers, main_TF_h] = rmoutliers(main_h);
[main_s_routliers, main_TF_s] = rmoutliers(main_s);
marker_cluster =main_cluster((~main_TF_h)&(~main_TF_s),:);
figure(5)
plot(main_cluster(:,1),main_cluster(:,2), '.', 'Markersize', 1.5)
xlim([0 1]);
ylim([0 1]);
title('Marker Cluster')
figure(6)
plot(marker_cluster(:,1),marker_cluster(:,2), '.', 'Markersize', 1.5)
title('Marker Cluster Without Outliers')
xlim([0 1]);
ylim([0 1]);
min_h = min(marker_cluster(:,1));
max_h = max(marker_cluster(:,1));
min_s = min(marker_cluster(:,2));
max_s = max(marker_cluster(:,2));

%%
hueMask = (image_hsv(:,:,1) < max_h)&(image_hsv(:,:,1) > min_h);
figure(7)
imshow(hueMask)
title('Hue Mask')

%%

satMask = (image_hsv(:,:,2) > min_s);
figure(8)
imshow(satMask)
title('Saturation Mask')
%%
hsMask = hueMask&satMask;
figure(9)
imshow(hsMask)
title('Hue&Saturation Mask')

%%

se = strel('disk',5);
clean_image = imopen(hsMask, se);
figure(22)
imshow(clean_image)
%}
