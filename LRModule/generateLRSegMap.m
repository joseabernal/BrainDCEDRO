%% Generate 3D low resolution segmentation map
%  Generate 3D low resolution segmentation map from a high resolution
%  segmentation map
%  
%  Inputs:
%  - seg_fname: filename of low resolution segmentation map
%  Outputs:
%   - LR_tissue_map: Low resolution segmentation map
%
% (c) Jose Bernal and Michael J. Thrippleton 2019


function [LR_tissue_map] = generateLRSegMap(seg_fname)
    LR_tissue_map = niftiread(seg_fname); % Load ground truth
end