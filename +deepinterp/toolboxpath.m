function toolboxFolderPath = toolboxpath()
% TOOLBOXPATH - return the toolbox path for DeepInterpolation Toolbox
%
% TOOLBOXFOLDERPATH = TOOLBOXPATH()
%
% Return the toolbox path.  (Imitated from Brain Observatory Toolbox.)
%

	thisFolderPath = fileparts(mfilename('fullpath'));
	toolboxFolderPath = fileparts(thisFolderPath);
