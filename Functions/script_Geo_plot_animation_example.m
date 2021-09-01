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
addCustomBasemap(nm,fullurl,'Attribution',att)

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

%% Define starting target coordinates
% Use the commands:   format long; [latlim, lonlim] = geolimits
% % Coordinates for Old Main:
% latlim = [40.796064444225301  40.796828937885572];
% lonlim = [-77.863273341139688 -77.862402964314356];
% starting_zoom = 18.5

% Coordinates for Test Track:
latlim = [40.861438471644057  40.866694032202510];
lonlim = [ -77.838454582001205 -77.829188750816726];
starting_zoom = 16.375;

% Coordinates for I-99
% latlim = [  40.826419352762386  40.842636945191465];
% lonlim = [ -77.982092112669562 -77.953512382351434];
% starting_zoom = 12.17;


fig_h(1) = figure(1);
gb1 = geobubble(mean(latlim),mean(lonlim),'Basemap',satellite_basemap_name);
gb1.BubbleWidthRange = 15;
gb1.MapLayout = 'maximized';
gb1.ZoomLevel = starting_zoom;
all_gbs(1) = gb1;

ten_meters_decimal_places = 0.0001;
one_meters_decimal_places = 0.00001;

disp('Hit any key to continue');
pause;
for iposition = 1:1:100
    fig_h(1).Children.LatitudeData = fig_h(1).Children.LatitudeData + ...
        ten_meters_decimal_places;  % Move the marker by 1 meters
    drawnow;
    %pause(0.01);
end
% fig_h(2) = figure(2);
% gb2 = geobubble(mean(latlim),mean(lonlim),'Basemap',OSM_basemap_name);
% gb2.BubbleWidthRange = 15;
% gb2.MapLayout = 'maximized';
% gb2.ZoomLevel = starting_zoom;
% all_gbs(2) = gb2;
% 
% 
% fig_h(3) = figure(3);
% gb3 = geobubble(mean(latlim),mean(lonlim),'Basemap',streets_basemap_name);
% gb3.BubbleWidthRange = 15;
% gb3.MapLayout = 'maximized';
% gb3.ZoomLevel = starting_zoom;
% all_gbs(3) = gb3;
% 
% fig_h(4) = figure(4);
% gb4 = geobubble(mean(latlim),mean(lonlim),'Basemap',streetsdark_basemap_name);
% gb4.BubbleWidthRange = 15;
% gb4.MapLayout = 'maximized';
% gb4.ZoomLevel = starting_zoom;
% all_gbs(4) = gb4;
% 
% fig_h(5) = figure(5);
% gb5 = geobubble(mean(latlim),mean(lonlim),'Basemap',landcover_basemap_name);
% gb5.BubbleWidthRange = 15;
% gb5.MapLayout = 'maximized';
% gb5.ZoomLevel = starting_zoom;
% all_gbs(5) = gb5;
% 
% 
% fig_h(6) = figure(6);
% gb6 = geobubble(mean(latlim),mean(lonlim),'Basemap',topographic_basemap_name);
% gb6.BubbleWidthRange = 15;
% gb6.MapLayout = 'maximized';
% gb6.ZoomLevel = starting_zoom;
% all_gbs(6) = gb6;

% Save handles for all in each figs user data
for i_fig = 1:length(fig_h)
    set(fig_h(i_fig),'UserData',all_gbs);
end

% % Start timer function to sync plots
% t = fcn_checkPlots;
% start(t)

% % Create 3D surface? (needs 2020a version or higher)
% uif = uifigure;
% g = geoglobe(uif,'Basemap','usgstopo');
% hold(g,'on')
% geoplot3(g,mean(latlim),mean(lonlim),100,'r')





