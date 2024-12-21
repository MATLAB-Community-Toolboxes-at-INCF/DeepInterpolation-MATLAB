
% this script was made to explore the input/output requirements of the
% pretrained neuropixels network

E = [[1:192]' [1:192]'+0.5]; % number electrodes by Y (whole number) and X 2*(mod 1)

NP = repmat(E,1,1,500); % 500 frames of data 
  % now transpose to be the same as the expected neuropixels data
NP = permute(NP, [3 1 2]);

nb_probes = 384; % Number of probes

pre_post_omission = 3; % Number of frames omitted before and after the inferred frame

pre_frame = 30;  % Number of frames provided before the inferred frame
post_frame = 30; % Number of frames provided after the inferred frame

batch_size = 100;

start_frame = 100;

end_frame = 200;


input_full = single(zeros(batch_size, nb_probes, 2, pre_frame + post_frame));


for frame_index = start_frame:end_frame
    
    input_index = (frame_index - pre_frame - pre_post_omission) : (frame_index + post_frame + pre_post_omission );
    
    input_index = input_index(input_index ~= frame_index);   % drop the predicted frame 

    for index_padding = 1: pre_post_omission % drop pre_post_omission number of frames surrounding the predicted frame
        input_index = input_index(input_index ~= frame_index - index_padding);
        input_index = input_index(input_index ~= frame_index + index_padding);
    end

    data_img_input = ephys(input_index, :, :);
    
    data_img_input = permute(data_img_input,[2,3,1]);
    
    data_img_input = (single(data_img_input) - local_mean) / local_std;
    
    % alternating filling with zeros padding
    odd = 1: 2: nb_probes;
    even = odd + 1;
    
    input_full(frame_index-start_frame+1, odd, 1, :) = data_img_input(:, 1, :);
    input_full(frame_index-start_frame+1, even, 2, :) = data_img_input(:, 2, :);
 

end


