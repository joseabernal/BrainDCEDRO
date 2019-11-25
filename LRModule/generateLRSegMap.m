%% Generate 3D low resolution segmentation map
%  Generate 3D low resolution segmentation map from a high resolution
%  segmentation map
%  
%  Inputs:
%  - seg_fname: filename of high resolution segmentation map
%  - NAcq: Number of points acquired
%  - NDiscard: Number of k-space points to discard on either side when computing the acquired data
%  - NumRegions: Number of regions of interest

%  Outputs:
%   - LR_tissue_map: Low resolution segmentation map
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function [LR_tissue_map] = generateLRSegMap(seg_fname, NAcq, NDiscard, NumRegions)
    %%Load ground truth
    HR_tissue_map = niftiread(seg_fname);
    
    background_map = imresize3(double(HR_tissue_map==1), NAcq, 'nearest');

    LR_tissue_map = zeros([NAcq, NumRegions]);
    for c = 1:NumRegions
        HR_tissue_mask = imgaussfilt(double(HR_tissue_map == c));
        HR_tissue_mask = fftshift(ifftn(ifftshift(HR_tissue_mask)));
        LR_tissue_mask = HR_tissue_mask(NDiscard(1)+1:NDiscard(1)+NAcq(1),NDiscard(2)+1:NDiscard(2)+NAcq(2),NDiscard(3)+1:NDiscard(3)+NAcq(3));
        LR_tissue_mask = ifftshift(fftn(fftshift(LR_tissue_mask)));
        LR_tissue_map(:, :, :, c) = LR_tissue_mask;
    end
    [~, LR_tissue_map] = max(LR_tissue_map(:, :, :, 2:end), [], 4);
    LR_tissue_map = uint8(LR_tissue_map .* ~background_map)+1;
end

