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
HR_SI_fname = ['output', filesep, 'HR_SI_motion_', num2str(experiment_idx), '.nii'];
HR_SI = niftiread(HR_SI_fname);

% generate KSpace of HR image
HR_k_space_motion = generateKSpace(HR_SI, NFrames);

% generate low resolution (acquired) image data
LR_SI = generateLRData(HR_k_space_motion, SDnoise, NDiscard, NAcq, NFrames, apply_awgn);

% save low resolution signal
fname = ['LR_SI_', num2str(experiment_idx)];
save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);

if apply_motion_correction
    % use MCFLIRT to correct for bulk motion
    corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    correctBulkMotion(mcflirt_command, [output_folder, filesep, fname], corr_fname);
end