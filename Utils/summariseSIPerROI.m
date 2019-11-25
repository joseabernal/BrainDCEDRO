%% Summarise signal per region of interest
%  Summarise signal per region of interest
%  
%  Inputs:
%  - LR_SI: 4D DCE-MRI signal
%  - LR_tissue_map: 3D segmentation map
%  - NAcq: Number of points acquired
%  - NFrames: Number of frames
%  - NumRegions: Number of regions in segmentation map

%  Outputs:
%   - ROI_SI: signal-time curves per region of interest
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function ROI_SI = summariseSIPerROI(LR_SI, LR_tissue_map, NAcq, NFrames, NumRegions)
    LR_SI = reshape(LR_SI, [prod(NAcq), NFrames]);

    ROI_SI = zeros(NumRegions, NFrames);
    for region=1:NumRegions
        mask = reshape(LR_tissue_map == region, [prod(NAcq), 1]);

        ROI_SI(region, :) = nanmean(LR_SI(mask, :), 1);
    end
end