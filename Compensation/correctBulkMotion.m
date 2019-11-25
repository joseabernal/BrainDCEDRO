%% Use MCFLIRT to correct for gross motion
%  This function calls MCFLIRT to correct for gross motion
%
%  Inputs:
%  - mcflirt_command: mcflirt command
%  - input_fname: filename of the DCE-MRI to correct
%  - output_fname: output filename
%
%  Outputs:
%   - SI_cor: 4D DCE-MRI signal corrected for gross motion
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function SI_cor = correctBulkMotion(mcflirt_command, input_fname, output_fname)
    system(sprintf(mcflirt_command, input_fname));

    LR_SI_corr_data = load_nifti(output_fname, []);
    SI_cor = LR_SI_corr_data.vol;
end