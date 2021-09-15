%% Prepare the script
close all
clear all
clc

%%

folder_name = '..\Images\video\';
addpath(folder_name)

vidObj = VideoReader('cherryspring.mp4')
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
    image_hsv = fcn_LaneDet_dataPreparation(vidFrame_rgb);
% Call fcn_LaneDet_removeNoise
    clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv);
    figure(1)
    fig_h = fcn_LaneDet_view_density(clean_image_hsv);
%     yellow_mask = fcn_LaneDet_yellowThresholding(vidFrame_rgb); % Call fcn_LaneDet_yellowThresholding
% Show the mask
%     figure(1)
%     imshowpair(vidFrame_rgb, yellow_mask, 'montage')
%     imshowpair(vidFrame_rgb, fig_h, 'montage')
%     figure(2)
%     imshow(vidFrame_rgb)


end
toc
fprintf('end')
vidObj.CurrentTime
close all