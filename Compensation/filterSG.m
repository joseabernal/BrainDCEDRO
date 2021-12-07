%% Smooth signal-time curves using Savitzky-Golay filtering
%  Smooth signal-time curves using Savitzky-Golay filtering
%  
%  Inputs:
%  - SI: signal-time curves
%  - order: order of the Savitzky-Golay filter
%  - framelen: frame length of the Savitzky-Golay filter
%  - NIgnore: number of frames to ignore during fitting

%  Outputs:
%   - SI_filt: filtered signal-time curves
%
% (c) Jose Bernal 2021

function SI_filt = filterSG(SI, order, framelen, NIgnore)
    SI_filt = sgolayfilt(double(SI(:, NIgnore:end)), order, framelen, [], 2);
    
    SI_filt = [SI(:, 1:NIgnore-1), SI_filt];
end