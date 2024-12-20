function tbd = setup()
% SETUP - add DeepInterpolation Toolbox folders to the MATLAB path
%
% TBD = SETUP()
%
% Adds DeepInterpolation Toolobx folders to the MATLAB path.
%
% Returns the toolbox directory TBD.
%

tbd = deepinterp.toolboxpath();

addpath(tbd);
addpath(fullfile(tbd, "sampleData"))
addpath(fullfile(tbd, "pretrainedModels"))
addpath(fullfile(tbd, "pretrainedModels","TensorFlowNetworks"))
addpath(fullfile(tbd, "examples"))


