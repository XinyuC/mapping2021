function counts = fcn_LaneDet_view_density(clean_image_hsv, varargin)


sz = size(clean_image_hsv); % Grab the size of the image
Nrows = sz(1); % Extract the number of rows
Ncols = sz(2); % Extract the number of columns
Npages = sz(3);% Extract the number of pages
clean_hsv = reshape(clean_image_hsv, Nrows*Ncols, 3);
clean_h = clean_hsv(:,1);
clean_s = clean_hsv(:,2);
clean_v = clean_hsv(:,3);
Nbins = 100; % Set the number of bins
binwidth = 1/Nbins;
xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
figure(1)
h = histogram2(clean_h, clean_v, xEdges, yEdges,...
    'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
colorbar
fig_h = gcf;
%     fig_h.Visible = 'off'; % Set the visible off
xlabel('Hue')
ylabel('Saturation')
%     ylabel('Value')
xticks(0:0.1:1)
yticks(0:0.1:1)
title('Number of points in each intervals')
h_counts = h.Values;
h_counts_T = h_counts.';
counts = h_counts_T;
% % [r,c] = find(counts == max_counts);
% [X, Y] = meshgrid(linspace(0,1,Nbins));
% 
% figure(2)
% clf;
% nan_counts = counts;
% nan_counts(counts == 0) = nan;
% s1 = mesh(X,Y, nan_counts)
% hold on
% 
% xlabel('Hue')
% ylabel('Saturation')
% zlabel('Counts')
% axis([0 1 0 1])
