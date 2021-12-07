%% Smooth signal-time curves using Savitzky-Golay filtering
%  Smooth signal-time curves using Savitzky-Golay filtering
%  
%  Inputs:
%  - SI: signal-time curves
%  - NAcq: number of points acquired
%  - NFrames: number of time frames
%  - order: order of the Savitzky-Golay filter
%  - framelen: frame length of the Savitzky-Golay filter

%  Outputs:
%   - SI_filt: filtered signal-time curves
%
% (c) Jose Bernal 2021

function SI_filt = filterSG(SI, NAcq, NFrames, order, framelen)
    SI = reshape(SI, [prod(NAcq), NFrames]);
    
    SI_valid_idx = sum(SI, 2) ~= 0;
    SI_valid = SI(SI_valid_idx, :);
    
    SI_valid_filt = sgolayfilt(double(SI_valid(:, 3:end)), order, framelen, [], 2);
    
    SI_valid_filt = [SI_valid(:, 1:2), SI_valid_filt];
    
    SI_filt = zeros([prod(NAcq), NFrames]);
    SI_filt(SI_valid_idx == 1, :) = SI_valid_filt;
    
    SI_filt = reshape(SI_filt, [NAcq, NFrames]);
end