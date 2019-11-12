%% Generate high resolution region segmentation map
function [HR_tissue_map, LR_tissue_map] = generateHRSegMap(seg_fname, NTrue, NAcq)
    %%Load ground truth
    HR_tissue_map = imresize3(double(niftiread(seg_fname)), NTrue, 'nearest');

    LR_tissue_map = uint8(imresize3(HR_tissue_map, NAcq, 'nearest'));
end