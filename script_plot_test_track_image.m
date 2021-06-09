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


%% Prep the environment
close all;

%% Test of google maps API, get_google_map
% See: https://www.mathworks.com/matlabcentral/fileexchange/24113-get_google_map
% See: https://www.mathworks.com/matlabcentral/fileexchange/27627-zoharby-plot_google_map
% plot_google_map('apiKey', 'AIzaSyDF8_h6jrJXiPpZoQExlvRJgvNj6ysZ0Xo')
figure(9999); % For test images
clf;

% % Test track handling area
% lat = [40.863055, 40.862700];
% lon = [-77.834334, -77.833702];

% % Closer
% lat = [40.862781,40.862714];
% lon = [-77.834746,-77.834609];

% Origin of base station
lat_origin = [40.863697, 40.863698];
lon_origin = [-77.835961, -77.835962];

%lat = [48.8708   51.5188   41.9260   40.4312   52.523   37.982];
%lon = [2.4131    -0.1300    12.4951   -3.6788    13.415   23.715];
plot(lon_origin, lat_origin, '.r', 'MarkerSize', 20)
[origin_lonVec origin_latVec origin_imag] = plot_google_map(...
    'Scale',2,...
    'Resize',2,...
    'MapScale', 0, ...
    'MapType','satellite',...
    'ShowLabels',0);
% Close old image
close(9999);

% Show the new image
figure(84848);
imagesc(origin_imag);
axis equal;

%% Calculate size of result
image_size = length(origin_imag(:,1,1));
midPixel = round(image_size/2);

midpointLon = origin_lonVec(midPixel);
midpointLat = origin_latVec(midPixel);
deltaLon = origin_lonVec(end) - origin_lonVec(1);
deltaLat = origin_latVec(end) - origin_latVec(1);

%% Do a half-step up in longitude, see what happens
half_step_long = deltaLon/2;
lon = lon_origin+half_step_long;
lat = lat_origin;

figure(9999); % For test images
clf;

%lat = [48.8708   51.5188   41.9260   40.4312   52.523   37.982];
%lon = [2.4131    -0.1300    12.4951   -3.6788    13.415   23.715];
plot(lon, lat, '.r', 'MarkerSize', 20)
[lonVec latVec imag] = plot_google_map(...
    'Scale',2,...
    'Resize',2,...
    'MapScale', 0, ...
    'MapType','satellite',...
    'ShowLabels',0);
% Close old image
close(9999);

% Show the new image
figure(84849);
imagesc(imag);
axis equal;

%% Check that longitude is as expected at new midpoint
first_new_index = find(lonVec>max(origin_lonVec),1,'first');
% Gives:
% first_new_index = find(lonVec>max(origin_lonVec),1,'first')
% 
% first_new_index =
% 
%         2561
% 
% midPixel
% 
% midPixel =
% 
%         2560
% Which is exactly as we expect

%% Now do a full side-step, and put side-by-side
% Do a full-step down in longitude, see what happens
full_step_long = deltaLon;
lon = lon_origin-full_step_long;
lat = lat_origin;

figure(9999); % For test images
clf;

%lat = [48.8708   51.5188   41.9260   40.4312   52.523   37.982];
%lon = [2.4131    -0.1300    12.4951   -3.6788    13.415   23.715];
plot(lon, lat, '.r', 'MarkerSize', 20)
[lonVec latVec side_imag] = plot_google_map(...
    'Scale',2,...
    'Resize',2,...
    'MapScale', 0, ...
    'MapType','satellite',...
    'ShowLabels',0);
% Close old image
close(9999);

% Show the new image
figure(84847);
imagesc(side_imag);
axis equal;

%% Create a new image of side-by-side results
big_image = [side_imag, origin_imag];
figure(5);
imagesc(big_image);
axis equal;

%% Now do a half up-step, and put side-by-side cropping out bottom/top quarters
lon = lon_origin;
lat = lat_origin+deltaLat/2;

figure(9999); % For test images
clf;

%lat = [48.8708   51.5188   41.9260   40.4312   52.523   37.982];
%lon = [2.4131    -0.1300    12.4951   -3.6788    13.415   23.715];
plot(lon, lat, '.r', 'MarkerSize', 20)
[up_lonVec, up_latVec, up_imag] = plot_google_map(...
    'Scale',2,...
    'Resize',2,...
    'MapScale', 0, ...
    'MapType','satellite',...
    'ShowLabels',0);
% Close old image
close(9999);

% Show the new image
figure(3);
imagesc(up_imag);
axis equal;

%% Check that latitude is as expected at new midpoint
three_quarter_point = round(midPixel*1.5);
first_new_index = find(latVec>origin_latVec(three_quarter_point),1,'last');
% Gives:
% first_new_index = find(latVec>origin_latVec(three_quarter_point),1,'last')
% 
% first_new_index =
% 
%         1280
% 
% midPixel/2
% 
% ans =
% 
%         1280
% Which is exactly as we expect

%% Create a new image of side-by-side results
central_half = ((round(midPixel/2)+1):1:(round(midPixel*1.5)))';
cropped_original = origin_imag(central_half,:,:);
cropped_up_imag = up_imag(central_half,:,:);

tall_image = [cropped_original;cropped_up_imag];
lat_tall = [origin_latVec(1,central_half)'; up_latVec(1,central_half)'];
figure(6);
imagesc(tall_image);
axis equal;

%% Grab all the images
% The test track appears to be -3 steps to +5 steps (9 positions) from the
% origin in longitude, and -2 steps to +2 steps in 0.5 step units - to
% allow overlap - (8 positions) in latitude. Let's check it by building an
% offset row. The images will be numbered in a grid

% % Top left corner
% Nsteps_offset_lon = -3;
% Nsteps_offset_lat = -2;
% 
% % Top right corner
% Nsteps_offset_lon = 5;
% Nsteps_offset_lat = -2;
% 
% % Bottom left corner
% Nsteps_offset_lon = -3;
% Nsteps_offset_lat = 2;
% 
% % Bottom right corner
% Nsteps_offset_lon = 5;
% Nsteps_offset_lat = 2;

% Repeat the original query to grab default image size
% Origin of base station at the test track
lat_origin = [40.863697, 40.863698];
lon_origin = [-77.835961, -77.835962];

figure(9999); % For making the query        
plot(lon_origin, lat_origin, '.r', 'MarkerSize', 20)
[origin_lonVec, origin_latVec, origin_imag] = plot_google_map(...
    'Scale',2,...
    'Resize',1,...
    'MapScale', 0, ...
    'MapType','satellite',...
    'ShowLabels',0);
% Close old image
close(9999);

% Show the new image
figure(1111);
imagesc(origin_imag);
axis equal;

% Set up constants using the origin image above
image_size = length(origin_imag(:,1,1));
midPixel = round(image_size/2);

midpointLon = origin_lonVec(midPixel);
midpointLat = origin_latVec(midPixel);

deltaLon = origin_lonVec(end) - origin_lonVec(1);
deltaLat = origin_latVec(end) - origin_latVec(1);

central_half = ((round(midPixel/2)+1):1:(round(midPixel*1.5)))';

% These are the full image steps to take around the central image above
stepsLon = (-3:1:5);
stepsLat = (-2:0.5:2);
max_size = 10*(length(stepsLat)-1)+length(stepsLon);

% Preallocate the structure
allImages(max_size).Nsteps_offset_lon = 0;

% Start looping
for jthLat = 1:length(stepsLat)
    for ithLong = 1:length(stepsLon)
        % Create number
        imageNumber = 10*(jthLat-1)+ithLong;
        fprintf(1,'Calculating image: %.0d / %.0d\n',imageNumber,max_size);
        
        Nsteps_offset_lon = stepsLon(ithLong);
        Nsteps_offset_lat = stepsLat(jthLat);
        
        lon_query = lon_origin + deltaLon*Nsteps_offset_lon;
        lat_query = lat_origin + deltaLat*Nsteps_offset_lat;
        
        figure(9999); % For making the query
        clf;
        plot(lon_query, lat_query, '.r', 'MarkerSize', 20)
        [lonVec, latVec, imag] = plot_google_map(...
            'Scale',2,...
            'Resize',1,...
            'MapScale', 0, ...
            'MapType','satellite',...
            'ShowLabels',0);
        close(9999); % Close old image
                
        % Crop the image
        cropped_imag = imag(central_half,:,:);
        
        % Show the new image
        figure(2);
        imagesc(cropped_imag);
        axis equal;
        pause(0.01);
        
        % Save results
        allImages(imageNumber).Nsteps_offset_lon = Nsteps_offset_lon;
        allImages(imageNumber).Nsteps_offset_lon = Nsteps_offset_lat;
        allImages(imageNumber).lon_query = lon_query;
        allImages(imageNumber).lat_query = lat_query;
        allImages(imageNumber).lonVec = lonVec';
        allImages(imageNumber).latVec = latVec(1,central_half)';
        allImages(imageNumber).imag = cropped_imag;
    end
end

% Save result to file
save('testTrackData.mat','allImages','stepsLon','stepsLat','-v7.3')

%% Create super-image by merging images
try
    temp = allImages(1).Nsteps_offset_lon;
catch
    load('testTrackData.mat');
end

sample_lonVec = allImages(1).lonVec;
sample_latVec = allImages(1).latVec;
sample_imag   = allImages(1).imag;
Nrows = length(sample_imag(:,1,1));
Ncols = length(sample_imag(1,:,1));

Nlons = length(sample_lonVec);
Nlats = length(sample_latVec);

NLonSteps = length(stepsLon);
NLatSteps = length(stepsLat);


% Preallocate vectors
big_lonVec = zeros(NLonSteps*Nlons,1);

% Fill big_lonVec
for ithLong = 1:NLonSteps
        
    % Create number
    imageNumber = ithLong;
    
    % Grab results
    lonVec = allImages(imageNumber).lonVec;
    
    % Calculated indices
    indices = (1:Ncols)' + (ithLong-1)*Ncols;
    big_lonVec(indices) = lonVec;
    
end
% For debugging: figure; plot(diff(big_lonVec))
    
% Preallocate vectors
big_latVec = zeros(NLatSteps*Nlats,1);

% Fill big_latVec
for jthLat = 1:NLatSteps
    
    % Create number
    imageNumber = 10*(jthLat-1)+1;
       
    % Grab results
    latVec = allImages(imageNumber).latVec;
    
    % Calculated indices - as jthLat numbers get larger, latitude gets smaller
    %indices = (1:Nrows)' + (NLatSteps-jthLat)*Nrows;
    indices = (1:Nrows)' + (jthLat-1)*Nrows;
    big_latVec(indices) = latVec;
    
end
% For debugging: figure; plot(diff(big_latVec))

% Preallocate vectors
big_imag   = cast(zeros(Nrows*NLatSteps,Ncols*NLonSteps,3),'uint8');

% Fill big_imag
for jthLat = 1:NLatSteps
    fprintf(1,'Working on row: %.0d\n',jthLat);
    for ithLong = 1:NLonSteps  
        % Create number
        imageNumber = 10*(jthLat-1)+ithLong;                        

        fprintf(1,'   Merging longitude: %.0d / %.0d, Image: %.0d\n',ithLong,max_size,imageNumber);
        
        % Grab results
        lonVec = allImages(imageNumber).lonVec;
        latVec = allImages(imageNumber).latVec;
        imag = allImages(imageNumber).imag;
        
        % Calculated long indices
        indices = (1:Ncols)' + (ithLong-1)*Ncols;
        error = big_lonVec(indices) - lonVec;
        if max(abs(error))>(2E-7)
            warning('Large longitudinal errors detected');
        end
 
        % Calculated lat indices
        indices = (1:Nrows)' + (jthLat-1)*Nrows;
        error = big_latVec(indices) - latVec;
        if max(abs(error))>(3E-7)
            warning('Large latitude errors detected');
        end
 
        % Calculated image row
        col_indices = (1:Ncols)' + (ithLong-1)*Ncols;
        row_indices = (1:Nrows)' + (jthLat-1)*Nrows;
        big_imag(row_indices,col_indices,:) = imag;
        
        figure(3);
        imshow(big_imag);
        pause(0.05);
    end
end
save('testTrackImage.mat','big_imag','-v7.3')

