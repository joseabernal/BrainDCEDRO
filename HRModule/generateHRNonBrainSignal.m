%% Create high resolution non-brain time series
%  Using the spatial distribution information given by the high resolution
%  tissue map, this function assigns the signal profiles to non-brain
%  structures.
%  
%  Inputs:
%  - HR_tissue_map: 3D high resolution segmentation map
%  - SI_nonbrain: 2D matrix with signal profile for non-brain structures
%  - NTrue: Dimension of image that defines the "true" object
%  - NFrames: Number of frames
%
%  Outputs:
%   - HR_SI_nonbrain: 4D high resolution signal-time curves for non-brain
%                     structures
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function HR_SI_nonbrain = generateHRNonBrainSignal(HR_tissue_map, SI_nonbrain, NTrue, NFrame)
    HR_tissue_map = reshape(HR_tissue_map, [numel(HR_tissue_map), 1]);

    HR_SI_nonbrain = zeros([numel(HR_tissue_map), NFrame]);
    for seg_class_idx = 1:size(SI_nonbrain, 1)
        seg_class = SI_nonbrain(seg_class_idx, 1);

        HR_SI_nonbrain(HR_tissue_map == seg_class, :) = ...
            repmat(SI_nonbrain(seg_class_idx, 2:2:end), [sum(HR_tissue_map == seg_class), 1]);
    end
    
    HR_SI_nonbrain = reshape(HR_SI_nonbrain, [NTrue, NFrame]);
end