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

% Create signal for patient experiment_idx
% To simulate realistic gross motion effects, read transformation matrices 
% used to re-align patient images
trans_matrices_post = read_transformation_matrices(...
    trans_matrix_pattern, experiment_idx);
trans_matrices_pre = {affine3d(eye(4)), trans_matrices_post{1:end-1}};

% Apply gross motion to high resolution signal using the transformations 
% determined from patient data
HR_SI_motion = induceMotionHRSignal(...
    HR_SI_orig, trans_matrices_pre, trans_matrices_post, NTrue, NFrames,...
    apply_gross_motion, apply_motion_artefacts);

% save generated high res 4D signal with motion
save_scan({HR_SI_motion}, {['HR_SI_motion_', num2str(experiment_idx)]}, NTrue, output_folder, HRes_mm)