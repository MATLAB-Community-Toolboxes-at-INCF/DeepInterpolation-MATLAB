function deepIntTraining(deepIntOpts)
%DEEPINTTRAINING - Exemplary training function for DeepInterpolationMATLAB
% 
% Example training function that for DeepInterpolation MATLAB. This function is
% controlled by a single options struct that contains paths to data and neteworks and
% the options for training.
%
% Use "defaultDeepIntOpts.m" to generate the default training options sufficient to
% run the test example or modify the output of this function to match your own data
% and locations.
%
% Please also see the github repository of the original python-version of
% DeepInterpolation for info: https://github.com/AllenInstitute/deepinterpolation
%
% Dr. Thomas Künzel, The MathWorks, 2023
% tkuenzel@mathworks.com

dataFullPath = fullfile(deepIntOpts.dataPath, deepIntOpts.dataName);
dids = DeepInterpolationDataStore(dataFullPath, deepIntOpts.autoResize);

tempLoad = load(fullfile(deepIntOpts.networkPath,deepIntOpts.networkName));
pretrainednet = tempLoad.output;

options = trainingOptions('rmsprop', ...
    'MaxEpochs',deepIntOpts.maxEpochs,...
    'MiniBatchSize',deepIntOpts.miniBatchSize, ...
    'InitialLearnRate',deepIntOpts.initialLearnRate, ...
    'ValidationFrequency',deepIntOpts.stepsPerEpoch,...
    'Verbose',deepIntOpts.Verbose,...
    'Plots',deepIntOpts.Plots,...
    'Shuffle',deepIntOpts.Shuffle,...
    'ExecutionEnvironment',deepIntOpts.ExecutionEnvironment);

output = trainNetwork(dids, pretrainednet.layerGraph, options);

retrainedNetFilename = fullfile("retrainedNetwork_" + datestr(now,'YYYYmmDD_HHMMSS') + ".mat");
save(fullfile(deepIntOpts.networkPath,retrainedNetFilename),'output');

end
