function frame = checkerboard2NPframe(cb)
% CHECKERBOARD2NPFRAME - convert geometrically realistic matrix to raw Neuropixels Phase 3 format
%
% FRAME = CHECKERBOARD2NPFRAME(CB)
%
% Convert geometrically-realistic matrix data CB (384 x 2 x NSAMPLES)
% into a format that matches the raw data output of Neuropixels Phase 3
% probes. CB is expected to reflect the checkerboard layout of electrodes,
% where every even linear index is 0.
%
% FRAME will be a 192 x 2 x NSAMPLES matrix.
%
% For example, the following single-frame example input where each data point has
% been set, for illustration purposes, to the electrode number (incremented by 0.25)
% would be transformed as follows:
%
%    1.0000         0
%         0    1.2500
%    2.0000         0
%         0    2.2500
%    3.0000         0
%         0    3.2500
%    ...
%  190.0000         0
%         0  190.2500
%  191.0000         0
%         0  191.2500
%  192.0000         0
%         0  192.2500
%
% to
%
%    1.0000    1.2500
%    2.0000    2.2500
%    3.0000    3.2500
%    ...
%    189.0000  189.2500
%    190.0000  190.2500
%    191.0000  191.2500
%    192.0000  192.2500

% Check input dimensions
if size(cb, 1) ~= 384 || size(cb, 2) ~= 2
  error('Input matrix CB must be 384 x 2 x NSAMPLES.');
end

frame = zeros(size(cb,1)/2, size(cb,2), size(cb,3));
odd = 1:2:size(cb,1);
even = odd + 1;
frame(:,1,:) = cb(odd,1,:);
frame(:,2,:) = cb(even,2,:);







