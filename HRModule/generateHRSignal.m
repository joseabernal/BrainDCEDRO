%% Create a 4D high resolution DCE-MRI signal scan
%  The concentration-time curves in HR_Ct_mM are transformed to signal-time
%  curves based on the imaging parameters and the SPGR model.
%  
%  Inputs:
%  - HR_Ct_mM: 4D concentration-time curves
%  - HR_tissue_map: 3D segmentation map
%  - HR_SI_nonbrain: 4D signal-time curves for non-brain structures
%  - M0: Equilibrium signal
%  - T10_s: Longitudinal relaxation times in seconds
%  - T2s0_s: Transversal relaxation times in seconds
%  - FA_deg: Flip angle
%  - TR_s: Repetition time in seconds
%  - TE_s: Echo time in seconds
%  - r1_perSpermM: r1 contrast agent relaxivity
%  - r2_perSpermM: r2 contrast agent relaxivity
%  - NTrue: Dimension of image that defines the "true" object

%  Outputs:
%   - HR_SI: 4D high resolution signal-time curves for brain and non-brain
%            structures
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function HR_SI = generateHRSignal(HR_Ct_mM, HR_tissue_map, HR_SI_nonbrain, M0, T10_s, T2s0_s, FA_deg, TR_s, TE_s, r1_perSpermM, r2_perSpermM, NTrue)
    %%Create high resolution parameter images
    HR_M0 = M0(HR_tissue_map);
    HR_T10_s = T10_s(HR_tissue_map);
    HR_T2s0_s = T2s0_s(HR_tissue_map);
    HR_FA_deg = FA_deg * ones(size(HR_tissue_map));

    %%Create high resolution 4D image
    HR_enh_pct = DCEFunc_reshape(...
        DCEFunc_Conc2Enh_SPGR(...
            DCEFunc_reshape(HR_Ct_mM),HR_T10_s(:).',TR_s,TE_s,HR_FA_deg(:).',r1_perSpermM,r2_perSpermM),...
            NTrue); %calculate high res signal enhancement

    HR_SI = DCEFunc_getSPGRSignal(HR_M0,HR_T10_s,HR_T2s0_s,TR_s,TE_s,HR_FA_deg).*(1+HR_enh_pct/100); %calculate high res signal
    HR_SI(isnan(HR_SI))=0; %set background to zero signal
    
    %%Put non-brain structures
    HR_SI = HR_SI .* (HR_SI_nonbrain==0) + HR_SI_nonbrain .* (HR_SI_nonbrain>0);
    HR_SI(isnan(HR_SI)) = 0;
end