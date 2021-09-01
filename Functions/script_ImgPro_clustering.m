%% Clean the data
close all
clear all
clc

%% Load the colors image
%%{
colors_1= "colors_11am_sunny.jpg";

colors_2 = "colors_8pm_cloudy.jpg";
colors_3 = "colors_10pm_night.jpg";

image_lst = [colors_1, colors_2, colors_3];
% image_road_rgb = imread(image_1);
image_num = length(image_lst);
time_lst = ["11am Sunny","8pm Cloudy","10pm Night"];
%}
%% Load the markers image
%{
marker_1 =  "markers_11am_sunny.jpg";
marker_2 = "markers_8pm_cloudy.jpg";
marker_3 = "markers_10pm_night.jpg";
image_lst = [marker_1, marker_2, marker_3];
image_num  = length(image_lst);
time_lst = ["11am Sunny","8pm Cloudy", "10pm Night"];
%
%}
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
n = 3;
for i = n:n
    image_road_rgb = imread(image_lst(i));
    image_road_hsv = rgb2hsv(image_road_rgb);
    sz = size(image_road_hsv);
    Nrows = sz(1);
    Ncols = sz(2);
    Npages = sz(3);
    all_hsv(:,:,i) = reshape(image_road_hsv, Nrows*Ncols, Npages);
    
    all_h(:,i) = all_hsv(:,1,i);
    all_s(:,i) = all_hsv(:,2,i);
    all_v(:,i) = all_hsv(:,3,i);
    
end

%%
% close all
step = 10;
for i =n:n
    
    hs_title = "Polar Coordinate View"+' - ' + time_lst(i);
    unique_hsv = unique(all_hsv(:,:,i), 'rows');
    plot_hsv = [unique_hsv(:,1), unique_hsv(:,2), 0.8*ones( length(unique_hsv(:,1)),1)];
  
    rgb_color = hsv2rgb(plot_hsv);
    fig_h(i) = figure(i);
    
    for ith_point = 1:step:length(unique_hsv(:,1))
%     rgb_color = hsv2rgb([all_h(ith_point) all_s(ith_point) 0.8]);
        polarplot(2*pi*unique_hsv(ith_point,1), unique_hsv(ith_point,2), '.','Markersize',1,'Color',rgb_color(ith_point,:))
    
    
%         plot(unique_hsv(ith_point,1), unique_hsv(ith_point,2), '.','Markersize',1,'Color',rgb_color(ith_point,:));
        hold on
        
    end
%     xlabel('Hue')
%     ylabel('Sat')
    title(hs_title)
%     fig_h(i).CurrentAxes.Color = [0 0 0];
%     fig_h(i).InvertHardcopy = 'off';
%     saveas(fig_h(i), sprintf('marker_hs_fig%d.png', i))
    
%     plot(all_h(:,i), all_s(:,j),'.')
%     hold on
%  
end

%% Convert

polar_h = 2*pi*all_h(:,n);
polar_s =  all_s(:,n);
% [x, y] = pol2cart()
x = all_s(:,n).*cos(polar_h);
y = all_s(:,n).*sin(polar_h); 
all_data = [x,y];


%%

k = 5;
[idx, C] =kmeans(all_data ,k);
figure(2)
for i_clust =1: k       

        polarplot(polar_h(idx == i_clust), polar_s(idx == i_clust),'.', 'Markersize', 1.5)
        hold on
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
%         xlabel('x')
%         ylabel('y')
        str = sprintf('Top View with %d Clusters', k);
        title(str)
end


%%
polar_yellow = 1/3*pi;

[theta, rho] = cart2pol(C(:,1), C(:,2));

[minValue,minIndex] = min(abs(theta - polar_yellow));

main_cluster = all_hsv(idx == minIndex,:,n);

min_h = min(main_cluster(:,1));
max_h = max(main_cluster(:,1));
min_s = min(main_cluster(:,2));
max_s = max(main_cluster(:,2));
hueMask = (image_road_hsv(:,:,1) < max_h)&(image_road_hsv(:,:,1) > min_h);

satMask = (image_road_hsv(:,:,2) < max_s)&(image_road_hsv(:,:,2) > min_s);
figure(3)
imshow(image_road_hsv)
figure(4)
imshow(hueMask)

figure(5)
imshow(satMask)

hsMask = hueMask&satMask;
figure(6)
imshow(hsMask)