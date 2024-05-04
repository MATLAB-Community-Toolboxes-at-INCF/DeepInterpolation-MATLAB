function setup()
% SETUP - add DeepInterpolation Toolbox folders to the MATLAB path
%
% SETUP()
%
% Adds DeepInterpolation Toolobx folders to the MATLAB path.
%

tbd = deepinterp.toolboxdir();

addpath(tbd);
addpath(fullfile(tbd, "network_layers"))
addpath(fullfile(tbd, "sampleData"))
addpath(fullfile(tbd, "examples"))
addpath(fullfile(tbd, "internal"))
addpath(fullfile(tbd, "datastore"))

