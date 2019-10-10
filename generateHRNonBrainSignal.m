%% Generate high resolution region segmentation map
function HR_SI_nonbrain = generateHRNonBrainSignal(HR_tissue_map, ref_seg_fname, ref_enh_fname, ref_i0_fname, NTrue, NFrame)
    %%Load ground truth
    ref_seg = double(load_series(ref_seg_fname, []));
    ref_enh = double(load_series(ref_enh_fname, []));
    ref_i0 = double(load_series(ref_i0_fname, []));
    
    %%Set NaN to 0 to avoid issues
    ref_enh(isnan(ref_enh)) = 0;
    ref_i0(isnan(ref_i0)) = 0;
    
    ref_sig = (ref_enh + 1.0) .* ref_i0;
    
    %avoid extremes
    ref_seg = ref_seg(:, :, 10:32);
    ref_sig = ref_sig(:, :, 10:32, :);
    
    ref_seg_classes = [4, 5];
    HR_seg_classes = [11, 9];
    HR_tissue_map = reshape(HR_tissue_map, [numel(HR_tissue_map), 1]);
    HR_SI_nonbrain = zeros([numel(HR_tissue_map), NFrame]);
    for seg_class = 1:2
        SI = ref_sig .* (ref_seg == ref_seg_classes(seg_class));
        SI = reshape(SI, [numel(ref_seg), NFrame]);
        SI = SI(sum(SI, 2) ~= 0, :);

        SI_avg = nanmedian(SI, 1);

        HR_SI_nonbrain(HR_tissue_map == HR_seg_classes(seg_class), :) = ...
            repmat(SI_avg, [sum(HR_tissue_map == HR_seg_classes(seg_class)), 1]);
    end
    
    HR_SI_nonbrain = reshape(HR_SI_nonbrain, [NTrue, NFrame]);
end