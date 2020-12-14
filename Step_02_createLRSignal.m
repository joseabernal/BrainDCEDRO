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

rng(0, 'twister'); %for reproducibility

HR_SI_fname = ['output', filesep, 'HR_SI_orig.nii'];

% Create reference LR T1w scan
if ~exist(HR_SI_fname, 'file')
    HR_SI_orig = niftiread(HR_SI_fname);
    
    % Load 4D high resolution DCE-MRI signal
    HR_SI = cat(5, HR_SI_orig, HR_SI_orig);
    
    % generate low resolution (acquired) image data
    LR_SI = generateLRData(...
        HR_SI, FOV_mm_True, NTrue, SDnoise, FOV_mm_Acq, NAcq, 1, 0, 0);
    
    clear HR_SI_orig;
    clear HR_SI;
    
    % save low resolution signal
    fname = 'LR_t1w';
    save_scan({LR_SI}, {fname}, NAcq, 'input', LRes_mm);
end

for experiment_idx=1:205
    HR_SI_pre_fname = [output_folder, filesep, 'HR_SI_motion_', num2str(experiment_idx), '_pre.nii'];
    HR_SI_post_fname = [output_folder, filesep, 'HR_SI_motion_', num2str(experiment_idx), '_post.nii'];
    
    if ~exist(HR_SI_pre_fname, 'file') || ~exist(HR_SI_post_fname, 'file')
        continue
    end

    % Load 4D high resolution DCE-MRI signal
    HR_SI_pre = niftiread(HR_SI_pre_fname);
    HR_SI_post = niftiread(HR_SI_post_fname);
    HR_SI = cat(5, HR_SI_pre, HR_SI_post);
    
    clear HR_SI_pre;
    clear HR_SI_post;

    % generate low resolution (acquired) image data
    LR_SI = generateLRData(...
        HR_SI, FOV_mm_True, NTrue, SDnoise, FOV_mm_Acq, NAcq, NFrames, apply_noise, apply_lowpass);
    
    clear HR_SI;

    % save low resolution signal
    fname = ['LR_SI_', num2str(experiment_idx), ''];
    save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);

    % use FSL to correct for bulk motion
    correctBulkMotion(mcflirt_command, output_folder, fname);
    
    % register segmentation map to input case
    registerSegmentationMap(output_folder, fname, NAcq, NumRegions, LRes_mm);
end