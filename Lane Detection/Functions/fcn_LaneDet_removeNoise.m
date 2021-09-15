function clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv, varargin)
% fcn_LaneDet_removeNoise
% Remove unwanted noise according to requirements.
% FORMAT:
%
%      clean_hsv = fcn_LaneDet_removeNoise(image_hsv, varargin)
%
% INPUTS:
%
%      image_hsv: a N-by-M-by-3 array of HSV values.
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
% 
%
% OUTPUTS:
%
%      clean_hsv: a N-by-M-by-3 array of HSV values.
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_yellowThresholding for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions

% This function was written on 2021_07_28 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%
% Revision history:
%      2021_07_28:
%      -- first write of this code 
%      -- updated traversal type to allow above as type, added comments
%      2021_08_21:
%      -- modify the code, keep the dataset as the original size



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
    fcn_LaneDet_checkInputsToFunctions(image_hsv, 'image_hsv');
    
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
sz = size(image_hsv); % Grab the size of the image
Nrows = sz(1); % Extract the number of rows
Ncols = sz(2); % Extract the number of columns
Npages = sz(3);% Extract the number of pages
v_low = 0.4; % Set the cut off value for Value
s_low = 0.35; % Set the cut off value for Saturation
h_low = 0.08; % Set the lower cut off value for Hue
h_high = 0.16; % Set the higher cut off value for Hue
h_value = image_hsv(:,:,1); % Grab all Hue values
s_value = image_hsv(:,:,2); % Grab all Saturation values
v_value = image_hsv(:,:,3); % Grab all Value values
% mean_s = mean(s_value, 'all');
% mean_v = mean(v_value, 'all');
% disp([mean_s,mean_v]);
clean_image_hsv = image_hsv; % Create a copy of the HSV image;
for j = 1:Ncols;
%     clean_image_hsv(v_value(:,j)< v_low, j, :) = nan;
%     clean_image_hsv(s_value(:,j)< s_low, j, :) = nan;
    clean_image_hsv((h_value(:,j) >= h_high)|(h_value(:,j) <= h_low), j, :) = nan;
end

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
    Nbins = 100; % Set the number of bins
    xEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in x dimension
    yEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in y dimension
    clean_h = clean_image_hsv(:,1); % Grab the clean hue values
    clean_s = clean_image_hsv(:,2); % Grab the clean saturation values
    figure(fig_num)
    h = histogram2(clean_h, clean_s, xEdges, yEdges,...
     'DisplayStyle','tile','ShowEmptyBins','on'); % Create a bivariate histogram plot of H and S
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function    