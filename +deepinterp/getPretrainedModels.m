function [modelNames,modelParams] = getPretrainedModels()
% GETPRETRAINEDMODELS - return known, built-in pretrained models
%
% [MODELNAMES, MODELPARAMS] = GETPRETRAINEDMODELS()
%
% Return a list of known MODELNAMES and full parameter information
% about these models in MODELPARAMS.
%

filename = fullfile(deepinterp.toolboxpath,'pretrainedModels','pretrained.json');

the_text = deepinterp.internal.textfile2char(filename);

modelParams = jsondecode(the_text);

modelNames = {modelParams.name};

