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

lat_i99 = 40.823968286502730;
lon_i99 = -78.003310823031850;

% lat_i99 = 40.83209454405909;
% lon_i99 = -77.9816921722933;

lat_us220 = 40.815652;
lon_us220 = -77.921324;

zoom_level = 23.5;

%% Get the map image
fig_1 = figure(1);
% Use geobubble to plot
gb1 = geobubble([], [], 'Basemap',satellite_basemap_name);
gb1.MapLayout = 'maximized';
gb1.ZoomLevel = zoom_level;
gb1.BubbleWidthRange = 10;
gb1.MapCenter = [lat_i99, lon_i99];
gb1.ScalebarVisible = 'off';

lat_lim = gb1.LatitudeLimits;
lon_lim = gb1.LongitudeLimits;
%% Get the image from the map
pause(1);
frame = getframe(fig_1);
map_image = frame.cdata;
% imwrite(map_image, 'test_image.tif')


%% Open up test_image in HSV
clc
image_road_rgb = imread('test_image.tif');

image_road_crop = image_road_rgb(2:end-1, 2:715,:);
image_road_hsv = rgb2hsv(image_road_crop);


h_value = image_road_hsv(:,:,1);
s_value = image_road_hsv(:,:,2);
v_value = image_road_hsv(:,:,3);
rescaled_h = rescale(h_value);
rescaled_s = rescale(s_value);
rescaled_v = rescale(v_value);
% % % 
new_image = image_road_hsv;
new_image(:,:,1) = rescaled_h;
new_image(:,:,2) = rescaled_s;
new_image(:,:,3) = rescaled_v;

% Crop off useless part
final_image = new_image(1:590,30:357, :);
final_h = final_image(:,:,1);
final_s = final_image(:,:,2);
final_v = final_image(:,:,3);
% % % 
figure(222);

imshow(final_image)
% % 
% % Keep only the hs portion, and crop off edges
sz = size(final_h);
Nrows = sz(1);
Ncols = sz(2);
% % 
all_h = reshape(final_h,Nrows*Ncols,1);
all_s = reshape(final_s,Nrows*Ncols,1);
all_v = reshape(final_v,Nrows*Ncols,1);
% % 

% % plot(all_s(all_s~=0),all_v(all_v~=0), '.');

all_hs = [all_h all_s];
all_sv = [all_s, all_v];
all_hsv = [all_h all_s all_v];
[idx, C] =kmeans(all_sv, 2);

% test_colormap(:,:,3) = C(2,3);
% plot3(all_h, all_s,all_v, '.')
% scatter()
figure(333)
plot(all_s, all_v, '.')
hold on
plot(C(:,1), C(:,2), '*')
% xlabel('Hue');
% ylabel('Sat');

%% Build hsv mask

lower_sat = min(C(:,1));
upper_sat = max(C(:,1));
lower_val = min(C(:,2));
upper_val = max(C(:,2));
% hueMask = (final_h <= lower_hue);
saturationMask = (final_s <= lower_sat);
valueMask = rescaled_v >= upper_val;
% hueMask = (final_h >= upper_hue);
% saturationMask = (final_s >= lower_sat);
% valueMask = (vimage >= lower_value) & (vimage <= upper_value);
% coloredObjectsMask = uint8( saturationMask&valueMask);
figure(444);
% imshow(saturationMask)
imshow(valueMask)
% imshow(coloredObjectsMask)
edgemap = edge(valueMask,'canny');
% SE = strel('disk', 25);
% reducedmap = imopen(binarymap, SE);
reducedmap = bwskel(edgemap);
figure(555);
imshow(reducedmap)