function setup()
% SETUP - add DeepInterpolation Toolbox folders to the MATLAB path
%
% SETUP()
%
% Adds DeepInterpolation Toolobx folders to the MATLAB path.
%

tbd = deepinterp.toolboxpath();

addpath(tbd);
addpath(fullfile(tbd, "sampleData"))
addpath(fullfile(tbd, "pretrainedModels"))
addpath(fullfile(tbd, "pretrainedModels","TensorFlowNetworks"))
addpath(fullfile(tbd, "examples"))


