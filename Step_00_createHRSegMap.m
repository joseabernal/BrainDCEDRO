%% Map classes in the original MIDA model to those used in the paper
%  Map 116 classes in the original MIDA model to 17 used in the paper
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

% Load variable containing the mapping between the original 116 labels to 15
load(['input', filesep, 'mapping.mat']);

% Load MIDA model and masks
original_segmap = niftiread(['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_v1.nii']);
WMH_segmap = niftiread(['input', filesep, 'Masks', filesep, 'WMH_mask.nii.gz']);
RSL_segmap = niftiread(['input', filesep, 'Masks', filesep, 'RSL_mask.nii.gz']);

% Map tissues
modified_segmap = zeros(size(original_segmap));
for c=1:size(mapping,1)
    modified_segmap(original_segmap == c) = mapping(c, 2);
end

% Add pathological tissues to the segmentation mask
modified_segmap(WMH_segmap == 1 & modified_segmap ~= 2) = 4;
modified_segmap(RSL_segmap == 1) = 5;

modified_segmap = padarray(modified_segmap(:, 141:end, :), [0, 70, 65], 1, 'both');

% Save tissue map
save_scan({uint16(modified_segmap)}, {'HR_tissue_map'}, NTrue, 'input', [0.5, 0.5, 0.5])