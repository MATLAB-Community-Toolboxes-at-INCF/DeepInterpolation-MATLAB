function base_folder = setup()
    % Add current directory and sample_data, layers and examples to path
    base_folder = fileparts(mfilename('fullpath'));
    addpath(base_folder);
    addpath(fullfile(base_folder, "network_layers"))
    addpath(fullfile(base_folder, "sample_data"))
    addpath(fullfile(base_folder, "examples"))
    addpath(fullfile(base_folder, "internal"))
    addpath(fullfile(base_folder, "datastore"))
end
