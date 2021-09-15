%% Prepare the script
close all
clear all
clc

%% Add path and load the example image

folder_name = '..\Images\test\';
addpath(folder_name)
image_name = 'test09.jpg';
image_rgb = imread(image_name);


%%
image_hsv = rgb2hsv(image_rgb); % Convert RGB image to HSV image
sz = size(image_hsv); 
Nrows = sz(1); % Extract the number of rows
Ncols = sz(2); % Extract the number of columns
Npages = sz(3);% Extract the number of pages
% Reshape the image from N-by-M-by3 to NxM-by-3
all_hsv = reshape(image_hsv, Nrows*Ncols,Npages);
all_h = all_hsv(:,1); % Grab all Hue value
all_s = all_hsv(:,2); % Grab all Saturation value
all_v = all_hsv(:,3); % Grab all Value value
% Create a scatter plot to view all datapoints
figure(1)
plot(all_h,all_s,'.');
grid on
grid minor
axis equal
axis([0 1 0 1])
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)

% In image processing, low saturation and value values mean that the
% lighting is very poor, or the pixels are basically versions of grey or black.
% These won't have any color information that we typically need for lane
% detection. So we need to cut off those points whose s < 0.3, v < 0.3
v_cut_off = 0.3;
s_cut_off = 0.3;
clean_hsv = all_hsv((all_v > v_cut_off)&(all_s > s_cut_off),:);
clean_h = clean_hsv(:,1);
clean_s = clean_hsv(:,2);


% Create a scatter plot to view the remaining datapoints
figure(2)
plot(clean_h,clean_s,'.');
grid on
grid minor
axis equal
axis([0 1 0 1])
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)

% Plot density contour for the scatter plot of remaining datapoints
Nbins = 100; % Set the number of bins
binwidth = 1/Nbins; % Calculate the width of bins
xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
figure(3)
h = histogram2(clean_h, clean_s, xEdges, yEdges,...
    'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
colorbar
grid on 
grid minor
xlabel('Hue')
ylabel('Saturation')
xticks(0:0.1:1)
yticks(0:0.1:1)
title('Number of points in each intervals')

% Extract the counts matrix
h_counts = h.Values;
h_counts_T = h_counts.';
counts = h_counts_T;
max_counts = max(counts,[],'all'); % Calculate the maximum number of count
[r,c] = find(counts == max_counts); % Find the row and column index
[X, Y] = meshgrid(linspace(0,1,Nbins));

h_center = X(1,c); % Get the coordinate of Hue value
s_center  = Y(r,1); % Get the coordinate of Saturation value


nan_counts = counts; % Make a copy of count matrix
nan_counts(counts == 0) = nan; % Replace zeros with NaNs
% Show the results on a mesh to visualize the density centers of the
% dataset
figure(4)
clf;
s1 = mesh(X,Y, nan_counts)
hold on
xlabel('Hue')
ylabel('Saturation')
zlabel('Counts')
axis([0 1 0 1])
% Put the results in a scaled image. 
fig_C = figure(5)
clf;
[C,C_p] = contour(X,Y,counts,20); 
Z = C_p.ZData;
hold on
% Plot the point with highest density
plot(h_center, s_center, 'rx','markersize', 15,'linewidth',2)
max_label = sprintf('(%f, %f)',h_center, s_center);
text(h_center+0.05,s_center, max_label)
legend('Contour','Peaks')
c_bar = colorbar;
c_bar.Label.String = 'Number of Points'
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)
% title('Contour Plot at 11am')
