%% Create high resolution signal
%  This script allows creation of a 4D high resolution DCE-MRI signal
%  given specific imaging parameters and a head atlas. 
%
%  This function takes a high resolution atlas and imaging parameters, 
%  generates parameter maps, creates concentration-time curves using the
%  Patlak model, and creates signal-time curves using the SPGR model.
%
%  For tissues not described by Patlak model parameters (i.e. non-brain), 
%  representative signal-time data is determined directly from in-vivo 
%  measurements.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

clc;
clear all;
close all;

% set configuration (paths)
setConfig;

% set parameters
setParameters;

HR_SI_fname = ['output', filesep, 'HR_SI_orig.nii'];

if ~exist(HR_SI_fname, 'file')
    % generate high res segmentation map
    HR_tissue_map = generateHRSegMap(HR_seg_fname);

    % generate high res 4D concentration map
    [HR_Ct_mM, HR_PS_perMin, HR_vP] = generateHRConc(...
        HR_tissue_map, vP, PS_perMin, Cp_AIF_mM, NTrue, NFrames, t_res_s);

    % save generated high res 4D concentration, PS and vp maps
    save_scan({HR_PS_perMin, HR_vP, HR_Ct_mM}, ...
        {'HR_PS_orig', 'HR_vP_orig', 'HR_Ct_orig'}, NTrue, output_folder, HRes_mm)

    % generate high res nonbrain signal
    HR_SI_nonbrain = generateHRNonBrainSignal(...
        HR_tissue_map, SI_nonbrain, NTrue, NFrames);

    % generate high res image data
    HR_SI_orig = generateHRSignal(...
        HR_Ct_mM, HR_tissue_map, HR_SI_nonbrain, M0, T10_s, T2s0_s, FA_deg, ...
        TR_s, TE_s, r1_perSpermM, r2_perSpermM, NTrue);

    % save generated high res 4D signal
    save_scan({HR_SI_orig}, {'HR_SI_orig'}, NTrue, output_folder, HRes_mm)
else
    HR_SI_orig = niftiread(HR_SI_fname);
end

% Create 4D high res signals for the entire cohort
for experiment_idx=1:205
    trans_matrices_fname = sprintf(trans_matrix_pattern, num2str(experiment_idx));
    
    if ~exist(trans_matrices_fname, 'file')
        continue
    end

    % Generate random transformation to set initial head position
    origpos = generateRandomTransformation(5, 5);

    orig_transformation_matrices = cell(21, 1);
    for iFrame=1:NFrames
        orig_transformation_matrices{iFrame} = origpos;
    end

    % Apply random starting position
    HR_SI = applyGrossMotion(HR_SI_orig, orig_transformation_matrices, NTrue, NFrames);

    % Create output filename and save signal
    HR_SI_fname_pattern = 'HR_SI_%s';
    HR_SI_fname = sprintf(HR_SI_fname_pattern, num2str(experiment_idx));
    save_scan({HR_SI}, {HR_SI_fname}, NTrue, output_folder, HRes_mm)
    
    % Read transformation matrices
    trans_matrices_post = read_transformation_matrices(...
        trans_matrix_pattern, experiment_idx);
    
    trans_matrices_pre = {affine3d(eye(4)), trans_matrices_post{1:end-1}};
    
    % Apply gross motion to high resolution signal using the transformations 
    % determined from patient data
    [HR_SI_motion_pre, HR_SI_motion_post] = induceMotionHRSignal(...
        HR_SI, trans_matrices_pre, trans_matrices_post, NTrue, NFrames, ...
        apply_gross_motion, apply_motion_artefacts);
    
    % Create output filenames and save signals
    HR_SI_motion_fname_pattern = 'HR_SI_motion_%s_%s';
    HR_SI_motion_pre_fname = sprintf(HR_SI_motion_fname_pattern, num2str(experiment_idx), 'pre');
    HR_SI_motion_post_fname = sprintf(HR_SI_motion_fname_pattern, num2str(experiment_idx), 'post');
    save_scan({HR_SI_motion_pre}, {HR_SI_motion_pre_fname}, NTrue, output_folder, HRes_mm)
    save_scan({HR_SI_motion_post}, {HR_SI_motion_post_fname}, NTrue, output_folder, HRes_mm)
end