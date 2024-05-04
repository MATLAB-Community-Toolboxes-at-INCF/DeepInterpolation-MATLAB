function toolboxFolderPath = toolboxdir()
% TOOLBOXDIR - return the toolbox path for DeepInterpolation Toolbox
%
% TOOLBOXFOLDERPATH = TOOLBOXDIR()
%
% Return the toolbox path.  (Imitated from Brain Observatory Toolbox.)
%

	thisFolderPath = fileparts(mfilename('fullpath'));
	toolboxFolderPath = fileparts(thisFolderPath);
