clc;
clear all;
close all;

maxNumCompThreads(15)

setConfig; % set configuration (paths)
setParameters; % set parameters

HR_SI_fname = ['output', filesep, 'HR_SI_orig.nii'];
HR_SI = niftiread(HR_SI_fname);

[~, LR_tissue_map] = generateHRSegMap(seg_fname, NTrue, NAcq); % generate high res segmentation map

for experiment_idx = 13:size(dataset, 1)
    trans_matrices = cell(NFrames, 1);
    for iFrame = 2:NFrames
        trans_matrix_fname = sprintf(trans_matrix_pattern, dataset{experiment_idx, 2}, dataset{experiment_idx, 4},iFrame);
        trans_matrices{iFrame} = invert(affine3d(load(trans_matrix_fname, '-ASCII')'));
    end

    HR_k_space = generateHRKSpace(...
        HR_SI, trans_matrices, NTrue, NFrames);

    % generate low resolution (acquired) image data
    LR_SI = generateLRData(HR_k_space, trans_matrices, SNR, NDiscard, NAcq, NFrames, k_space_mix_proportion);

    fname = ['LR_SI_', num2str(experiment_idx)];
    corr_fname = [output_folder, filesep, fname, '_mcf.nii.gz'];
    
    save_scan({LR_SI}, {fname}, NAcq, output_folder, LRes_mm);
    correctBulkMotion(mcflirt_command, [output_folder, filesep, fname], corr_fname);

    clear HR_k_space;
end