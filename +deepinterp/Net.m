classdef Net 

	properties (SetAccess=protected)
		network % Deep learning network
	        networkType % The type of network to create
		N % number of rows of inputs to the network
		M % number of columns of inputs to the network
		Npre % Number of input frames needed before the predicted frame
		Npost % Number of input frames needed after the predicted frame
	        Nomit % Number of omitted frames for the prediction
	        modelParameters % Parameters of the model, if applicable
	end


	methods
		function obj = Net(command,options)
			% NET - create a new deepinterp.Net object
			%
			% OBJ = NET(COMMAND,...)
			%
			% Create a new deepinterp.Net object according to instructions.
			% COMMAND can be any of the following:
			%
			% 'New'            : create a new network (under development)
			% 'KerasFile'      : open and import a Keras file
			% 'TensorFlowZip'  : open a TensorFlow zip file
			% 'Pretrained'     : Open a pretrained model in DeepInterpolation
			%
			% The function also accepts additional arguments as name/value pairs:
			% --------------------------------------------------------------------
			% | Parameter (default)     | Description                            |
			% |-------------------------|----------------------------------------|
			% | file ('')               | Filename to open if reading a file     |
			% | type ('two-photon')     | Type of data the network operates on   |
			% |                         |   options are 'two-photon', 'ephys',   |
			% |                         |   'fMRI', 'other'.                     |
			% | model ('TP-Ai93-450')   | When a pretrained model is requested,  |
			% |                         |   use this named model. For a list of  |
			% |                         |   available models, use                |
			% |                         |   deepinterp.listPretrainedModels()    |
			% | N (512)                 | N (first dimension of input)           |
			% | M (512)                 | M (second dimension of input)          |
			% | Nomit (1)               | Number of frames to omit in prediction |
			% | Npre (30)               | Number of frames before the predicted  |
			% |                         |    frame that are used to generate the |
			% |                         |    prediction                          |
			% | Npost (30)              | Number of frames after the predicted   |
			% |                         |    frame that are used to generate the |
			% |                         |    prediction                          |
 			% |-------------------------|----------------------------------------|
			%
			% Examples:
			%   n1 = deepinterp.Net('Pretrained','model','TP-Ai93-450');
			%   n2 = deepinterp.Net('KerasFile','file','myKerasFile.H5');
			%   n3 = deepinterp.Net('TensorFlowZip','file','myTFFile.zip','model','ModelABC');
			%
				arguments
					command (1,:) char {mustBeTextScalar}
					options.file (1,:) char {mustBeFile}
					options.type (1,:) char {mustBeMember(options.type,{'two-photon','ephys','fMRI','other'})} = 'two-photon'
					options.model (1,:) char {mustBeTextScalar} = 'TP-Ai93-450'
					options.N (1,1) double {mustBeInteger} = 512
					options.M (1,1) double {mustBeInteger} = 512
					options.Npre (1,1) double {mustBeInteger} = 30
					options.Npost (1,1) double {mustBeInteger} = 30
					options.Nomit (1,1) double {mustBeInteger} = 1
					options.modelParameters (1,1) struct = struct('none',[])
				end

				networkType = options.type;

				switch (lower(command)),
					case 'new',
						% nothing to do yet
						error(['NEW option still under development.']);
					case 'kerasfile',
						obj.network=deepinterp.internal.importKerasMAE(options.file);
					case 'tensorflowzip',
						obj.network=deepinterp.internal.openTensorFlowNetwork(options.file,matlab.lang.makeValidName(options.model));
					case 'pretrained',
						[modelfilename, modelparams] = deepinterp.internal.getPretrainedModelFilename(options.model);
						obj = deepinterp.Net(modelparams.format,'file',modelfilename,...
							'N',modelparams.dim(1),'M',modelparams.dim(2),...
							'Npre',modelparams.pre,'Npost',modelparams.post,'Nomit',modelparams.omit,...
							'type',modelparams.type,...
							'modelParameters',modelparams.parameters,'model',options.model);
						return;
					otherwise,
						error(['Unknown command: ' command]);
				end;

				obj.networkType = networkType;
				obj.Npre = options.Npre;
				obj.Npost = options.Npost;
				obj.Nomit = options.Nomit;
				obj.modelParameters = options.modelParameters;
				obj = obj.SetInputSize();

		end; % Net constructor

		function net_obj = train(net_obj, inputs, outputs)
			% TRAIN - train a DeepInterpolation network
			%
			% NET_OBJ = TRAIN(NET_OBJ, INPUTS, OUTPUTS)
			%
			% Train a deepinterp.Net object with example
			% INPUTS and OUTPUTS.
			%
			% Subclasses should describe the form of these inputs
			% and outputs.
			%
				error('Training function in the object framework is not yet developed.');
		end; % train()

		function output = interp(obj, input, options)
			% INTERP - apply DeepInterpolation to inputs
			%
			% OUTPUT = INTERP(DEEPINTERP_NET_OBJ, INPUT)
			%
			% Apply the DeepInterpolation network to the INPUT data.
			% INPUT should be an NxMxT matrix, where N and M match
			% the size of the DEEPINTERP_NET_OBJ.N and .M parameters,
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
				Nomit_pre =  (obj.Nomit+1)/2;
				Nomit_post = (obj.Nomit+1)/2;              
				offsets = [ fliplr(-[Nomit_pre:obj.Npre+Nomit_pre-1]) Nomit_post:obj.Npost+Nomit_post-1];
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
					deepinterp.internal.progressbar(0.9999999999);
				end;
		end; % interp()

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
	end;

end % classdef

