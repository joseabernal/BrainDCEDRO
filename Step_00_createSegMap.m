%% Create segmentation maps
%  This script maps the 116 classes in the original MIDA model to 17 used in
%  our work, creating the high resolution map. It also generates a
%  low-resolution version using our resampler function.
%
%  1  - Background
%  2  - Cerebrospinal fluid
%  3  - Normal-appearing white matter
%  4  - White matter hyperintensity
%  5  - Recent stroke lesion
%  6  - Cortical grey matter
%  7  - Meninges
%  8  - Muscles and eyes
%  9  - Mandible and vertebrae
%  10 - Skull diploe
%  11 - Skull outer table
%  12 - Skull inner table
%  13 - Blood vessels
%  14 - Deep grey matter
%  15 - Skin
%  16 - Adipose tissue
%  17 - Eyes
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

clc;
clear all;
close all;

% set configuration (paths)
setConfig;

% set parameters
setParameters;

%% Generate high-resolution map
% Load variable containing the mapping between the original 116 labels to 15
load(['input', filesep, 'mapping.mat']);

% Load MIDA model and masks
original_segmap = niftiread(['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_v1.nii']);
WMH_segmap = niftiread(['input', filesep, 'Masks', filesep, 'WMH_mask.nii.gz']);
RSL_segmap = niftiread(['input', filesep, 'Masks', filesep, 'RSL_mask.nii.gz']);

% Map tissues
HR_tissue_map = zeros(size(original_segmap));
for c=1:size(mapping,1)
    HR_tissue_map(original_segmap == c) = mapping(c, 2);
end

% Add pathological tissues to the segmentation mask
HR_tissue_map(WMH_segmap == 1 & HR_tissue_map ~= 2) = 4;
HR_tissue_map(RSL_segmap == 1) = 5;

HR_tissue_map = padarray(HR_tissue_map(:, 141:end, :), [0, 70, 65], 1, 'both');

% Save HR tissue map
save_scan({uint16(HR_tissue_map)}, {'HR_tissue_map'}, NTrue, 'input', HRes_mm)

%% Generate low-resolution map
% This part is an alternative approach to obtain a version of the low-resolution
% segmentation map. Registration between high-resolution and low-resolution
% images can be used instead.

LR_tissue_map = zeros([NAcq, NumRegions]);
for c=1:NumRegions
    LR_tissue_map(:, :, :, c) = abs(generateImageSpace(resample(...
        double(HR_tissue_map==c), FOV_mm_True, NTrue, FOV_mm_Acq, NAcq, 1), 1));
end

[~, LR_tissue_map] = max(LR_tissue_map, [], 4);

% Save LR tissue map
save_scan({uint16(LR_tissue_map)}, {'LR_tissue_map'}, NAcq, 'input', LRes_mm);