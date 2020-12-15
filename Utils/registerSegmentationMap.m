%% Register segmentation map to case
%  Register segmentation map to input case
%
%  Inputs:
%  - output_folder: output folder
%  - fname: base filename
%  - NAcq: number of points acquired
%  - NumRegions: number of regions of interest
%  - LRes_mm: low resolution [in mm]
%
%  Output:
%  - Segmentation map registered to input case
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_tissue_map = registerSegmentationMap(output_folder, fname, NAcq, NumRegions, LRes_mm)
    trans_fname = [output_folder, filesep, fname, '_mcf_tf.mat'];
    ref_fname = [output_folder, filesep, fname, '_mcf-0000.nii'];
    
    system(['fslsplit ', output_folder, filesep, fname, '_mcf.nii ', output_folder, filesep, fname, '_mcf-']);
    
    % find transformation matrix
    system(['flirt -dof 6 -cost leastsq -searchcost leastsq', ...
        ' -in input/LR_t1w.nii', ...,
        ' -ref ', ref_fname, ...
        ' -omat ', trans_fname]);
    
    % use transformation matrix to project each region of interest to the
    % target space
    LR_tissue_map = zeros([NAcq, NumRegions]);
    for reg_idx=1:NumRegions
        reg_str = num2str(reg_idx);
        
        roi_fname = [output_folder, filesep, 'LR_tissue_map_', reg_str, '.nii.gz'];
        roi_tf_fname = [output_folder, filesep, 'LR_tissue_map_', reg_str, '_to_', fname, '.nii.gz'];
        
        system(['fslmaths input/LR_tissue_map.nii ', ...
            '-thr ', reg_str, ' -uthr ', reg_str, ' -bin ', roi_fname])

        system(['flirt -dof 6 ', ...
                ' -in ', roi_fname, ' -ref ', ref_fname, ...
                ' -applyxfm -init ', trans_fname, ' -out ', roi_tf_fname]);

        LR_tissue_map(:, :, :, reg_idx) = niftiread(roi_tf_fname);
       
        system(['rm ', roi_fname])
        system(['rm ', roi_tf_fname])
    end
    
    [~, LR_tissue_map] = max(LR_tissue_map, [], 4);

    output_fname = ['LR_tissue_map_to_', fname];
    save_scan({LR_tissue_map}, {output_fname}, NAcq, output_folder, LRes_mm);
    
    system(['rm ', output_folder, filesep, fname, '_mcf-*.nii.gz'])
end