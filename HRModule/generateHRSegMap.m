%% Generate high resolution region segmentation map
%  Reads the high resolution segmentation map. Please make sure you have
%  tuned the tissue characteristics prior to using this function.
%  
%  Inputs:
%  - seg_fname: filename of the segmentation map
%
%  Outputs:
%   - HR_tissue_map: 3D high resolution segmentation map
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function [HR_tissue_map] = generateHRSegMap(seg_fname)
    HR_tissue_map = niftiread(seg_fname); % Load ground truth
    
%     HR_tissue_map = niftiread('input/HR_tissue_map_orig.nii.gz');
%     HR_tissue_map = padarray(HR_tissue_map(:, 141:end, :), [0, 70, 65], 1, 'both');
%     save_scan({HR_tissue_map}, {'HR_tissue_map'}, [480, 480, 480], 'input', [240, 240, 240])
end