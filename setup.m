function setup()
    % Add current directory and sample_data, layers and exmamples to path
    setup_path = fileparts(mfilename('fullpath'));
    addpath(setup_path);
    addpath(fullfile(setup_path, "network_layers"))
    addpath(fullfile(setup_path, "sample_data"))
    addpath(fullfile(setup_path, "examples"))
end