%% Create low resolution signal
%  This script allows creating a 4D low resolution DCE-MRI acquisition
%  given a 4D high resolution affected by truncation, noise, and motion
%  artfacts.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

%MINOR POINT BUT GROSS MOTION MIGHT BE BETTER IN STEP 1, SINCE IT AFFECTS THE "REAL" OBJECT AND ISN'T PART OF THE MEASUREMENT PROCESS
%SIMILARLY, MCFLIRT SHOULD PERHAPS BE GROUPED TOGETHER WITH ENH->CONC, MODEL FITTING ETC. AS A DATA PROCESSING STEP.

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

    % to simulate realistic gross motion effects, read transformation matrices used to re-align patient images
    trans_matrices = cell(NFrames, 1);
    for iFrame = 2:NFrames
        trans_matrix_fname = sprintf(trans_matrix_pattern, dataset{experiment_idx, 2}, dataset{experiment_idx, 4},iFrame);
        if ~exist(trans_matrix_fname)
            trans_matrices{iFrame} = affine3d(eye(4));
        else
            trans_matrices{iFrame} = invert(affine3d(load(trans_matrix_fname, '-ASCII')')); %EXPLAIN WHAT THIS DOES...
        end
    end

    % apply gross motion to high resolution signal using the transformations determined from patient data
    HR_SI_gross_motion = applyGrossMotion(HR_SI, trans_matrices, NTrue, NFrames);
    % HAVE YOU CHECKED THIS WORKS CORRECTLY. E.G. IS OUR DEFINITION VS. FLIRT DEFINITION OF TRANSFORMATION MATRIX THE SAME.
    % FOR EXAMPLE YOU COULD TRY APPLYING THIS FUNCTION TO FIRST FRAME OF MSS2 VOLUME AND CHECK THE OBSERVED MOTION IS REPRODUCED.
    % ALSO, NOTE IF WE ARE SIMPLY SIMULATING MOTION, THE TRANSFORMATION SHOULD BE RIGID BODY (6 DOF) NOT AFFINE (12 DOF). NOT SURE IF PAA'S
    % MATRICES HAVE 6 OR 12 DOF...
    
    % compute the corresponding high resolution k-space
    HR_k_space = generateHRKSpace(HR_SI_gross_motion, NFrames);

    % generate scanning resolution (acquired) image data
    LR_SI = generateLRData(HR_k_space, trans_matrices, SNR, NDiscard, NAcq, NFrames);
    
    % save low resolution signal
    fname = ['LR_SI_', num2str(experiment_idx)];
    save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);
    
    % use MCFLIRT to correct for bulk motion
    corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    correctBulkMotion(mcflirt_command, [output_folder, filesep, fname], corr_fname);

    clear HR_k_space;
end
