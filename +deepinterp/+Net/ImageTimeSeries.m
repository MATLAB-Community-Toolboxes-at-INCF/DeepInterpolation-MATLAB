classdef ImageTimeSeries < deepinterp.Net

	properties (GetAccess=public, SetAccess=protected)
		N % number of rows of inputs to the network
		M % number of columns of inputs to the network
		Npre % Number of input frames needed before the predicted frame
		Npost % Number of input frames needed after the predicted frame
	end


	methods

		function obj = ImageTimeSeries(command, options)
			% OBJ = NET(COMMAND,...)
			%
			% Create a new deepinterp.Net.ImageTimeSeries object.
			%
			% deepinterp.Net.ImageTimeSeries objects remove independent
			% frame-by-frame noise in image sequences that are usually time
			% series. The network takes Npre video frames _before_ the frame
			% to be denoised, and Npost video frames _after_ the frame to be
			% denoised, to make a computational prediction of the denoised
			% frame.
			%
			% COMMAND can be:
			%
			% 'New'      : create a new empty network
			% 'KerasFile': open and import a Keras file
			%
			% The function also accepts additional arguments as name/value pairs:
			% --------------------------------------------------------------------
			% | Parameter (default)     | Description                            |
			% |-------------------------|----------------------------------------|
			% | file ('')               | Filename to open if reading a file     |
			% | N (512)                 | Number of rows in images if new network|
			% | M (512)                 | Number of columns in images for new net|
			% | Npre (30)               | Number of frames before prediction     |
			% | Npost (30)              | Number of frames after prediction      |
			% |-------------------------|----------------------------------------|
			%
			% Example:
			%   sampleNet = deepinterp.sampleFile(...
			%      '2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5');
			%   n = deepinterp.Net.ImageTimeSeries('KerasFile','file',sampleNet,...
			%      'Npre',30,'Npost',30);
			%
				arguments
					command (1,:) char {mustBeTextScalar}
					options.file (1,:) char {mustBeFile}
					options.N (1,1) double {mustBeInteger} = 512;
					options.M (1,1) double {mustBeInteger} = 512;
					options.Npre (1,1) double {mustBeInteger} = 30;
					options.Npost (1,1) double {mustBeInteger} = 30;
				end

				superOptions = rmfield(options,{'N','M','Npre','Npost'});
				superInputs = cat(2,{command},...
					deepinterp.internal.struct2namevaluepair(superOptions));
				obj = obj@deepinterp.Net(superInputs{:});
				obj.Npre = options.Npre;
				obj.Npost = options.Npost;

				if strcmp(command,'New'),
					disp(['In future we will build a net network here.']);
				end;

				obj = obj.SetInputSize();

		end; % ImageTimeSeries - constructor

		function obj = SetInputSize(obj)
			% SETINPUTSIZE - set the input size properties
			%
			% OBJ = SETINPUTSIZE(OBJ) 
			%
			% Sets the input size properties N and M, and verifies that
			% the number of image sequences required in each input add up to 
			% obj.Npre and obj.Npost.
			%
			% The values can be examined by OBJ.N, OBJ.M.
			%
				if isempty(obj.network),
					obj.N = NaN;
					obj.M = NaN;
				else,
					inSz = obj.network.Layers(1).InputSize;
					obj.N = inSz(1);
					obj.M = inSz(2);
					assert(inSz(3)==obj.Npre+obj.Npost,...
						['Npre + Npost must add up to the total ' ...
						'number of image inputs to ' ...
						'deepinterp.net.ImageTimeSeries.']);
				end;
		end; % SetInputSize

		function output = interp(obj, input, options)
			% INTERP - apply DeepInterpolation to inputs
			%
			% OUTPUT = INTERP(DEEPINTERP_IMAGETIMESERIES_OBJ, INPUT)
			%
			% Apply the DeepInterpolation network to the INPUT data.
			% INPUT should be an NxMxT matrix, where N and M match
			% the size of the DEEPINTERP_IMAGETIMESERIES_OBJ.N and .M parameters,
			% and T must be greater than the Npre + Npost property values of
			% DEEPINTERP_IMAGETIMESERIES_OBJ. Interpolation will only be performed
			% for frames greater than Npre and less than numel(T) - Npost. The first
			% Npre frames and last Npost frames will be equal to the input.
			%
				arguments
					obj (1,1)
					input 
					options.progbar (1,1) logical = true;
				end

				output = input;
				offsets = [-obj.Npre:-1 1:obj.Npost];
				if options.progbar,
					deepinterp.internal.progressbar();
				end;
				totalWork = size(input,3)-(obj.Npost+obj.Npre);
				for t = obj.Npre+1 : size(input,3) - obj.Npost,
					if options.progbar,
						deepinterp.internal.progressbar((t-(obj.Npre+1))/totalWork);
					end;
					output(:,:,t) = predict(obj.network,input(:,:,offsets+t));
				end;
				if options.progbar,
					progressbar(0.9999999999);
				end;
                end; % interp()

			% INTERP - apply DeepInterpolation 


	end; % methods

end % classdef
