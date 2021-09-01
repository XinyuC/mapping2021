function clean_marker_cluster = fcn_LaneDet_HSClustering(clean_image_hsv, varargin)
% fcn_LaneDet_HSClustering
% Perform k-means clustering to partition the dataset into k clusters,
% and find the cluster for the lane marker accoridng to reference cluster centroid
% Remove outliers in the marker cluster
%
% FORMAT:
%
%      marker_cluster = fcn_LaneDet_HSClustering(input_hs, k, varagin)
%
% INPUTS:
%
%      input_hs: a NxM-by-2 array of hue and saturation values.
%
%      k: a scalar of number of clusters 
%    
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
% 
%      C_ref: reference cluster centroid
%
% OUTPUTS:
%
%      clean_marker_cluster: a array of hue and saturation values for
%      the marker cluster
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_CreatMask for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions

% This function was written on 2021_06_24 by Xinyu Cao
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
    if nargin < 2 || nargin > 4
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    fcn_LaneDet_checkInputsToFunctions(clean_image_hsv, 'hs_array');
    
end

if 3 == nargin
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
sz = size(clean_image_hsv);
Nrows = sz(1);
Ncols = sz(2);
clean_hs_array = reshape(clean_image_hsv(:,:,2), Nrows*Ncols, 2);
clean_hs_array(isnan(clean_hs_array)) = 0;
[idx, C] =kmeans(clean_hs_array ,2); % Use k-mean clustering to partition the final_data into k clusters
C_ref = [0.11, 0.5]; % Default reference cluster centroid
dists = vecnorm(C  - C_ref,2,2);
[markerDist,markerIndex] = min(dists); % Find the index of the closest cluster
marker_cluster = input_hs(idx == markerIndex,:); % Grab all the data point in the cluster
marker_h = marker_cluster(:,1);
marker_s = marker_cluster(:,2);
[marker_h_routliers, marker_TF_h] = rmoutliers(marker_h); % Remove outliers
[marker_s_routliers, marker_TF_s] = rmoutliers(marker_s); % Remove outliers
clean_marker_cluster =marker_cluster((~marker_TF_h)&(~marker_TF_s),:); %Grab the clean data
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
    % Plot the marker cluster
    plot(marker_cluster(:,1),marker_cluster(:,2), 'b.', 'Markersize', 1.5)
    % Set x and y axis limits
    xlim([0 1]);
    ylim([0 1]);
    
    title('Marker Cluster')
    
    figure(fig_num + 1)
    % Plot the marker cluster without outliers
    plot(clean_marker_cluster(:,1),clean_marker_cluster(:,2), 'r.', 'Markersize', 1.5)
    % Add title
    title('Marker Cluster Without Outliers')
    % Set x and y axis limits
    xlim([0 1]);
    ylim([0 1]);
   
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   