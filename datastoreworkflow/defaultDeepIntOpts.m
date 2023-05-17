function deepIntOpts = defaultDeepIntOpts()
%DEFAULTDEEPINTOPTS return default options-struct for DeepInterpolation Training
%
% Convenience function that returns a default training options struct used as the
% input for the example training function deepIntTraining.m
%
% Dr. Thomas Künzel, The MathWorks, 2023
% tkuenzel@mathworks.com

deepIntOpts.networkPath = "networks";
deepIntOpts.networkName = "pretrainedNetwork.mat";
deepIntOpts.dataPath = "data";
deepIntOpts.dataName = "ophys_tiny_761605196.tif";
deepIntOpts.autoResize = false;
deepIntOpts.maxEpochs = 3;
deepIntOpts.miniBatchSize = 3;
deepIntOpts.stepsPerEpoch = 10;
deepIntOpts.initialLearnRate = 0.0001;
deepIntOpts.Verbose = true;
deepIntOpts.Plots = "none";
deepIntOpts.ExecutionEnvironment = "auto";
deepIntOpts.Shuffle = "never";%set this to at least "once" for GPU or parallel training
end

