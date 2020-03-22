%% Calculate enhancement and concentrations in each voxel or region of low resolution image
%  Compute concentration in each voxel or region of interest in time from
%   low resolution image
%  
%  Inputs:
%  - LR_SI: 4D signal-time curves
%  - Cp_AIF_mM: Contrast concentration in arterial input function in
%               millimoles
%  - LR_tissue_map: 3D segmentation map
%  - HR_SI_nonbrain: 4D signal-time curves for non-brain structures
%  - T10_s: Longitudinal relaxation times in seconds
%  - TR_s: Repetition time in seconds
%  - TE_s: Echo time in seconds
%  - FA_deg: Flip angle
%  - r1_perSpermM: r1 contrast agent relaxivity
%  - r2_perSpermM: r2 contrast agent relaxivity
%  - t_res_s: Temporal resolution in seconds
%  - NDes: Number of points acquired
%  - region_wise_computations: boolean that indicates whether the
%                              evaluation is carried out at a region level
%                              or not
%  - regression_type: either linear or robust regression
%
%  Outputs:
%   - LR_PS_perMin: low resolution blood-brain barrier leakage per minute
%                   per voxel or region of interest
%   - LR_vP: low resolution capillary blood plasma volume fraction per unit
%            of tissue per vpxel or region of interest
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function [LR_PS_perMin, LR_vP] = fitLRData(LR_SI, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, r1_perSpermM, r2_perSpermM, t_res_s, NDes, region_wise_computations, regression_type)
    fit_options = struct('NIgnore',1,'PatlakFastRegMode',regression_type);
    if region_wise_computations
        LR_enh_pct=DCEFunc_Sig2Enh(LR_SI',1); %calc enhancement relative to first image
        LR_Ct_mM=DCEFunc_Enh2Conc_SPGR(...
            LR_enh_pct,T10_s,TR_s,TE_s,repmat(FA_deg,1,numel(T10_s)),...
            r1_perSpermM,r2_perSpermM,'analytical');

        % Fit Patlak model
        [PatlakParams2D, ~]=DCEFunc_fitModel(...
            t_res_s,LR_Ct_mM,Cp_AIF_mM,'PatlakFast',fit_options); %do the fitting

        LR_PS_perMin = PatlakParams2D.PS_perMin;
        LR_vP = PatlakParams2D.vP;
    else
        LR_enh_pct=DCEFunc_reshape(DCEFunc_Sig2Enh(DCEFunc_reshape(LR_SI),1), NDes); %calc enhancement relative to first image
        T10_assumed_s=T10_s(LR_tissue_map);
        LR_Ct_mM=DCEFunc_reshape(...
            DCEFunc_Enh2Conc_SPGR(...
                DCEFunc_reshape(LR_enh_pct),...
                reshape(T10_assumed_s, [1, prod(NDes)]),...
                TR_s,TE_s,repmat(FA_deg,1,prod(NDes)),...
                r1_perSpermM,r2_perSpermM,'analytical'), NDes);

        % Fit Patlak model
        [PatlakParams2D, ~]=DCEFunc_fitModel(...
            t_res_s,DCEFunc_reshape(LR_Ct_mM),Cp_AIF_mM,'PatlakFast',fit_options); %do the fitting

        LR_PS_perMin = DCEFunc_reshape(PatlakParams2D.PS_perMin,NDes);
        LR_vP = DCEFunc_reshape(PatlakParams2D.vP,NDes);
    end
end