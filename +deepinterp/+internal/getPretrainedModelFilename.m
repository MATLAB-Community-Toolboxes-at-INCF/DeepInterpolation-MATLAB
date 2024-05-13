function [filename,parameters] = getPretrainedModelFilename(modelName)
% GETPRETRAINEDMODELFILENAME - get the file name and parameters for a pretrained model
% 
% [FILENAME, PARAMETERS] = GETPRETRAINEDMODELFILENAME(MODELNAME)
%
% Returns the FILENAME and the pretrained model PARAMETERS for a given MODELNAME.
%
% Alternatively, one may call the function with no input arguments for a list
% of valid MODELNAME entries:
%
% [ALLMODELNAMES] = GETPRETRAINEDMODELFILENAME()
%
% Example:
%   [filename,parameters] = deepinterp.internal.getPretrainedModelFilenam('TP-Ai93-450');
%

filename = [];
parameters = [];

[allModelNames,allModelParameters] = deepinterp.listPretrainedModels();

if nargin<1,
	filename = allModelNames;
	return;
end;

idx = find(strcmpi(modelName,allModelNames));

if isempty(idx),
	error(['No match for ' modelName ' in known models.']);
end;

parameters = allModelParameters(idx);

filename = fullfile(deepinterp.toolboxpath,'pretrainedModels',parameters.filename);

if ~isfile(filename),
	% try to download
	FileURL = parameters.url;
	disp(['Downloading pretrained model...']);
	try,
		websave(filename,FileURL);
	catch,
		error(['Error downloading model.']);
		throw(ex);
	end;
end;

