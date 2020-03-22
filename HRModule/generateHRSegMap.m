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

%SEEMS ODD TO USE A 1-LINE FUNCTION...BUT IM SURE YOU KNOW WHAT YOU'RE DOING!

function [HR_tissue_map] = generateHRSegMap(seg_fname)
    HR_tissue_map = niftiread(seg_fname); % Load ground truth
end
