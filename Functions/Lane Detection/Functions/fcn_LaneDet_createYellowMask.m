function [hueMask, satMask, hsMask] = fcn_LaneDet_createYellowMask(image,varargin)
% fcn_LaneDet_createYellowMask
% Convert the red, green, and blue values of an RGB image to 
% hue, saturation, and value (HSV) values of an HSV image
% Contruct a mask for the yello line marker, then perform dilations and
% erosions to remove any small blobs left in the mask

% FORMAT:
%
%      [hueMask, satMask, hsMask] = fcn_LaneDet_createYellowMask(image,varagin)
%
% INPUTS:
%
%      image: a N-by-M-by-3 array of red, green and blue values.
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
%
% OUTPUTS:
%
%      hueMask: a N-by-M binary matrix 
%
%      satMask: a N-by-M binary matrix
%
%      hsMask: a N-by-M binary matrix
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_CreatMask for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
%     fcn_LaneDet_ImagePreprocessing
%     fcn_LaneDet_determineNumberOfClusters
%     fcn_LaneDet_HSClustering
%
% This function was written on 2021_06_27 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%
% TODO:
%   V values also need to be cleaned in the future

flag_do_debug = 0; % Flag to debug the results
flag_do_plots = 0; % Flag to plot the results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end
%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_|                  
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1   
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    fcn_LaneDet_checkInputsToFunctions(image, 'image_rgb');
    
end

if 2 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_do_plots = 1;
else
    if flag_do_debug
        fig = figure; 
        fig_num = fig.Number;
        flag_do_plots = 1;
    end
end


%% Start of main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert 
image_hsv = rgb2hsv(image);
% Call fcn_LaneDet_ImagePreprocessing
[all_hsv, clean_hs] = fcn_LaneDet_ImagePreprocessing(image_hsv);
k  = fcn_LaneDet_determineNumberOfClusters(all_hsv);
clean_marker_cluster = fcn_LaneDet_HSClustering(clean_hs,k);
min_h = min(clean_marker_cluster(:,1));
max_h = max(clean_marker_cluster(:,1));
min_s = min(clean_marker_cluster(:,2));
max_s = max(clean_marker_cluster(:,2));
hueMask = (image_hsv(:,:,1) < max_h)&(image_hsv(:,:,1) > min_h); % Create Hue Mask
satMask = (image_hsv(:,:,2) > min_s); % Creat Saturation Mask
hsMask = hueMask&satMask; % Combine two masks

%% Any debugging?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _                 
%  |  __ \     | |                
%  | |  | | ___| |__  _   _  __ _ 
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_do_plots
    figure(fig_num)
    imshow(hueMask)
    title('Hue Mask')

    figure(fig_num + 1)
    imshow(satMask)
    title('Saturation Mask')

    figure(fig_num + 2)
    imshow(hsMask)
    title('Hue&Saturation Mask')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   


