function yellow_mask = fcn_LaneDet_yellowThresholding(image,varargin)
% fcn_LaneDet_yellowThresholding
% Perform yellow thresholding

% FORMAT:
%
%      yellow_hsv = fcn_LaneDet_yellowThresholding(image,varagin)
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
%      yellow_hsv：a NxM-by-3 array
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_yellowThresholding for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
%     fcn_LaneDet_dataPreparation
%     fcn_LaneDet_removeNoise
% 
%
% This function was written on 2021_06_27 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%
% Revision history:
%   2021_06_27:
%   -- wrote the code originally
%   2021_07_29:
%   -- delete the incoorect part, and rename the function
%   2021_08_22:
%   -- change the output of the function
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
% Call fcn_LaneDet_dataPreparation
image_hsv = fcn_LaneDet_dataPreparation(image);
% Call fcn_LaneDet_removeNoise
clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv);
h_low = 0.1;
h_high = 0.15;
yellow_mask = clean_image_hsv;
clean_h = clean_image_hsv(:,:,1);
sz = size(clean_h);
Ncols = sz(2); % Extract the number of columns
yellow_mask = (clean_h < h_high)&(clean_h > h_low);



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
    imshow(yellow_mask)
    title('Mask')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   


