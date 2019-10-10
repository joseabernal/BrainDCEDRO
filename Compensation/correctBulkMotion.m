function LR_SI_cor = correctBulkMotion(mcflirt_command, output_folder)
    LR_fname =[output_folder filesep 'LR_SI'];

    system(sprintf(mcflirt_command, LR_fname))

    corr_fname = [output_folder, filesep, 'LR_SI_mcf.nii.gz'];

    LR_SI_corr_data = load_nifti(corr_fname, []);
    LR_SI_cor = LR_SI_corr_data.vol;
end