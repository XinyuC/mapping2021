%% Prepare the script
close all
clear all
clc

%%

folder_name = '..\Images\video\';
addpath(folder_name)

vidObj = VideoReader('marker.mp4')
frame_num = vidObj.NumFrames;
duration = floor(vidObj.Duration);
pause_time = 1/vidObj.FrameRate;
pause_time = 0.05;

%%
vidObj.CurrentTime = 0;
clc
close all
tic
while vidObj.CurrentTime < duration
%     fprintf('%d second', vidObj.CurrentTime)
    vidFrame_rgb = readFrame(vidObj);
    vidFrame_hsv = rgb2hsv(vidFrame_rgb);
    sz = size(vidFrame_hsv); % size of the matrix
    Nrows = sz(1); % Number of rows of the matrix
    Ncols = sz(2); % Number of columns of the matrix
    Npages = sz(3); % Number of pages of the matrix
    all_hsv = reshape(vidFrame_hsv, Nrows*Ncols, Npages); % Reshape the N x M matrix to an NxM x 1 array
    all_h = all_hsv(:,1);
    all_s = all_hsv(:,2); % Grab the Saturation value
    all_v = all_hsv(:,3); % Grab the Value value
    s_low = 0.3;
    v_low = 0.3;
    h_low = 0.1;
    h_high = 0.15;
    
%     clean_hsv = all_hsv((all_s >= s_low)&(all_v >= v_low), :);% Remove values for saturation less than 0.15
    clean_hsv = all_hsv((all_s >= s_low)&(all_v >= v_low)&((all_h>=h_low)&(all_h<=h_high)), :);% Remove values for saturation less than 0.15
    clean_h = clean_hsv(:,1);
    clean_s = clean_hsv(:,2);
    Nbins = 100;
    xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
    yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
%     figure(1)
%     h = histogram2(all_h, all_s, xEdges, yEdges,...
%         'DisplayStyle','tile','ShowEmptyBins','on','visible','off'); % Create a bivariate histogram plot of H and S
    h = histogram2(clean_h, clean_s, xEdges, yEdges,...
        'visible','off'); % Create a bivariate histogram plot of H and S
%     xlabel('Hue')
%     ylabel('Saturation')
% %     ylabel('Value')
%     xticks(0:0.1:1)
%     yticks(0:0.1:1)
%     title('Number of points in each intervals')
    fig_h = gcf;
    fig_h.Visible = 'off'; % Set the visible off

    h_counts = h.Values;
    h_counts_T = h_counts.';
    counts = h_counts_T;
    max_counts = max(counts,[],'all');
    sum_counts = sum(counts, 'all');
    [r,c] = find(counts == max_counts);
    [X, Y] = meshgrid(linspace(0,1,Nbins));
    
    fig_2 = figure(2);
    nan_counts = counts;
    nan_counts(counts == 0) = nan;
    s1 = mesh(X,Y, nan_counts);
    hold on
    xlabel('Hue')
    ylabel('Saturation')
    zlabel('Counts')
    axis([0 1 0 1])
    
    
%     fig_C = figure(998)
%     [C,C_p] = contour(X,Y,counts,20); % Show the results on a mesh
%     Z = C_p.ZData;
%     hold on
%     plot(h_center(i-istart+1,1), s_center(i-istart+1,1), 'rx','markersize', 15,'linewidth',2)
%     max_label = sprintf('(%f, %f)',h_center(i-istart+1,1), s_center(i-istart+1,1));
%     text(h_center(i-istart+1,1)+0.05,s_center(i-istart+1,1), max_label)
%     legend('Contour','Peaks')
%     c_bar = colorbar;
%     c_bar.Label.String = 'Number of Points'
%     xlabel('Hue')
%     ylabel('Saturation');
%     xticks(0:0.1:1)
%     yticks(0:0.1:1)
%     title('Contour Plot at 11am')

end
toc
fprintf('end')
vidObj.CurrentTime
close all