% Deep Interpolation
% This example imports and uses the deep interpolation model for the tiny ophys data in MATLAB.

%% Import and Assemble Model
% Import the trained model.
importednet = importKerasLayers('2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5','ImportWeights',true);
placeholders = findPlaceholderLayers(importednet);
disp(placeholders)
regressionnet = replaceLayer(importednet, placeholders.Name , maeRegressionLayer);
deepinterpnet = assembleNetwork(regressionnet)

%% Analyze Network
% Optionally analyze the network
if true
    analyzeNetwork(deepinterpnet)
end

%% Import Sample TIFF Volume
ophys = tiffreadVolume('ophys_tiny_761605196.tif');

%% Make Prediction
% The network expects an input of size:
regressionnet.Layers(1).InputSize
% The size of the ophys image is:
ophyssz = size(ophys)

% Make prediction with the equivalent size:
firstslice = ceil(9);
disp("before prediction")

 ophysinterp = predict(deepinterpnet, ophys(:,:,firstslice:(firstslice+59)));


%% Show interpolation result:
disp("after prediction")
imshow(ophysinterp, [])
title("Deep Interpolation of OPHYS")


