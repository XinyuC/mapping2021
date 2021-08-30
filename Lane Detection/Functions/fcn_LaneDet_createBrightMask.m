function brightMask = fcn_LaneDet_createBrightMask(image,varargin)
% fcn_LaneDet_createWhiteMask
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
[all_hsv, clean_hsv] = fcn_LaneDet_ImagePreprocessing(image_hsv);
clean_v = clean_hsv(:,3);
all_h = all_hsv(:,1);
all_v = all_hsv(:,3);
k  = fcn_LaneDet_determineNumberOfClusters(all_h, all_v);
bright_cluster = fcn_LaneDet_VClustering(clean_v,k);
mean_v = mean(bright_cluster);
valMask = (image_hsv(:,:,3) > mean_v); % Creat Value Mask
se = strel('disk',5);
brightMask = imopen(valMask, se);

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
    imshow(valMask)
    title('Hue Mask')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   


