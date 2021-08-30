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
% Call fcn_LaneDet_yellowThresholding
yellow_hsv= fcn_LaneDet_yellowThresholding(image_rgb);
yellow_h = yellow_hsv(:,1);
yellow_s = yellow_hsv(:,2);
Nbins = 100; % Set the number of bins
binwidth = 1/Nbins;
xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
figure(1)
h = histogram2(yellow_h, yellow_s, xEdges, yEdges,...
        'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
colorbar
title('Histogram Plot')
h_counts = h.Values;
h_counts_T = h_counts.';
counts = h_counts_T; % Grab the counts matrix for HS space
max_counts = max(counts,[],'all'); % Calculate the peak value in the matrix
[r,c] = find(counts == max_counts); % Find the row and column of the peak value
[X, Y] = meshgrid(linspace(0,1,Nbins)); % 2-D grid
    
figure(2)
clf;
% Replace 0 with nan
nan_counts = counts;
nan_counts(counts == 0) = nan;
% Create mesh plot
s1 = mesh(X,Y, nan_counts)
hold on
xlabel('Hue')
ylabel('Saturation')
zlabel('Counts')
axis([0 1 0 1])
title('Mesh Plot')
h_center(i,1) = X(1,c);
s_center(i,1) = Y(r,1);
% Create contour plot
fig_C = figure(3)
clf;
[C,C_p] = contour(X,Y,counts,20); 
Z = C_p.ZData;
hold on
plot(h_center(i,1), s_center(i,1), 'rx','markersize', 15,'linewidth',2)
max_label = sprintf('(%f, %f)',h_center(i,1), s_center(i,1));
text(h_center(i,1)+0.05,s_center(i,1), max_label)
legend('Contour','Peaks')
c_bar = colorbar;
c_bar.Label.String = 'Number of Points'
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)
title('Contour Plot')
