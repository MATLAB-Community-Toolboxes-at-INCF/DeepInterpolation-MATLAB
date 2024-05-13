function net = getPretrainedModel(modelname)
% GETPRETRAINEDMODEL - return a pretrained model from DeepInterpolation Toolbox
%
% NET = GETPRETRAINEDMODEL(MODELNAME)
%
% Returns a pretrained model from the DeepInterpolation Toolbox.
%
% For a list of built-in pretrained model names, use LISTPRETRAINEDMODELS.
%
% Examples:
%   modelList = deepinterp.listPretrainedModels();
%   n1 = deepinterp.getPretrainedModel(modelList{1}); 
%
%   n2 = deepinterp.getPretrainedModel('TP-Ai93-450');

net = deepinterp.Net('pretrained','model',modelname);


