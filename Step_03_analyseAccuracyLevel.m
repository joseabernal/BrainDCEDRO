%% Analyse the level of distortion
%  This script permits analysing the level of distortion on the permeability maps using
%  voxel-wise and region-wise strategies and explore ways to compensate for them.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

clc;
clear all;
close all;

% set configuration (paths)
setConfig;

% set parameters
setParameters;

output_folder = 'output';

% generate low res segmentation map
LR_tissue_map = generateLRSegMap(LR_seg_fname);

% erode segmentation map
if apply_erosion
    LR_tissue_map = erode_seg_map(LR_tissue_map, erosion_extent, NumRegions);
end

% Results are stored in these two variables. The first, second, and third
% dimensions correspond to the patient number, region of interest, and both
% PS and vP.
parameter_averaging_results = zeros(size(dataset, 1), NumRegions, 2);
signal_averaging_results = zeros(size(dataset, 1), NumRegions, 2);
for experiment_idx = 1:205
    LR_SI_fname = [output_folder, filesep, 'LR_SI_', num2str(experiment_idx), '_mcf_tf.nii.gz'];

    if ~exist(LR_SI_fname, 'file')
        continue
    end
    
    disp(experiment_idx)
    
    % read low resolution (acquired) image data
    LR_SI = niftiread(LR_SI_fname);

    % mask low resolution to obtain signal of brain tissues only
    LR_SI = LR_SI .* (LR_tissue_map > 1 & (LR_tissue_map < 7 | LR_tissue_map == 14));
    
    % calculate PS and vp voxel-wise
    [LR_PS_perMin_voxel_wise, LR_vP_voxel_wise] = fitLRData(...
        LR_SI, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NAcq, false, regression_type);

    % summarise PS and vP values per region of interest
    LR_PS_perMin_parameter_averaging = organiseParamsPerROI(...
        LR_PS_perMin_voxel_wise, LR_tissue_map, NumRegions);
    LR_vP_dense_parameter_averaging = organiseParamsPerROI(...
        LR_vP_voxel_wise, LR_tissue_map, NumRegions);

    % evaluate deviation using the parameter averaging approach
    parameter_averaging_results(experiment_idx, :, :) = evaluateDeviation(...
        LR_PS_perMin_parameter_averaging, LR_vP_dense_parameter_averaging, PS_perMin, vP, NumRegions);
    
    % save PS and vP maps
    save_scan({LR_PS_perMin_voxel_wise, LR_vP_voxel_wise}, ...
        {['LR_PS_perMin_', num2str(experiment_idx)], ['LR_vP_', num2str(experiment_idx)]}, ...
        NAcq, output_folder, LRes_mm);
    
    % summarise signal per region of interest
    LR_SI_signal_averaging = summariseSIPerROI(...
        LR_SI, LR_tissue_map, NAcq, NFrames, NumRegions);

    % calculate PS and vp region-wise
    [LR_PS_perMin_signal_averaging, LR_vP_signal_averaging] = fitLRData(...
        LR_SI_signal_averaging, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NAcq, true, regression_type);    
    
    % evaluate deviation using the signal averaging approach
    signal_averaging_results(experiment_idx, :, :) = evaluateDeviation(...
        LR_PS_perMin_signal_averaging, LR_vP_signal_averaging, PS_perMin, vP, NumRegions);
end