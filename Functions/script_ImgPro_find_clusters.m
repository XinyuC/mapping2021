%% Clean the data
close all
clear all
clc

%% Load the colors image
%{
colors_1= "colors_11am_sunny.jpg";
colors_2 = "colors_6pm_sunny.jpg";
colors_3 = "colors_8pm_cloudy.jpg";
colors_4 = "colors_9pm_sunset.jpg";
colors_5 = "colors_10pm_night.jpg";

image_lst = [colors_1, colors_2, colors_3, colors_4, colors_5];
% image_road_rgb = imread(image_1);
image_num = length(image_lst);
time_lst = ["11am Sunny","6pm Sunny","8pm Cloudy","9pm Sunset","10pm Night"];
%}
%% Load the markers image
% %{
marker_1 =  "markers_11am_sunny.jpg";
marker_2 = "markers_8pm_cloudy.jpg";
marker_3 = "markers_10pm_night.jpg";
image_lst = [marker_1, marker_2, marker_3];
image_num  = length(image_lst);
time_lst = ["11am Sunny","8pm Cloudy", "10pm Night"];
%
% %}
%%
%{
road_1 = "roads_11am_sunny.jpg";
road_2 = "roads_1pm_cloudy.jpg";
road_3 = "roads_2pm_sunny.jpg";
road_4 = "roads_6pm_sunny.jpg";
road_5 = "roads_8pm_sunny.jpg";
road_6 = "roads_10pm_little_lights.jpg";
road_7 = "roads_10pm_no_lights.jpg";
image_lst = [road_1,road_2, road_3, road_4, road_5, road_6, road_7];
image_num  = length(image_lst);
time_lst = ["11am Sunny","1pm Cloudy","2pm Sunny","6pm Sunny","8pm Sunny","10pm little lights","10pm no lights"];
%}
%%
for i = 1:image_num
    image_road_rgb = imread(image_lst(i));
    image_road_hsv = rgb2hsv(image_road_rgb);
    sz = size(image_road_hsv);
    Nrows = sz(1);
    Ncols = sz(2);
    Npages = sz(3);
    all_hsv(:,:,i) = reshape(image_road_hsv, Nrows*Ncols, Npages);
    
%     all_h(:,i) = all_hsv(:,1,i);
%     all_s(:,i) = all_hsv(:,2,i);
%     all_v(:,i) = all_hsv(:,3,i);
    
end

%%
close all
step = 10;
for i =1:image_num
    
    hs_title = "Hue versus Saturation"+' - ' + time_lst(i);
    unique_hsv = unique(all_hsv(:,:,i), 'rows');
    plot_hsv = [unique_hsv(:,1), unique_hsv(:,2), 0.8*ones( length(unique_hsv(:,1)),1)];
    rgb_color = hsv2rgb(plot_hsv);
    fig_h(i) = figure(i);
    
    for ith_point = 1:step:length(unique_hsv(:,1))
%     rgb_color = hsv2rgb([all_h(ith_point) all_s(ith_point) 0.8]);
    
        plot(unique_hsv(ith_point,1), unique_hsv(ith_point,2), '.','Markersize',1,'Color',rgb_color(ith_point,:));
        hold on
        
    end
    xlabel('Hue')
    ylabel('Sat')
    title(hs_title)
    fig_h(i).CurrentAxes.Color = [0 0 0];
    fig_h(i).InvertHardcopy = 'off';
    saveas(fig_h(i), sprintf('marker_hs_fig%d.png', i))
    
%     plot(all_h(:,i), all_s(:,j),'.')
%     hold on
%  
end
    
%%
for i = 1:image_num
    
    hv_title = "Hue versus Value"+' - ' + time_lst(i);
    unique_hsv = unique(all_hsv(:,:,i), 'rows');
    plot_hsv = [unique_hsv(:,1), unique_hsv(:,2), 0.8*ones( length(unique_hsv(:,1)),1)];
    rgb_color = hsv2rgb(plot_hsv);
    fig_h(i+image_num) = figure(i+image_num);
    
    for ith_point = 1:step:length(unique_hsv(:,1))
%     rgb_color = hsv2rgb([all_h(ith_point) all_s(ith_point) 0.8]);
    
        plot(unique_hsv(ith_point,1), unique_hsv(ith_point,3), '.','Markersize',1,'Color',rgb_color(ith_point,:));
        hold on
        
    end
    xlabel('Hue')
    ylabel('Val')
    title(hv_title)
    fig_h(i+ image_num).CurrentAxes.Color = [0 0 0];
    fig_h(i+ image_num).InvertHardcopy = 'off';
%     set(fig_h(i + image_num).CurrentAxes.Color, )
    saveas(fig_h(i + image_num), sprintf('marker_hv_fig%d.png', i))
end


% %% Convert the RGB to HSV
% 
% image_road_hsv = rgb2hsv(image_road_rgb);
% 
% % Scale the HSV data to the interval [0, 1]
% image_road_rescale = image_road_hsv;
% image_road_rescale(:,:,1) = rescale( image_road_hsv(:,:,1));
% image_road_rescale(:,:,2) = rescale( image_road_hsv(:,:,2));
% image_road_rescale(:,:,3) = rescale( image_road_hsv(:,:,3));
% rescaled_h = image_road_rescale(:,:,1);
% rescaled_s = image_road_rescale(:,:,2);
% rescaled_v = image_road_rescale(:,:,3);
% 
% % Reshape the N x M matrix to an NxM x 1 array
% sz = size(image_road_rescale);
% Nrows = sz(1);
% Ncols = sz(2);
% Npages = sz(3);
% all_hsv = reshape(image_road_rescale, Nrows*Ncols, Npages);
% all_h = all_hsv(:,1);
% all_s = all_hsv(:,2);
% all_v = all_hsv(:,3);
% all_hs = [all_h, all_s];


