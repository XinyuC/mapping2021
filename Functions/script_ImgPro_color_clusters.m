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
for i = 1:image_num
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
    
%     [idx, C] = kmeans(all_v(all_v(:,i) < 0.4,i),1);
%     centers(:,i) = C;
    
end


%%

%{
close all
k_s = 3;
for i = 1:image_num
    
    s_cluster_title = "Saturation Clustering"+' - ' + time_lst(i);
    all_hv = [all_h(:,i), all_v(:,i)];
%     [idx_v, C_v] =kmeans(all_v(:,i) ,k_v);
%     clust_v_idx = find(all_v(:,i)>0.2);
%     clust_v = all_v(clust_v_idx,i);
%     clust_h = all_h(clust_v_idx,i);
    clust_s = all_s(:,i);
    clust_h = all_h(:,i);
    
    [idx_s, C_s] =kmeans(clust_s ,k_s);
    figure(i)

    for idx =1: k_s
        y_label = sprintf('%4.3f', C_s(idx));
           
        yline(C_s(idx), '--k', y_label, 'LineWidth',2.4)
        hold on
       
%         plot(clust_h(idx_v==idx, i), clust_v(idx_v==idx, i), '.','Markersize',1.5)
        plot(clust_h(idx_s==idx), clust_s(idx_s==idx), '.','Markersize',1.5)
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
        xlabel('Hue')
        ylabel('Saturation')
        title(s_cluster_title)
    end
end
%}
%% Hue Cluster
%%{
close all
k_h = 3;
for i = 1:image_num
    
    h_cluster_title = "Hue Clustering"+' - ' + time_lst(i);
    all_hv = [all_h(:,i), all_v(:,i)];
%     [idx_v, C_v] =kmeans(all_v(:,i) ,k_v);
%     clust_v_idx = find(all_v(:,i)>0.2);
%     clust_v = all_v(clust_v_idx,i);
%     clust_h = all_h(clust_v_idx,i);
    clust_v = all_v(:,i);
    clust_h = all_h(:,i);
    h_centers(:,i) = C_h;
    [idx_h, C_h] =kmeans(clust_h ,k_h);
    figure(i)

    for idx =1: k_h
        x_label = sprintf('%4.3f', C_h(idx));
           
        xline(C_h(idx), '--k', x_label, 'LineWidth',2.4)
        hold on
       
%         plot(clust_h(idx_v==idx, i), clust_v(idx_v==idx, i), '.','Markersize',1.5)
        plot(clust_h(idx_h==idx), clust_v(idx_h==idx), '.','Markersize',1.5)
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
        xlabel('Hue')
        ylabel('Value')
        title(h_cluster_title)
    end
end

%}

%% Value cluster
%{
close all
k_v = 1;
for i = 1:image_num
    
    v_vluster_title = "Value Clustering"+' - ' + time_lst(i);
    all_hv = [all_h(:,i), all_v(:,i)];
    clust_v = all_v(:,i);
    clust_h = all_h(:,i);
    
    [idx_v, C_v] =kmeans(clust_v ,k_v);
    v_centers(:,i) = C_v;
    figure(i)
    for idx =1: k_v
         y_label = sprintf('%4.3f', C_v(idx));
           
        yline(C_v(idx), '--k', y_label, 'LineWidth',2.4)
%         plot(clust_h(idx_v==idx, i), clust_v(idx_v==idx, i), '.','Markersize',1.5)
        plot(clust_h(idx_v==idx), clust_v(idx_v==idx), '.','Markersize',1.5)
%     plot3(all_h(idx_s==idx, 1), all_s(idx_s==idx, 1),all_v(idx_s == idx,1), '.')
        xlabel('Hue')
        ylabel('Value')
        title(v_vluster_title)
    end
end
%}  
    



