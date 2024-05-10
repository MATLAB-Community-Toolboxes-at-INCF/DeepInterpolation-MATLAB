classdef Net 

	properties (SetAccess=protected)
		network % Deep learning network
	end


	methods
		function obj = Net(command,options)
			% NET - create a new deepinterp.Net object
			%
			% OBJ = NET(COMMAND,...)
			%
			% Create a new deepinterp.Net object according to instructions.
			% COMMAND can be:
			%
			% 'KerasFile': open and import a Keras file
			% 'New'      : create a new empty network
			%
			% The function also accepts additional arguments as name/value pairs:
			% --------------------------------------------------------------------
			% | Parameter (default)     | Description                            |
			% |-------------------------|----------------------------------------|
			% | file ('')               | Filename to open if reading a file     |
			% |-------------------------|----------------------------------------|
			%
			% Example:
			%   n = deepinterp.Net('KerasFile','file','myKerasFile.H5');
			%
				arguments
					command (1,:) char {mustBeTextScalar}
					options.file (1,:) char {mustBeFile}
				end

				switch (command),
					case 'KerasFile',
						obj.network=deepinterp.internal.importKerasMAE(options.file);
					case 'New',
						% nothing to do
					otherwise,
						error(['Unknown command: ' command]);
				end;

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

		end; % train()

		function output = interp(net_obj, inputs)
			% INTERP - apply DeepInterpolation
			%
			% OUTPUT = INTERP(NET_OBJ, INPUT)
			%
			% Apply the DeepInterpolation network to the
			% INPUT data.
			%
			% Subclasses should describe the form of the input
			% and output.
			%

		end; % interp()
	end;

end % classdef

