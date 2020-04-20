%% Create low resolution signal
%  This script allows creating a 4D low resolution DCE-MRI acquisition
%  given a 4D high resolution affected by truncation and noise.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

clc;
clear all;
close all;

% set configuration (paths)
setConfig;

% set parameters
setParameters; 

% Load 4D high resolution DCE-MRI signal
HR_SI_pre_fname = ['output', filesep, 'HR_SI_motion_', num2str(experiment_idx), '_pre.nii'];
HR_SI_post_fname = ['output', filesep, 'HR_SI_motion_', num2str(experiment_idx), '_post.nii'];
HR_SI_pre = niftiread(HR_SI_pre_fname);
HR_SI_post = niftiread(HR_SI_post_fname);

% compute the corresponding high resolution k-space
HR_k_space = nan([NTrue, NFrames, 2]);
HR_k_space(:, :, :, :, 1) = generateKSpace(HR_SI_pre, NFrames);
HR_k_space(:, :, :, :, 2) = generateKSpace(HR_SI_post, NFrames);

% generate low resolution (acquired) image data
LR_SI = generateLRData(HR_k_space, SDnoise, NDiscard, NAcq, NFrames, apply_awgn);

% save low resolution signal
fname = ['LR_SI_', num2str(experiment_idx)];
save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);

if apply_motion_correction
    % use MCFLIRT to correct for bulk motion
    corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    correctBulkMotion(mcflirt_command, [output_folder, filesep, fname], corr_fname);
end