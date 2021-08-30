function clean_mask = fcn_LaneDet_ErodeAndDilate(mask,varargin)
% fcn_LaneDet_ErodeAndDilate
% Erode and dilate the image
%
% FORMAT:
%
%      clean_mask = fcn_LaneDet_ErodeAndDilate(mask,varargin)
%
% INPUTS:
%
%      mask: a N-by-M array of binary_image values.
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
% 
%
% OUTPUTS:
%
%      clean_mask: a N-by-M array of binary_image values.
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_yellowThresholding for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
% 
% This function was written on 2021_08_22 by Xinyu Cao
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

if flag_check_inputs == 1   
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    fcn_LaneDet_checkInputsToFunctions(mask, 'binary_image');
    
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
% Create a cubic structuring element.
se = strel('disk',5);
% Erode the image
eroded_mask = imerode(mask, se);
% Dilate the image
clean_mask = imdilate(eroded_mask, se);

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
    imshow(eroded_mask)
    title('Eroded Mask')
    
    figure(fig_num + 1)
    imshow(clean_mask)
    title('Clean Mask')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   

