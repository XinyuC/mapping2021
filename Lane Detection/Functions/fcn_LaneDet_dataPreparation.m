function image_hsv_new = fcn_LaneDet_dataPreparation(input_image, varargin)
% fcn_LaneDet_dataPreparation
% Resize the input image to an appropriate size.
% Convert the RGB image to HSV image if necessary.
% Apply gamma correction to adjust brightness and contrast.
%
% FORMAT:
%
%      image_hsv_new = fcn_LaneDet_dataPreparation(input_image, varargin)
%
% INPUTS:
%
%      input_image: a N-by-M-by-3 array of RGB or HSV values.
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
% 
%
% OUTPUTS:
%
%      image_hsv_new: a N-by-M-by-3 array of HSV values.
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_yellowThresholding for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions

% This function was written on 2021_07_27 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%


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
% Check inputs
if flag_check_inputs == 1   
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    % Check the string input, make sure it is characters
    fcn_LaneDet_checkInputsToFunctions(input_image, 'input_image');
    
end

% Does user want to show the plots?
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
% The class of RGB image is Uint8, and the class of HSV image is double.

% If the class is double, input image is an HSV image, otherwise, 
% the image is an RGB image, the image need to be converted. 
if isa(input_image, 'double') % If the class is double,input image is an HSV image.
    image_hsv = input_image; % The input image can be used directly.
else
    image_hsv = rgb2hsv(input_image); % Convert the RGB image to HSV image.
end
v_value = image_hsv(:,:,3); % Grab the V values of the HSV image.
v_mean = mean(v_value, 'all');% Calculate the average V value.
% Apply gamma correction
gamma = v_mean/0.4; % Calculate the value of gamma
new_v = 1 * (v_value/1).^(gamma); % Encode gamma correction
image_hsv_new = image_hsv; % Define the output
image_hsv_new(:,:,3) = new_v; % Assign the transformed V values to image

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
    % Show the comparision between the original image and transformed image
    if image_class == 'double'
        image_rgb = hsv2rgb(image_hsv);
    else
        image_rgb = input_image;
    end
    image_rgb_new = hsv2rgb(image_hsv_new);
    figure(fig_num)
    imshowpair(image_rgb, image_rgb_new, 'montage')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % Ends main function   