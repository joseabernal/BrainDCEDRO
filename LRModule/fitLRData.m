%% Calculate enhancement and concentrations in each voxel of low res image

function [LR_PS_perMin, LR_vP] = fitLRData(LR_SI, Cp_AIF_mM, LR_tissue_map, T10_s, TR_s,TE_s, FA_deg, r1_perSpermM, r2_perSpermM, t_res_s, NDes, region_wise_computations)
    if region_wise_computations
        LR_enh_pct=DCEFunc_Sig2Enh(LR_SI',1); %calc enhancement relative to first image
        LR_Ct_mM=DCEFunc_Enh2Conc_SPGR(LR_enh_pct,T10_s,TR_s,TE_s,repmat(FA_deg,1,numel(T10_s)),r1_perSpermM,r2_perSpermM,'analytical');

        % Fit Patlak model
        [PatlakParams2D, ~]=DCEFunc_fitModel(t_res_s,LR_Ct_mM,Cp_AIF_mM,'PatlakFast',struct('NIgnore',0)); %do the fitting
        LR_PS_perMin = PatlakParams2D.PS_perMin;
        LR_vP = PatlakParams2D.vP;
    else
        LR_enh_pct=DCEFunc_reshape(DCEFunc_Sig2Enh(DCEFunc_reshape(LR_SI),1), NDes); %calc enhancement relative to first image
        T10_assumed_s=T10_s(LR_tissue_map);
        LR_Ct_mM=DCEFunc_reshape(DCEFunc_Enh2Conc_SPGR(DCEFunc_reshape(LR_enh_pct),reshape(T10_assumed_s, [1, prod(NDes)]),TR_s,TE_s,repmat(FA_deg,1,prod(NDes)),r1_perSpermM,r2_perSpermM,'analytical'), NDes);

        % Fit Patlak model
        [PatlakParams2D, ~]=DCEFunc_fitModel(t_res_s,DCEFunc_reshape(LR_Ct_mM),Cp_AIF_mM,'PatlakFast',struct('NIgnore',0)); %do the fitting
        LR_PS_perMin = DCEFunc_reshape(PatlakParams2D.PS_perMin,NDes);
        LR_vP = DCEFunc_reshape(PatlakParams2D.vP,NDes);
    end
end