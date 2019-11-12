clc;
clear all;
close all;

% set configuration (paths)
setConfig;

% set parameters
setParameters;

% generate high res segmentation map
[HR_tissue_map, ~] = generateHRSegMap(seg_fname, NTrue, NAcq);

% generate high res 4D concentration map
HR_Ct_mM = generateHRConc(...
    HR_tissue_map, vP, PS_perMin, Cp_AIF_mM, NTrue, NFrames, t_res_s, ...
    save_HR_scans, output_folder, HRes_mm);

% generate high res nonbrain signal
HR_SI_nonbrain = generateHRNonBrainSignal(HR_tissue_map, NTrue, NFrames);

% generate high res image data
HR_SI = generateHRSignal(...
    HR_Ct_mM, HR_tissue_map, S0, T10_s, T2s0_s, FA_deg, TR_s, TE_s, ...
    r1_perSpermM, r2_perSpermM, HR_SI_nonbrain, NTrue, ...
    save_HR_scans, output_folder, HRes_mm);