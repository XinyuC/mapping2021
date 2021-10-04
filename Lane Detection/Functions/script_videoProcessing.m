%{
This script is used to show the result of a video test. For the test video,
the function works good most of the time, but when the detection area is
covered by a shadow, the function is hardly to detect the lane marker.
Different contrast enhancement techniques were tested, but it seems like
they only add more noises to the video/image. The next step is solve the
'shadow' problem.
%}

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
% pause_time = 1/vidObj.FrameRate;
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

    yellow_mask = fcn_LaneDet_yellowThresholding(vidFrame_rgb); % Call fcn_LaneDet_yellowThresholding
% Show the mask
    figure(1)
    imshowpair(vidFrame_rgb, yellow_mask, 'montage')
end
toc
fprintf('end')
vidObj.CurrentTime
close all