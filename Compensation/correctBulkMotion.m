%% Use FSL to correct for bulk motion
%  This function calls MCFLIRT to correct for gross motion
%
%  Inputs:
%  - mcflirt_command: mcflirt command
%  - output_folder: output folder
%  - fname: base filename
%  - NFrames: number of frames
%  - t_res_s: temporal resolution
%
%  Outputs:
%   - LR_SI_cor: 4D DCE-MRI signal corrected for gross motion
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_SI_cor = correctBulkMotion(mcflirt_command, output_folder, fname, NFrames, t_res_s)
    input_fname = [output_folder, filesep, fname];
    system(sprintf(mcflirt_command, input_fname));
    
    system(['fslsplit ', output_folder, filesep, fname, '_mcf.nii.gz ', output_folder, filesep, fname, '_mcf-']);
    system(['flirt -dof 6 -in ', output_folder, filesep, fname, '_mcf-0000.nii.gz -ref input/LR_t1w.nii.gz -omat ', output_folder, filesep, fname, '_mcf_tf.mat']);
    
    allfiles = [];
    for iFrame=1:NFrames
        idstring = sprintf('%04d', iFrame-1);
        system(['flirt -dof 6 ', ...
            '-in ', output_folder, filesep, fname, '_mcf-', idstring, '.nii.gz ',...
            '-ref input/LR_t1w.nii.gz ', ...
            '-applyxfm -init ', output_folder, filesep, fname, '_mcf_tf.mat ', ...
            '-out ', output_folder, filesep, fname, '_mcf-', idstring, '_tf.nii.gz']);
        system(['rm ', output_folder, filesep, fname, '_mcf-', idstring, '.nii.gz'])
        allfiles = [allfiles, output_folder, filesep, fname, '_mcf-', idstring, '_tf.nii.gz '];
    end
    
    system(['fslmerge -tr ', output_folder, filesep, fname, '_mcf_tf ', allfiles,' ', num2str(t_res_s)]);
    system(['rm ', allfiles])

    LR_SI_cor = niftiread([output_folder, filesep, fname, '_mcf_tf']);
end