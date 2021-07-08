function k = fcn_LaneDet_determineNumberOfClusters(all_hsv,varargin)
% fcn_LaneDet_ImagePreprocessing
% Determine the appropriate number of clusters for k-means clustering

% FORMAT:
%
%      k = fcn_LaneDet_determineNumberOfClusters(all_hsv,varagin)
%
% INPUTS:
%
%      all_hsv: a NxM-by-3 array of hue,saturation and value values
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
%
% OUTPUTS:
%
%      k: a scalar of number of clusters
% 
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_CreatMask for a full test 
% suite.
%
% This function was written on 2021_07_02 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%
% TODO:
% Update the method that find the peaks

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
    fcn_LaneDet_checkInputsToFunctions(all_hsv, 'hsv_array');
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
Nbins = 20; % Set the number of bins
hEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in h dimension
sEdges = linspace(0,1,Nbins + 1); % Specify the edges of the bins in s dimension
all_h = all_hsv(:,1); % Grab all hue values
all_s = all_hsv(:,2); % Grab all saturation values
h = histogram2(all_h, all_s, hEdges, sEdges); % Create a bivariate histogram plot of H and S
fig_h = gcf;% Grab current figure
fig_h.Visible = 'off'; % Set the visible off
h_counts = h.Values; % Grab the number of points in each bin
h_counts_T = h_counts.'; % Transpose transformation
counts = h_counts_T;

% Cut off values for saturation less than 0.15
s_cut = 0.15; 
s_cut_idx = round(s_cut/(1/Nbins));
counts_cut = counts;
counts_cut(1:s_cut_idx,:) = 0;
% Calculate the average count of all non-zero counts
% Cut off values for counts less than the average count
% to reduce errors
nonzero_counts = nonzeros(counts);
mean_count = mean(nonzero_counts);
counts_final = counts_cut;
counts_final(counts_final < mean_count) = 0;
% Find the peak vlaues by identifying the regional maxima
peak_counts = imregionalmax(counts_final);
% Find the rows and columns of the peak values
[r,c] = find(peak_counts);
% Get the number of peaks, which is the number of clusters
k = length(r);

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
    
    clf;
    % Set the bivariate histogram plot visible on
    fig_h.Visible = 'on'; 
    % Add x and y label
    xlabel('Hue')
    ylabel('Saturation')
    % Add title
    title('Number of points in different intervals')
    
    if flag_do_debug
        figure(fig_num + fig_h.Number);
        % Create 2-D grid coordinates
        [Hgrid, Sgrid] = meshgrid(linspace(0,1,Nbins));
        % Create the mesh plot
        s = mesh(Hgrid, Sgrid, counts_final);
        % Add x and y label
        xlabel('Hue')
        ylabel('Saturation')
        % Add title
        title('Filtered counts mesh plot')
        
    end
   
    
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function  
