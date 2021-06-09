%%
% Set up the plot sources
% See: https://www.mathworks.com/help/map/ref/addcustombasemap.html for
% instructions

% Other examples to explore:
% https://itectec.com/matlab/matlab-i-would-like-to-do-geobubble-plot-over-indian-landmass-i-follow-the-following-link-to-create-the-bubble-plothttps%E2%80%8B-in-math%E2%80%8Bworks-com-%E2%80%8Bhelp-matla%E2%80%8Bb-ref-geob/
% https://www.mathworks.com/matlabcentral/answers/487959-overlay-polygon-on-geographic-axes

% Load non-standard basemaps
% OSM:
name = 'openstreetmap';
url = 'a.tile.openstreetmap.org';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors";
addCustomBasemap(name,url,'Attribution',attribution)

% USGS national map:
url = "https://basemap.nationalmap.gov/ArcGIS/rest/services";
fullurl = url + "/USGSTopo/MapServer/tile/${z}/${y}/${x}";
nm = 'usgstopo';
att = 'Credit: US Geological Survey';
% addCustomBasemap(nm,fullurl,'Attribution',att)

OSM_basemap_name = 'openstreetmap';
satellite_basemap_name = 'satellite';
streets_basemap_name = 'streets';
streetsdark_basemap_name = 'streets-dark';
landcover_basemap_name = 'topographic'; % This is a low-res topo map (base map within MATLAB)
topographic_basemap_name = 'usgstopo';

% Others include:
% 'landcover'; % This one is only detailed when zoomed way out
% 'colorterrain'; % This one is only detailed when zoomed way out
% 'topographic'; % This is a low-res topo map (base map within MATLAB)

%% Define variables
%  Texas Roadhouse
lat_texas = 40.81549888090226; 
lon_texas= -77.89770215939609;
zoom_level_1 = 14;
% Reber
lat_reber = 40.79350188901718;
lon_reber = -77.86443859340469;
zoom_level_2 = 16;
% Giant
lat_giant = 40.803392518674414;
lon_giant =  -77.88695368465353;
zoom_level_3 = 20;

%% Prepare the workspace
close all
clc


%% Example 1
coord_1 = [lat_texas, lon_texas];
map_image_1 = fcn_geoplot_imageFromLLAandZoomLevel(coord_1, zoom_level_1);
figure;
imshow(map_image_1)

%% Example 2: uses the satellite as base map
coord_2 = [lat_reber, lon_reber];
map_image_2 = fcn_geoplot_imageFromLLAandZoomLevel(coord_2, zoom_level_2, satellite_basemap_name);
figure;
imshow(map_image_2);


%% Example 2: uses the satellite as base map
coord_3 = [lat_giant, lon_giant];
map_image_3 = fcn_geoplot_imageFromLLAandZoomLevel(coord_3, zoom_level_3, OSM_basemap_name);
figure;
imshow(map_image_3)

