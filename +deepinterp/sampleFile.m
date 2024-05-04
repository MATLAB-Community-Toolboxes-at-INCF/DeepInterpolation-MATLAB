function fileName = sampleFile(sampleFileName)
% SAMPLEFILE - retreive a sample data file or model file for DeepInterpolation toolbox
%
% FILENAME = SAMPLEFILE(SAMPLEFILENAME)
%
% Return the full path FILENAME of a SAMPLEFILENAME. If the file is an existing example in the
% sampleData directory, then the full filename is provided. If it is a known item that
% that needs to be downloaded, the file will be downloaded first. Otherwise, the function
% will return an error.
%

base_folder = deepinterp.toolboxdir;

fileName = fullfile(base_folder,'sampleData',sampleFileName);

if ~isfile(fileName),

	switch sampleFileName,
		case '2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5',

			dropboxFileURL = 'https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=1';
    			destinationFile = fullfile(base_folder,'sampleData',sampleFileName);
			disp(['Downloading trained model...']);
			try,
				websave(fileName, dropboxFileURL);
			catch,
				disp(['Error downloading model.']);
				throw(ex);
			end;
		otherwise,
			error(['Unknown sample file ' sampleFileName '.']);
	end;
end;
