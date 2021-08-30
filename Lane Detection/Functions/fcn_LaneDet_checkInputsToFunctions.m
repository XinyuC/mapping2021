function fcn__LaneDet_checkInputsToFunctions(...
    variable,variable_type_string)

% fcn_Path_checkInputsToFunctions
% Checks the variable types commonly used in the Lane Detection class to ensure that
% they are correctly formed. This function is typically called at the top
% of most Lane Detection class functions. The input is a variable and a string
% defining the "type" of the variable. This function checks to see that
% they are compatible. For example, the 'image' type variables in the class
% function are N-by-M-by-3 arrays of RGB values; if someone had a image variable
% called "image_example", they could check that this fit the image type by
% calling fcn_LaneDet_checkInputsToFunctions(image_example,'image'). This
% function would then check that the array was N-by-M-by-3, and if it was not, it
% would send out an error warning.
%
% FORMAT:
%
%      fcn_LaneDet_checkInputsToFunctions(...
%      variable,variable_type_string)
%
% INPUTS:
%
%      variable: the variable to check
%
%      variable_type_string: a string representing the variable type to
%      check. The current strings include:
%
%            'input_image' - checks that the image size is N-by-M-by-3 and
%            its data type is 'unit8' or 'double'
%
%            'image_hsv' - checks that the image size is N-by-M-by-3 and
%            all the values are in the range [0 1]

%            'hsv_array' - checks that the hsv_array size is NxM-by-3 and its
%            data type is 'double'
%
%            'hs_array' - checks that the hs_array size is NxM-by-2 and its
%            data type is 'double'

%            'v_array' - checks that the v_array size is NxM-by-1 and its
%            data type is 'double'
%
%      Note that the variable_type_string is not case sensitive: for
%      example, 'image_rgb' and 'Image_rgb' or 'Image_RGB' all give the same
%      result.
%
% OUTPUTS:
%
%      No explicit outputs, but produces MATLAB error outputs if conditions
%      not met, with explanation within the error outputs of the problem.
%
% EXAMPLES:
%
% See the script: script_test_fcn_LaneDet_checkInputsToFunctions
% for a full test suite.
%
% DEPENDENCIES:
%
%      Uses MATLABs dbstack feature to trace dependencies 
%
% This function was written on 2021_07_06 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu

% Revision history:
%      2021_07_06:
%      -- first write of this code 
%      -- updated traversal type to allow above as type, added comments


flag_do_debug = 0; % Flag to debug the results
flag_do_plot = 0; % Flag to plot the results
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
    if nargin < 2 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    if ~ischar(variable_type_string)
        error('The variable_type_string input must be a string type, for example: ''image_rgb'' ');
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

% Grab the variable name
variable_name = inputname(1);

% Make the variable lower case
variable_type_string = lower(variable_type_string);

%% input_image
if strcmpi(variable_type_string,'input_image')
    % Check the station input
    sz = size(variable); 
    % Check the size of the image_rgb input
    if (length(sz) ~= 3) 
        error('The %s input must be a input_image type, with a size of N-by-M-by-3',variable_name);
    end
end


%% image_hsv
if strcmpi(variable_type_string,'image_hsv')
    % Check the station input
    sz = size(variable); 
    % Check the size of the image_rgb input
    if (length(sz) ~= 3) 
        error('The %s input must be a image_hsv type, with a size of N-by-M-by-3',variable_name);
    end
    % Check the data type of the image_rgb input
    if ~isa(variable,'double')
        error('The %s input must be a image_hsv type, with a double data type',variable_name);
    end
end

%% hsv_array
if strcmpi(variable_type_string,'hsv_array')
    % Check the size of the hsv_array input
    sz = size(variable); 
    if (length(sz) ~= 2) || (sz(2)~=3)
        error('The %s input must be a hsv_array type, with a size of NxM-by-3',variable_name);
    end
    
    % Check the data type of the hsv_array input
    if ~isa(variable,'double')
        error('The %s input must be a hsv_array type, with a double-precision data type',variable_name);
    end
end

%% hs_array
if strcmpi(variable_type_string,'hs_array')
    % Check the size of the hsv_array input
    sz = size(variable); 
    if (length(sz) ~= 2) || (sz(2) ~= 2)
        error('The %s input must be a hs_array type, with a size of NxM-by-2',variable_name);
    end
    
    % Check the data type of the hsv_array input
    if ~isa(variable,'double')
        error('The %s input must be a hs_array type, with a double-precision data type',variable_name);
    end
end

%% v_array
if strcmpi(variable_type_string,'v_array')
    % Check the size of the hsv_array input
    sz = size(variable); 
    if (length(sz) ~= 2) || (sz(2) ~= 1)
        error('The %s input must be a v_array type, with a size of NxM-by-1',variable_name);
    end
    
    % Check the data type of the hsv_array input
    if ~isa(variable,'double')
        error('The %s input must be a v_array type, with a double-precision data type',variable_name);
    end
end

%% binary_image
if strcmpi(variable_type_string,'binary_image')
    % Check the size of the binaey_image input
    sz = size(variable); 
    if length(sz) ~= 2
        error('The %s input must be a binary_image type, with a size of N-by-M',variable_name);
    end
    
    % Check the data type of the hsv_array input
    if ~isa(variable,'logical')
        error('The %s input must be a binary_image type, with a logical data type',variable_name);
    end
end


%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plot
    % Nothing to plot here
end % Ends the flag_do_plot if statement

if flag_do_debug
    fprintf(1,'The variable: %s was checked that it meets type: %s, and no errors were detected.\n',variable_name,variable_type_string);
end
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end

end % Ends the function