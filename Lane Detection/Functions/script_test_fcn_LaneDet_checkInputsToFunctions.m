%% Prepare the script
close all
clear all
clc

%%

% folder_name = '..\images\';
folder_name = '..\Images\test\';
addpath(folder_name)

%% Load all the images in the folder
% image_location = 'F:\Lecture\Summer2021\mapping2021\images\*.jpg';
% image_location = '..\downloads\*.jpg';
image_location= '..\Images\test\*.jpg';
image_files = dir(image_location);
nfiles = length(image_files);

for n = 1:nfiles;
       current_image_name = image_files(n).name;
       current_image_folder = image_files(n).folder;
       current_image = imread(current_image_name);
       current_image_hsv = rgb2hsv(current_image);
       images_names{n} = current_image_name;
       images_rgb{n} = current_image;
       images_hsv{n} = current_image_hsv;
end

%% 
i = 1;
image_rgb = images_rgb{i};
image_hsv = images_hsv{i};
sz = size(image_rgb);
Nrows = sz(1);
Ncols = sz(2);
Npages = sz(3);
all_rgb = reshape(image_rgb, Nrows*Ncols, Npages);
all_rg = all_rgb(:,1:2);
all_b = all_rgb(:,3);
all_hsv = reshape(image_hsv, Nrows*Ncols, Npages);
all_hs = all_hsv(:,1:2);
all_v = all_hsv(:,3);

%% input_image

%   _                   _     _                            
%  (_)                 | |   (_)                           
%   _ _ __  _ __  _   _| |_   _ _ __ ___   __ _  __ _  ___ 
%  | | '_ \| '_ \| | | | __| | | '_ ` _ \ / _` |/ _` |/ _ \
%  | | | | | |_) | |_| | |_  | | | | | | | (_| | (_| |  __/
%  |_|_| |_| .__/ \__,_|\__| |_|_| |_| |_|\__,_|\__, |\___|
%          | |           ______                  __/ |     
%          |_|          |______|                |___/      
%     

%% Test the image_rgb (success)
fcn_LaneDet_checkInputsToFunctions(image_rgb, 'input_image')

%% Test the image_rgb (Size error)
fcn_LaneDet_checkInputsToFunctions(all_hsv, 'image_rgb')

%% image_hsv
%   _                              _               
%  (_)                            | |              
%   _ _ __ ___   __ _  __ _  ___  | |__  _____   __
%  | | '_ ` _ \ / _` |/ _` |/ _ \ | '_ \/ __\ \ / /
%  | | | | | | | (_| | (_| |  __/ | | | \__ \\ V / 
%  |_|_| |_| |_|\__,_|\__, |\___| |_| |_|___/ \_/  
%                      __/ |  ______               
%                     |___/  |______|              
%    

%% Test the image_rgb (success)
fcn_LaneDet_checkInputsToFunctions(image_hsv, 'image_hsv')

%% Test the image_rgb (Size error)
fcn_LaneDet_checkInputsToFunctions(all_hsv, 'image_hsv')

%% Test the image_rgb (Data type error)
fcn_LaneDet_checkInputsToFunctions(image_rgb, 'image_hsv')

%% hsv_array

%   _                                         
%  | |                                        
%  | |__  _____   ____ _ _ __ _ __ __ _ _   _ 
%  | '_ \/ __\ \ / / _` | '__| '__/ _` | | | |
%  | | | \__ \\ V / (_| | |  | | | (_| | |_| |
%  |_| |_|___/ \_/ \__,_|_|  |_|  \__,_|\__, |
%              ______                    __/ |
%             |______|                  |___/ 

%% Test the hsv_array (success)
fcn_LaneDet_checkInputsToFunctions(all_hsv, 'hsv_array')

%% Test the hsv_array (Size error)
fcn_LaneDet_checkInputsToFunctions(all_hs, 'hsv_array')

%% Test the image_rgb (Data type error)
fcn_LaneDet_checkInputsToFunctions(all_rgb, 'hsv_array')

%% hs_array

%   _                                     
%  | |                                    
%  | |__  ___   __ _ _ __ _ __ __ _ _   _ 
%  | '_ \/ __| / _` | '__| '__/ _` | | | |
%  | | | \__ \| (_| | |  | | | (_| | |_| |
%  |_| |_|___/ \__,_|_|  |_|  \__,_|\__, |
%          ______                    __/ |
%         |______|                  |___/ 

%% Test the hsv_array (success)
fcn_LaneDet_checkInputsToFunctions(all_hs, 'hs_array')

%% Test the hsv_array (Size error)
fcn_LaneDet_checkInputsToFunctions(all_hsv, 'hs_array')

%% Test the image_rgb (Data type error)
fcn_LaneDet_checkInputsToFunctions(all_rg, 'hs_array')

%% v_array                             
                                  
%  __   ____ _ _ __ _ __ __ _ _   _ 
%  \ \ / / _` | '__| '__/ _` | | | |
%   \ V / (_| | |  | | | (_| | |_| |
%    \_/ \__,_|_|  |_|  \__,_|\__, |
%    ______                    __/ |
%   |______|                  |___/ 

%% Test the hsv_array (success)
fcn_LaneDet_checkInputsToFunctions(all_v, 'v_array')

%% Test the hsv_array (Size error)
fcn_LaneDet_checkInputsToFunctions(all_hsv, 'v_array')

%% Test the image_rgb (Data type error)
fcn_LaneDet_checkInputsToFunctions(all_b, 'v_array')
