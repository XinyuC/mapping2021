function [all_hsv, clean_hs] = fcn_LaneDet_ImagePreprocessing(image_hsv, varargin)

% fcn_LaneDet_ImagePreprocessing
% Reshape the 3-D HSV matrix to a 2-D array for further processing.
% Remove outliers and noise in the data set.
%
% FORMAT:
%
%      [image_hsv, all_hsv, clean_hs] = fcn_LaneDet_ImagePreprocessing(image, varagin)
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
%      all_hsv: a NxM-by-3 array of hue,saturation and value values
%
%      clean_hs: a L-by-2 array of clean hue and saturation values
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_CreatMask for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
%
% This function was written on 2021_06_24 by Xinyu Cao
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
    fcn_LaneDet_checkInputsToFunctions(image_hsv, 'image_hsv');
    
end

% Show the plot
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

sz = size(image_hsv); % size of the matrix
Nrows = sz(1); % Number of rows of the matrix
Ncols = sz(2); % Number of columns of the matrix
Npages = sz(3); % Number of pages of the matrix
all_hsv = reshape(image_hsv, Nrows*Ncols, Npages); % Reshape the N x M matrix to an NxM x 1 array
all_s = all_hsv(:,2); % Grab the saturation value
all_hs =all_hsv(:,1:2); % Grab the Hue and Saturation value
% Clean the data set
clean_hs = all_hs((all_s >= 0.15), :);% Remove values for saturation less than 0.15


%% Plot the results for debugging

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
    % Create an arrary of colors for different points
    plot_hsv = unique([all_hs, 0.8*ones(Nrows*Ncols,1)],'rows');
    rgb_color = hsv2rgb(plot_hsv);
    figure(fig_num);
    clf;
    N_points = length(plot_hsv(:,1));
    % Plot the data points with corresponding color
    for ith_point = 1:step:N_points
        plot(plot_hsv(ith_point,1), plot_hsv(ith_point,2), '.','Markersize',1,'Color',rgb_color(ith_point,:));
        hold on
    end
    % Add x and y label
    xlabel('Hue')
    ylabel('Sat')
    % Add title
    title('Hue versus Saturation')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   

