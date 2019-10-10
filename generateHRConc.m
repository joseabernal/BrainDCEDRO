%% Create high resolution parameter images and time series
function HR_Ct_mM = generateHRConc(HR_tissue_map, vP, PS_perMin, Cp_AIF_mM, NTrue, NFrames, t_res_s, save_HR_scans, output_folder, HRes_mm)
    %%Create high resolution parameter images
    HR_vP = vP(HR_tissue_map);
    HR_PS_perMin = PS_perMin(HR_tissue_map);

    %%Generate high resolution 4D concentration time series
%     Patlak_params = struct('vP', HR_vP, 'PS_perMin', HR_PS_perMin);
%     [HR_Ct_mM, ~] = DCEFunc_PKP2Conc(t_res_s, Cp_AIF_mM, Patlak_params, 'Patlak', []);

    HR_Ct_mM = reshape(HR_vP, [prod(NTrue), 1]) * Cp_AIF_mM' + reshape(HR_PS_perMin, [prod(NTrue), 1]) * cumsum(Cp_AIF_mM, 1)';
    
    HR_Ct_mM = reshape(HR_Ct_mM, [NTrue, NFrames]);

    if save_HR_scans 
        HR_V.fname=[output_folder '/HR_PS_perMin'];
        HR_V.dim=NTrue;
        HR_V.dt=[16 0];
        HR_V.mat=[ HRes_mm(1) 0 0 0; 0 HRes_mm(2) 0 0;0 0 HRes_mm(3) 0; 0 0 0 1];
        dataToWrite = {HR_PS_perMin, HR_vP, HR_Ct_mM};
        filenames   = {'HR_PS_orig', 'HR_vP_orig', 'HR_Ct_orig'};
        NFiles=size(dataToWrite,2);
        for iFile=1:NFiles
            SPMWrite4D(HR_V, dataToWrite{iFile}, output_folder, filenames{iFile}, 16);
        end
    end
end