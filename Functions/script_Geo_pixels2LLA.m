%% Define maps
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
% Reber
lat_reber = 40.79350188901718;
lon_reber = -77.86443859340469;

lat_i99 = 40.823976;
lon_i99 = -78.003369;

zoom_level = 22;

%% Prep the environment
close all;


%% Get the map image
fig_1 = figure(1);
% Use geobubble to plot
gb1 = geobubble([], [], 'Basemap',satellite_basemap_name);
gb1.MapLayout = 'maximized';
gb1.ZoomLevel = zoom_level;
gb1.BubbleWidthRange = 10;
gb1.MapCenter = [lat_i99, lon_i99];

lat_lim = gb1.LatitudeLimits;
lon_lim = gb1.LongitudeLimits;
%Get the image from the map
pause(1);
frame = getframe(fig_1);
map_image = frame.cdata;


%% Example 1: Find the bottom left points
sz = size(map_image);
r = max(sz(1));
c = 1;

%% Example 2: Find the brightest point
hsvmap = rgb2hsv(map_image);
flipmap = flipud(hsvmap);
v = flipmap(:,:,3);
max_value = max(max(v));
[r, c] = find(v == max_value);

%% Convert pixels to LLA coordinates
sz = size(map_image);
rasterSize = [sz(1) sz(2)];
R = georefcells(lat_lim, lon_lim, rasterSize);
[lat_data, lon_data] = intrinsicToGeographic(R,c,r);


%% Show the points
gb1.LatitudeData = lat_data;
gb1.LongitudeData = lon_data;

%% Open up test_road in HSV
image_road_rgb = imread('test_road.tif');
image_road_hsv = rgb2hsv(image_road_rgb);
rescaled_h = rescale(image_road_hsv(:,:,1));
rescaled_s = rescale(image_road_hsv(:,:,2));
rescaled_v = rescale(image_road_hsv(:,:,3));

new_image = image_road_hsv;
new_image(:,:,1) = rescaled_h;
new_image(:,:,2) = rescaled_s;
new_image(:,:,3) = rescaled_v;

figure(38383);
imagesc(new_image);

% Keep only the hs portion, and crop off edges
image_sv = new_image(2:350,2:end-2,2:3);
Nrows = length(image_sv(:,1,1));
Ncols = length(image_sv(1,:,1));

all_s = reshape(image_sv(:,:,1),Nrows*Ncols,1);
all_v = reshape(image_sv(:,:,2),Nrows*Ncols,1);

figure(34484);
clf;
plot(all_s(all_s~=0),all_v(all_v~=0), '.');
xlabel('Sat');
ylabel('Value');



