function LR_SI_cor = correctBulkMotion(mcflirt_command, LR_fname, LR_corr_fname)
    system(sprintf(mcflirt_command, LR_fname));

    LR_SI_corr_data = load_nifti(LR_corr_fname, []);
    LR_SI_cor = LR_SI_corr_data.vol;
end