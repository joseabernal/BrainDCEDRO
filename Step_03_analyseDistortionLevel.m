%% Analyse the level of distortion
%  This script permits analysing the level of distortion on the permeability maps using
%  voxel-wise and region-wise strategies and explore ways to compensate for them.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

clc;
clear all;
close all;

maxNumCompThreads(15);

setConfig; % set configuration (paths)
setParameters; % set parameters

LR_tissue_map = generateLRSegMap(seg_fname, NAcq, NDiscard, NumRegions); % generate low res segmentation map

if erosion_extent ~= 0
    LR_tissue_map = erode_seg_map(LR_tissue_map, [3,4,5,6], erosion_extent, NumRegions);
end

experiment_results = zeros(size(dataset, 1), 2, 13, 6);
for experiment_idx = 1:size(dataset, 1)
    % generate low resolution (acquired) image data
    fname = ['LR_SI_', num2str(experiment_idx)];
    LR_corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    
    LR_SI_dense = niftiread(LR_corr_fname);

    % mask low resolution to obtain signal of regions of interest
    LR_SI_dense = LR_SI_dense .* (LR_tissue_map > 1 & LR_tissue_map < 7);
    
    % fit PS and vp
    [LR_PS_perMin_dense, LR_vP_dense] = fitLRData(...
        LR_SI_dense, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NDes, false, regression_type);

    save_scan({LR_PS_perMin_dense, LR_vP_dense}, {['LR_PS_perMin_', num2str(experiment_idx)], ['LR_vP_', num2str(experiment_idx)]}, NAcq, output_folder, LRes_mm);
    
    % summarise signal per region of interest
    LR_SI_region = summariseSIPerROI(...
        LR_SI_dense, LR_tissue_map, NAcq, NFrames, NumRegions);

    % fit PS and vp
    [LR_PS_perMin_region, LR_vP_region] = fitLRData(...
        LR_SI_region, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
        r1_perSpermM,r2_perSpermM, t_res_s, NDes, true, regression_type);

    LR_PS_perMin_dense_summ = organiseParamsPerROI(LR_PS_perMin_dense, LR_tissue_map, NumRegions);
    LR_vP_dense_summ = organiseParamsPerROI(LR_vP_dense, LR_tissue_map, NumRegions);
    
    % evaluate deviation
    experiment_results(experiment_idx, 1, :, :) = evaluateDeviation(...
        LR_PS_perMin_dense_summ, LR_vP_dense_summ, PS_perMin, vP, NumRegions);
    experiment_results(experiment_idx, 2, :, :) = evaluateDeviation(...
        LR_PS_perMin_region, LR_vP_region, PS_perMin, vP, NumRegions);
end