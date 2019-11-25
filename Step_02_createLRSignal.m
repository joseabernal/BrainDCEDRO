%% Create low resolution signal
%  This script allows creating a 4D low resolution DCE-MRI acquisition
%  given a 4D high resolution affected by truncation, noise, and motion
%  artfacts.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

clc;
clear all;
close all;

maxNumCompThreads(15);

% set configuration (paths)
setConfig;

% set parameters
setParameters; 

% Load 4D high resolution DCE-MRI signal
HR_SI_fname = ['output', filesep, 'HR_SI_orig.nii'];
HR_SI = niftiread(HR_SI_fname);

for experiment_idx = 1:size(dataset, 1)

    % read all transformation matrices for each patient
    trans_matrices = cell(NFrames, 1);
    for iFrame = 2:NFrames
        trans_matrix_fname = sprintf(trans_matrix_pattern, dataset{experiment_idx, 2}, dataset{experiment_idx, 4},iFrame);
        if ~exist(trans_matrix_fname)
            trans_matrices{iFrame} = affine3d(eye(4));
        else
            trans_matrices{iFrame} = invert(affine3d(load(trans_matrix_fname, '-ASCII')'));
        end
    end

    % apply gross motion to high resolution signal
    HR_SI_gross_motion = applyGrossMotion(HR_SI, trans_matrices, NTrue, NFrames);
    
    % compute the corresponding high resolution k-space
    HR_k_space = generateHRKSpace(HR_SI_gross_motion, NFrames);

    % generate low resolution (acquired) image data
    LR_SI = generateLRData(HR_k_space, trans_matrices, SNR, NDiscard, NAcq, NFrames);
    
    % save low resolution signal
    fname = ['LR_SI_', num2str(experiment_idx)];
    save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);
    
    % use MCFLIRT to correct for bulk motion
    corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    correctBulkMotion(mcflirt_command, [output_folder, filesep, fname], corr_fname);

    clear HR_k_space;
end
