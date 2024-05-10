function net = importKerasMAE(kerasFile)
% IMPORTKERAS_MAE - import a Keras network, converting placeholder to mae
%
% NET = IMPORTKERASMAE(KERASFILE)
%
% Imports a Keras Deep Learning Network from the file KERASFILE.
% PLACEHOLDER layers are replaced with mean-average-error
% layers.
%

importednet = importKerasLayers(kerasFile,'ImportWeights',true);

placeholders = findPlaceholderLayers(importednet);

regressionnet = replaceLayer(importednet, placeholders.Name , ...
	deepinterp.maeRegressionLayer);

net = assembleNetwork(regressionnet);

