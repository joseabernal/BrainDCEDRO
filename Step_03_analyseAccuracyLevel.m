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

LR_tissue_map = generateLRSegMap(LR_seg_fname); % generate low res segmentation map

if apply_erosion
    LR_tissue_map = erode_seg_map(LR_tissue_map, [3,4,5,6], erosion_extent, NumRegions);
end

experiment_results = zeros(size(dataset, 1), 2, 16, 6);
for experiment_idx = 4
    disp(experiment_idx)

    % read low resolution (acquired) image data    
    if ~apply_motion_correction
        LR_fname = [output_folder, filesep, 'LR_SI_', num2str(experiment_idx)];
        
        LR_SI_dense = niftiread(LR_fname);
    else
        LR_corr_fname = [output_folder, filesep, 'LR_SI_', num2str(experiment_idx), '_mcf.nii.gz'];
    
        LR_SI_dense = niftiread(LR_corr_fname);
    end        

    % mask low resolution to obtain signal of regions of interest
    LR_SI_dense = LR_SI_dense .* (LR_tissue_map > 1 & (LR_tissue_map < 7 | LR_tissue_map == 14));
    
    % fit PS and vp
    [LR_PS_perMin_dense, LR_vP_dense] = fitLRData(...
        LR_SI_dense, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NAcq, false, regression_type);

    save_scan({LR_PS_perMin_dense, LR_vP_dense}, ...
        {['LR_PS_perMin_', num2str(experiment_idx)], ['LR_vP_', num2str(experiment_idx)]}, ...
        NAcq, output_folder, LRes_mm);
    
    % summarise signal per region of interest
    LR_SI_region = summariseSIPerROI(...
        LR_SI_dense, LR_tissue_map, NAcq, NFrames, NumRegions);

    % fit PS and vp
    [LR_PS_perMin_region, LR_vP_region] = fitLRData(...
        LR_SI_region, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NAcq, true, regression_type);

    LR_PS_perMin_dense_summ = organiseParamsPerROI(LR_PS_perMin_dense, LR_tissue_map, NumRegions);
    LR_vP_dense_summ = organiseParamsPerROI(LR_vP_dense, LR_tissue_map, NumRegions);
    
    % evaluate deviation
    experiment_results(experiment_idx, 1, :, :) = evaluateDeviation(...
        LR_PS_perMin_dense_summ, LR_vP_dense_summ, PS_perMin, vP, NumRegions);
    experiment_results(experiment_idx, 2, :, :) = evaluateDeviation(...
        LR_PS_perMin_region, LR_vP_region, PS_perMin, vP, NumRegions);
end