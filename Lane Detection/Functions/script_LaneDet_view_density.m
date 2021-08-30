%% Prepare the script
close all
clear all
clc

%%

folder_name = '..\Images\test\';
addpath(folder_name)

%% Load all the images in the folder

image_location= '..\Images\test\*.jpg';
image_files = dir(image_location);
nfiles = length(image_files);

for n = 1:nfiles;
       current_image_name = image_files(n).name;
       current_image_folder = image_files(n).folder;
       current_image = imread(current_image_name);% Load the original image
       current_image_hsv = rgb2hsv(current_image);% Convert RGB colors to HSV
       images_names(n,1) = string(current_image_name);
       images_rgb{n} = current_image;
       images_hsv{n} = current_image_hsv;
end


%%
istart = 4;
iend = 4;

for i = istart:iend;
    image_rgb = images_rgb{i};
    image_hsv = images_hsv{i};
    image_v = image_hsv(:,:,3);


    show_hsv = image_hsv;
    show_hsv(:,:,2) = 0.4;
    show_rgb = hsv2rgb(show_hsv);

    sz = size(image_hsv); % size of the matrix
    Nrows = sz(1); % Number of rows of the matrix
    Ncols = sz(2); % Number of columns of the matrix
    Npages = sz(3); % Number of pages of the matrix
    all_hsv = reshape(image_hsv, Nrows*Ncols, Npages); % Reshape the N x M matrix to an NxM x 1 array
    all_s = all_hsv(:,2); % Grab the Saturation value
    all_v = all_hsv(:,3); % Grab the Value value
    
%     mean_v(i,1) = mean(remove_v);
    if mean_v(i,1) > 0.6
        min_s = 0.1;
    elseif mean_v(i,1) < 0.3
        min_s = 0.3;
    else
        min_s = 0.2;
    end
    all_h = all_hsv(:,1);
    filtered_hsv = all_hsv((all_v > 0.2)&(all_hsv(:,2) > min_s),:);
    mean_s = mean(filtered_hsv(:,2));
    



    v_low = min(0.3, mean_v(i,1));
   
    s_low = floor(10*mean_s)/10;
    s_low = 0.4;
    h_low = 0.1;
    h_high = 0.15;
    % Clean the data set
    clean_hsv = all_hsv((all_s >= s_low)&(all_v >= v_low)&((all_h>=h_low)&(all_h<=h_high)), :);% Remove values for saturation less than 0.15
    clean_h = clean_hsv(:,1);
    clean_s = clean_hsv(:,2);
    clean_v = clean_hsv(:,3);
    mean_clean_v(i,1) = mean(clean_v);
    Nbins = 100; % Set the number of bins
    binwidth = 1/Nbins;
    xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
    yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
    figure(1)
    h = histogram2(clean_h, clean_s, xEdges, yEdges,...
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
    

    [xTxt, yTxt] = ndgrid(h.XBinEdges(2:end)-h.BinWidth(1)/2, ...
        h.YBinEdges(2:end)-h.BinWidth(2)/2);
    labels = compose('%.0f', h.Values);
    % text(xTxt(:), yTxt(:), labels(:), 'VerticalAlignment', 'Middle', 'HorizontalAlignment','Center')
    grid on
    
    h_counts = h.Values;
    h_counts_T = h_counts.';
    counts = h_counts_T;
    max_counts = max(counts,[],'all');
    sum_counts = sum(counts, 'all');
    sum_number(i - istart+1,1) = sum_counts;
    max_number(i - istart+1,1) = max_counts;
    [r,c] = find(counts == max_counts);
    [X, Y] = meshgrid(linspace(0,1,Nbins));
    
    figure(2)
    clf;
    nan_counts = counts;
    nan_counts(counts == 0) = nan;
    s1 = mesh(X,Y, nan_counts)
    hold on

    xlabel('Hue')
    ylabel('Saturation')
    zlabel('Counts')
    axis([0 1 0 1])
    h_center(i-istart+1,1) = X(1,c);
%     v_center(i-istart+1,1) = Y(r);
    s_center(i-istart+1,1) = Y(r,1);
    fig_C = figure(998)
    clf;
    [C,C_p] = contour(X,Y,counts,20); % Show the results on a mesh
    Z = C_p.ZData;
    hold on
    plot(h_center(i-istart+1,1), s_center(i-istart+1,1), 'rx','markersize', 15,'linewidth',2)
    max_label = sprintf('(%f, %f)',h_center(i-istart+1,1), s_center(i-istart+1,1));
    text(h_center(i-istart+1,1)+0.05,s_center(i-istart+1,1), max_label)
    legend('Contour','Peaks')
    c_bar = colorbar;
    c_bar.Label.String = 'Number of Points'
    xlabel('Hue')
    ylabel('Saturation');
    xticks(0:0.1:1)
    yticks(0:0.1:1)
    title('Contour Plot at 11am')


    unique_hsv = unique(all_hsv, 'rows');
    % unique_hsv(:,3) = 0.8;
    plot_rgb = hsv2rgb(unique_hsv);% Convert HSV colors back to RGB
    
end

%%
data_array = [h_center(istart:iend), s_center(istart:iend), mean_v(istart:iend,1),mean_clean_v(istart:iend,1),max_number,images_names(istart:iend,1)];
% sorted_data = sortrows(data_array, 3,'descend');
sorted_data = sortrows(data_array, 3);
% sorted_data = data_array;
plot_data = double(sorted_data(1:end,1:5));


%%
figure(1245)
clf;
end_num = 18;
plotRGB = jet(18);
plotHSV = rgb2hsv(plotRGB);
plotHSV(:,3) = plot_data(:,3);
plotHSV(:,1) = 0;
plotHSV(:,2) = 0.8;
plotColor = plotRGB;
plot(plot_data(istart:end_num,1), plot_data(istart:end_num,2),'-o')
hold on
% colorbar
for i = istart:end_num;
%     peak_label = sprintf('At V_mean > %4.4f, N = %d',mean_v(i-istart+1,1), max_number(i-istart+1,1));
%     plot(double(sorted_data(i,1)), double(sorted_data(i,2)),'o')
    plot(plot_data(i,1), plot_data(i,2),'-o','color',plotColor(i,:),'markersize',6)
%     hold on
    
%     peak_label = sprintf('At V_{mean} > %4.4f',plot_data(i-istart+1,3));
    peak_label = sprintf('%d', i);
    legend_info{i,1} = sprintf('V_{mean} = %4.4f,V_{yellow-mean} = %4.4f, N = %d',plot_data(i-istart+1,3), plot_data(i-istart+1,4),plot_data(i-istart+1,5));
%     text(plot_data(i-istart+1,1),plot_data(i-istart+1,2), peak_label)
    
end
legend(legend_info)
% plot(plot_data(1,1), plot_data(1,2),'go')
small_label = sprintf('Lowest V_{mean} = %4.4f', plot_data(1,3));
text(plot_data(1,1)-0.072,plot_data(1,2), small_label,'color','green')
% plot(plot_data(end_num,1), plot_data(end_num,2),'ro')
large_label = sprintf('Highest V_{mean} = %4.4f', plot_data(end_num,3));
text(plot_data(end_num,1)+0.01,plot_data(end_num,2), large_label,'color','red')
xlabel('Hue')
ylabel('Saturation');
% ylabel('Huw');
axis([0 1 0 1])
xticks(0:0.05:1)
yticks(0:0.05:1)
title('Peaks moving trajectory under different light conditions')
% title('Saturation versus Mean Value')
% title('Hue versus Mean Value')
ylim=get(gca,'ylim');
xlim=get(gca,'xlim')
% variable_label = sprintf('V: Value\nN: Number of Points')
% text(xlim(2)-0.35,ylim(2)-0.1,variable_label,'FontSize', 12)
%%
Npoints = length(unique_hsv);
figure(10)
clf;
plot_rgb = hsv2rgb(unique_hsv);% Convert HSV colors back to RGB
for ipoint = 1:10:Npoints
%     plot3(unique_hsv(ipoint,1), unique_hsv(ipoint,2),unique_hsv(ipoint,3),'.', 'color',plot_rgb(ipoint,:))
    if unique_hsv(ipoint,3) < 0.3
        plot_rgb(ipoint,:) = [1 0 0];
    end
    plot(unique_hsv(ipoint,1), unique_hsv(ipoint,2),'.',...
        'color',plot_rgb(ipoint,:))% Plot each pixel with its original color
    hold on
    
    
end
xlabel('Hue')
ylabel('Saturation')
zlabel('Value')
legend('V < 0.3','FontSize',12)
axis([0 1 0 1])
%%
Xmesh = s1.XData;

%% Perform data density analysis
%{
% See: https://www.mathworks.com/matlabcentral/answers/225934-using-matlab-to-plot-density-contour-for-scatter-plot?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/478785-joint-histogram-2-d?s_tid=srchtitle
% See: https://www.mathworks.com/matlabcentral/answers/520819-need-help-with-surf-x-y-and-temperature?s_tid=srchtitle

Nbins = 10; % How many intervals H and S space will be divided into

% Push the s-values and h values 
rounded_h = round(Nbins*all_h)+1;
rounded_s = round(Nbins*all_v)+1;

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
%}
%% Functionalized scripts

%%
% image_hsv_015 = image_hsv;
% image_hsv_015(:,:,2) = 0.15*ones(Nrows,Ncols);
% image_rgb_015 = hsv2rgb(image_hsv_015);
% figure(11)
% imshow(image_rgb_015)

