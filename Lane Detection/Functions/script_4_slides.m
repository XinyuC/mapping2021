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
       current_image = imread(current_image_name);
       current_image_hsv = rgb2hsv(current_image);
       images_names{n} = current_image_name;
       images_rgb{n} = current_image;
       images_hsv{n} = current_image_hsv;
end


%%
istart = 4;
iend = 4;
% image_ref = images_rgb{5};
% image_rgb = images_rgb{4};
% J = imhistmatch(image_rgb, image_ref);
% 
% figure(12)
% imshowpair(image_rgb, J, 'montage')

for i = istart:iend;
    image_rgb = images_rgb{i};
    image_hsv = images_hsv{i};
%     image_hsv = rgb2hsv(J);
%     figure(1234)
%     imshow(J)
%     image_v = image_hsv(:,:,3);

    
% end

    show_hsv = image_hsv;
    show_hsv(:,:,2) = 0.4;
    show_rgb = hsv2rgb(show_hsv);
%     figure(1024)
%     imshow(show_rgb)
    
%     class(image_rgb)
    class(image_hsv)
    sz = size(image_hsv); % size of the matrix
    
    v_value = image_hsv(:,:,3);
    s_value = image_hsv(:,:,2);
%     figure(2)
%     imshow(v_value)

    Nrows = sz(1); % Number of rows of the matrix
    Ncols = sz(2); % Number of columns of the matrix
    Npages = sz(3); % Number of pages of the matrix
%     new_v = histeq(v_value);

    
    v_mean = mean(v_value, 'all');
    gamma = v_mean/0.4;
    new_v = 1 * (v_value/1).^(gamma); 
    v_std = std(v_value, 1, 'all');
%     new_v = (v_value - v_mean)/v_std;
%     new_v = imadjust(v_value, [],[], gamma);
    rescale_v = rescale(new_v);
    
%     for j = 1:Ncols;
%         [B,TF(:,j)] = rmoutliers(image_v(:,j));
% %         new_v(new_v(:,j)<0, j) = 0;
% %         new_v(new_v(:,j)>1, j) = 1;
%     end
    
  
    new_hsv = image_hsv;
    new_hsv(:,:,3) = new_v;
%     new_hsv(:,:,3) = rescale_v;
%     figure(3)
%     imshow(new_hsv)
    new_rgb = hsv2rgb(new_hsv);
    
    figure(44)
    imshowpair(image_rgb, new_rgb, 'montage')
    new_v_mean = mean(new_hsv(:,:,3), 'all');
    
    all_hsv = reshape(image_hsv, Nrows*Ncols, Npages); % Reshape the N x M matrix to an NxM x 1 array
  
    all_v = all_hsv(:,3); % Grab the Value value
  
%     if mean_v(i,1) > 0.6
%         min_s = 0.1;
%     elseif mean_v(i,1) < 0.3
%         min_s = 0.3;
%     else
%         min_s = 0.3;
%     end
%     
%     all_hs_v = all_hsv;
%     all_s = all_hs_v(:,2);
%     mean_s = mean(all_s);
%     mode_s = mode(all_s);
%     
% %     
%     v_low = new_v_mean;
%     s_low = 0.3;
%     h_low = 0.1;
%     h_high = 0.15;
%     image_hsv_v = image_hsv;
%     for j = 1:Ncols;
%         image_hsv_v(v_value(:,j)<v_low, j,:) = 0;    
%     end
%     
%     image_hsv_s = image_hsv_v;
%     s_value = image_hsv_s(:,:,2);
% %     s_low = mean(s_value_0,'all');
% %     s_low = floor(10*mean_s)/10;
%     s_low = 0.3;
%     for j = 1:Ncols;
%         image_hsv_s(s_value(:,j)<s_low, j,:) = nan;    
%     end
%     image_hsv_h = image_hsv_s;
%     h_value = image_hsv_h(:,:,1);
%     for j = 1:Ncols;
%         image_hsv_h(((h_value(:,j)<h_low)|(h_value(:,j)>h_high)), j,:) = nan;    
%     end
%     fig_1 = figure(1)
%     imshow(image_hsv)
% %     ah = axes('Position',[0 0 1 1])
%     fig_2 = figure(2)
%     imshow(image_hsv_v)
%     fig_3 = figure(3)
%     imshow(image_hsv_s)
%     figure(4)
%     imshow(image_hsv_h)
%     
%     clean_rgb = hsv2rgb(image_hsv_h);
%     figure(5)
%     imshow(clean_rgb)
%  
    
end
%%
s_low = 0.4;
% v_low = new_v_mean;
v_low = 0.4;
h_low = 0.1;
h_high = 0.15;
all_hsv = reshape(image_hsv, Nrows*Ncols, Npages); % Reshape the N x M matrix to an NxM x 1 array
new_all_hsv = reshape(new_hsv, Nrows*Ncols, Npages);
clean_hsv = all_hsv((all_hsv(:,2) >= s_low)&(all_hsv(:,3) >= v_low)&((all_hsv(:,1)>=h_low)&(all_hsv(:,1)<=h_high)), :);% Remove values for saturation less than 0.15

new_clean_hsv = new_all_hsv((new_all_hsv(:,2) >= s_low)&(new_all_hsv(:,3) >= v_low)&((new_all_hsv(:,1)>=h_low)&(new_all_hsv(:,1)<=h_high)), :);% Remove values for saturation less than 0.15
Nbins = 100; % Set the number of bins
binwidth = 1/Nbins;
xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
figure(10)
h1 = histogram2(clean_hsv(:,1), clean_hsv(:,2), xEdges, yEdges,...
     'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
%     h = histogram2(all_h, all_s, xEdges, yEdges,...
%         'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
colorbar

xlabel('Hue')
ylabel('Saturation')
xticks(0:0.1:1)
yticks(0:0.1:1)
title('Number of points in each intervals')

figure(11)
h2= histogram2(new_clean_hsv(:,1), new_clean_hsv(:,2), xEdges, yEdges,...
     'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
%     h = histogram2(all_h, all_s, xEdges, yEdges,...
%         'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
colorbar

xlabel('Hue')
ylabel('Saturation')
xticks(0:0.1:1)
yticks(0:0.1:1)
title('Number of points in each intervals')
%%
[X, Y] = meshgrid(linspace(0,1,Nbins));
h_counts = h1.Values;
h_counts_T = h_counts.';
counts = h_counts_T;
max_counts = max(counts,[],'all');
[r,c] = find(counts == max_counts);
h_center  = X(1,c);
s_center = Y(r,1);
h2_counts = h2.Values;
h2_counts_T = h2_counts.';
new_counts = h2_counts_T;
new_max_counts = max(new_counts,[],'all');
[new_r,new_c] = find(new_counts == new_max_counts);
new_h_center  = X(1,new_c);
new_s_center = Y(new_r,1);

% %%
fig_C = figure(998)
clf;
[C,C_p] = contour(X,Y,counts,20); % Show the results on a mesh
Z = C_p.ZData;
hold on
plot(h_center, s_center, 'rx','markersize', 15,'linewidth',2)
max_label = sprintf('(%f, %f)',h_center(i-istart+1,1), s_center(i-istart+1,1));
text(h_center+0.05,s_center, max_label)
legend('Contour','Peaks')
c_bar = colorbar;
c_bar.Label.String = 'Number of Points'
% title('Before brightness transformation')
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)


new_fig_C = figure(999)
clf;
[new_C,new_C_p] = contour(X,Y,new_counts,20); % Show the results on a mesh
Z = new_C_p.ZData;
hold on
plot(new_h_center, new_s_center, 'rx','markersize', 15,'linewidth',2)
max_label = sprintf('(%f, %f)',new_h_center(i-istart+1,1), new_s_center(i-istart+1,1));
text(new_h_center+0.05,new_s_center, max_label)
legend('Contour','Peaks')
c_bar = colorbar;
c_bar.Label.String = 'Number of Points'
xlabel('Hue')
ylabel('Saturation');
xticks(0:0.1:1)
yticks(0:0.1:1)
% title('After brightness transformation')
%%

h_counts = h1.Values;
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