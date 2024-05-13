function base_folder = setup()
    % Add current directory and sample_data, layers and examples to path
    base_folder = deepinterp.toolboxpath();
    deepinterp.setup();
end
