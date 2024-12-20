function cb = NPframe2checkerboard(frame)
% NPFRAME2CHECKERBOARD - convert raw Neuropixels Phase 3 to geometrically realistic matrix 
%
% CB = NPframe2checkerboard(FRAME)
%
% Convert Neuropixels data frame data FRAME (192 x 2 x NSAMPLES)
% into a geometrically-realistic matrix that reflects the checkerboad
% layout of electrodes such as the Phase 3 version.
% 
% CB will be a 384 x 2 x NSAMPLES matrix where every even linear index
% will be 0.
%
% For example, the following single-frame example input where each data point has
% been set, for illustration purposes, to the electrode number (incremented by 0.5)
% would be transformed as follows:
%
%    1.0000    1.5000
%    2.0000    2.5000
%    3.0000    3.5000
%    ...
%    189.0000  189.5000
%    190.0000  190.5000
%    191.0000  191.5000
%
% to
%
%    1.0000         0
%         0    1.5000
%    2.0000         0
%         0    2.5000
%    3.0000         0
%         0    3.5000
%...
%  190.0000         0
%         0  190.5000
%  191.0000         0
%         0  191.5000
%  192.0000         0
%         0  192.5000

cb = zeros(size(frame,1)*2,size(frame,2),size(frame,3));

odd = 1:2:size(frame,1)*2;
even = odd + 1;

cb(odd,1,:) = frame(:,1,:);
cb(even,2,:) = frame(:,2,:);

