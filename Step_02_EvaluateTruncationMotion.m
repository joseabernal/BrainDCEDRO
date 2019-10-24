clc;
clear all;
close all;

setConfig; % set configuration (paths)
setParameters; % set parameters

HR_SI_fname = ['output', filesep, 'HR_SI_orig.nii'];
HR_SI = niftiread(HR_SI_fname);

HR_k_space = generateHRKSpace(...
    HR_SI, trans_matrices, NTrue, NFrames);

if save_HR_scans
    save_scan({HR_k_space}, {'HR_k'}, NTrue, output_folder, HRes_mm);
end

max_repetitions = 10;
probability_missing_lines = [0, 0.001:0.002:0.01];
experiment_results = zeros(numel(probability_missing_lines), NumRegions, 6);
for experiment_idx = 1:length(probability_missing_lines)
    probability_missing_line = probability_missing_lines(experiment_idx);

    [~, LR_tissue_map] = generateHRSegMap(seg_fname, NTrue, NAcq); % generate high res segmentation map
        
    rep_LR_PS_perMin = cell(NumRegions, 1);
    rep_LR_vP = cell(NumRegions, 1);
    for iteration = 1:max_repetitions
        % generate low resolution (acquired) image data
        LR_SI = generateLRData(...
            HR_k_space, probability_missing_line, SNR, NDiscard, NAcq, NFrames);

        if save_LR_scans
            save_scan({LR_SI}, {['LR_SI_', num2str(experiment_idx)]}, NAcq, output_folder, LRes_mm);
        end

        % mask low resolution to obtain signal of regions of interest
        LR_SI = LR_SI .* (LR_tissue_map ~= 1);

        LR_SI = filterTimeKalman(LR_SI, LR_tissue_map, t_res_s, NAcq, NFrames);
        
        % summarise signal per region of interest if needed
        if region_wise_computations
            LR_SI = summariseSIPerROI(...
                LR_SI, LR_tissue_map, NAcq, NFrames, NumRegions);
        end

        % fit PS and vp
        [LR_PS_perMin, LR_vP] = fitLRData(...
            LR_SI, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, ...
            r1_perSpermM,r2_perSpermM, t_res_s, NDes, region_wise_computations);
        
        if ~region_wise_computations
            LR_PS_perMin = organiseParamsPerROI(LR_PS_perMin, LR_tissue_map, NumRegions);
            LR_vP = organiseParamsPerROI(LR_vP, LR_tissue_map, NumRegions);
            
            for region=1:NumRegions
                rep_LR_PS_perMin{region} = [rep_LR_PS_perMin{region}; LR_PS_perMin{region}];
                rep_LR_vP{region} = [rep_LR_vP{region}; LR_vP{region}];
            end
        else
            for region=1:NumRegions
                rep_LR_PS_perMin{region} = [rep_LR_PS_perMin{region}; LR_PS_perMin(region)];
                rep_LR_vP{region} = [rep_LR_vP{region}; LR_vP(region)];
            end
        end
    end
    
    % evaluate deviation
    experiment_results(experiment_idx, :, :) = evaluateDeviation(...
        rep_LR_PS_perMin, rep_LR_vP, PS_perMin, vP, NumRegions);
end

ROIs = [3, 4, 6, 8];
figure;
hold on;
bar(repmat(1:6, [4, 1])', experiment_results(:, ROIs, 1))
errorbar([0.73, 0.92, 1.08 1.28] + [0;1;2;3;4;5], experiment_results(:, ROIs, 1), ...
    experiment_results(:, ROIs, 2)-experiment_results(:, ROIs, 1), ...
    experiment_results(:, ROIs, 3)-experiment_results(:, ROIs, 1), '--k', 'LineStyle', 'none');
legend('NAWM', 'WMH', 'GM', 'RSL', 'Location', 'southwest')
title('Effect of artefacts on PS')
ylabel('Relative error (%)')
xlabel('Probability of missing line (%)')
hold off;
figure;
hold on;
bar(repmat(1:6, [4, 1])', experiment_results(:, ROIs, 4))
errorbar([0.73, 0.92, 1.08 1.28] + [0;1;2;3;4;5], experiment_results(:, ROIs, 4), ...
    experiment_results(:, ROIs, 5)-experiment_results(:, ROIs, 4), ...
    experiment_results(:, ROIs, 6)-experiment_results(:, ROIs, 4), '--k', 'LineStyle', 'none');
legend('NAWM', 'WMH', 'GM', 'RSL', 'Location', 'southwest')
title('Effect of artefacts on vP')
ylabel('Relative error (%)')
xlabel('Probability of missing line (%)')
hold off;