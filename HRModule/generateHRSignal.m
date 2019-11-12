%% Create high resolution 4D image

function HR_SI = generateHRSignal(HR_Ct_mM, HR_tissue_map, S0, T10_s, T2s0_s, FA_deg, TR_s, TE_s, r1_perSpermM, r2_perSpermM, HR_SI_nonbrain, NTrue, save_HR_scans, output_folder, HRes_mm)
    %%Create high resolution parameter images
    HR_S0 = S0(HR_tissue_map);
    HR_T10_s = T10_s(HR_tissue_map);
    HR_T2s0_s = T2s0_s(HR_tissue_map);
    HR_FA_deg = FA_deg * ones(size(HR_tissue_map));

    %%Create high resolution 4D image
    HR_enh_pct = DCEFunc_reshape(...
        DCEFunc_Conc2Enh_SPGR(...
            DCEFunc_reshape(HR_Ct_mM),HR_T10_s(:).',TR_s,TE_s,HR_FA_deg(:).',r1_perSpermM,r2_perSpermM),...
            NTrue); %calculate high res signal enhancement

    HR_SI = DCEFunc_getSPGRSignal(HR_S0,HR_T10_s,HR_T2s0_s,TR_s,TE_s,HR_FA_deg).*(1+HR_enh_pct/100); %calculate high res signal
    HR_SI(isnan(HR_SI))=0; %set background to zero signal
    
    %%Put non-brain structures
    HR_SI = HR_SI .* (HR_SI_nonbrain==0) + HR_SI_nonbrain .* (HR_SI_nonbrain>0);
    HR_SI(isnan(HR_SI)) = 0;

    %%Write nii output
    if save_HR_scans 
        HR_V.fname=[output_folder '/HR_PS_perMin'];
        HR_V.dim=NTrue;
        HR_V.dt=[16 0];
        HR_V.mat=[ HRes_mm(1) 0 0 0; 0 HRes_mm(2) 0 0;0 0 HRes_mm(3) 0; 0 0 0 1];
        dataToWrite = {HR_SI};
        filenames   = {'HR_SI_orig'};
        NFiles=size(dataToWrite,2);
        for iFile=1:NFiles
            SPMWrite4D(HR_V, dataToWrite{iFile}, output_folder, filenames{iFile}, 16);
        end
    end
end