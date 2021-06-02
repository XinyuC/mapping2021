function map_image = fcn_geoplot_imageFromLLAandZoomLevel(LLA_coords, zoom_level, varargin)
% fcn_geoplot_imageFromLLAandZoomLevel
% % INPUTS:
%      LLA_coords: LLA coordinates, a 1x2 array containing latitude and
%      longitude
%      zoom_level: The zoom level of the geoplot
%      varargin{1}: type, the basemap of the map

flag_check_inputs = 1; % Flag to perform input checking

%% check input arguments
if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 2
        error('Incorrect number of input arguments, there are at least two inputs')
    end
    if nargin > 4
        warning('Too many inputs arguments, ')
    end
end

lat = LLA_coords(1);
lon = LLA_coords(2);

%% Create figure window
fig = figure(1);
fig.Visible = 'off'; % Do not show the plot
% Use geobubble to plot
gb = geobubble(lat, lon);
gb.MapLayout = 'maximized';
gb.ZoomLevel = zoom_level;
gb.BubbleWidthRange = 10;
% Set the basemap for the groplot

if  nargin == 3
    gb.Basemap = varargin{1};
end
pause(1);
frame = getframe(fig);
map_image = frame.cdata;
close(fig);