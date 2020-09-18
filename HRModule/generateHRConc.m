%% Create high resolution parameter images and time series
%  Using the spatial distribution information given by the high resolution
%  tissue map and the permeability parameters per tissue, this function
%  creates a 4D high resolution scan with the contrast agent concentration
%  in time.
%  
%  Inputs:
%  - HR_tissue_map: 3D segmentation map (value indicates tissue)
%  - HR_SI_nonbrain: 4D signal-time curves for non-brain structures
%  - vP: Capillary blood plasma fraction per unit of tissue (vector containing 1 vP value per tissue)
%  - PS_perMin: Blood-brain barrier leakage rate per minute (vector containing 1 PS value per tissue)
%  - Cp_AIF_mM: Contrast concentration in arterial input function in
%               millimoles
%  - NTrue: Dimension of image that defines the "true" object
%  - NFrames: Number of frames
%  - t_res_s: Temporal resolution

%  Outputs:
%   - HR_Ct_mM: 4D high resolution concentration-time curves for brain
%   - HR_PS_perMin: High resolution map of blood-brain barrier leakage rate
%                   per minute
%   - HR_vP: High resolution map of capillary blood plasma fraction per 
%            unit of tissue
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function [HR_Ct_mM, HR_PS_perMin, HR_vP] = generateHRConc(HR_tissue_map, vP, PS_perMin, Cp_AIF_mM, NTrue, NFrames, t_res_s)
    %%Create high resolution parameter images
    HR_vP = vP(HR_tissue_map);
    HR_PS_perMin = PS_perMin(HR_tissue_map);
    
    HR_vP = HR_vP(:);
    HR_PS_perMin = reshape(HR_PS_perMin, [numel(HR_PS_perMin), 1]);

    % Generate high resolution 4D concentration time series Note: we use
    % batches reduce spatial complexity.
    batch_size = 10e6;
    HR_Ct_mM = zeros([prod(NTrue), NFrames]);
    for batch_start = 1:batch_size:prod(NTrue)
        elem_in_batch = batch_start:min(batch_start+batch_size-1, prod(NTrue));

        %inputs should be row vectors
        Patlak_params = struct('vP', HR_vP(elem_in_batch), 'PS_perMin', HR_PS_perMin(elem_in_batch));

        %PKP2Conc returns a matrix where each COL, not ROW is a time series
        HR_Ct_mM(elem_in_batch, :) = DCEFunc_PKP2Conc(t_res_s, Cp_AIF_mM, Patlak_params, 'Patlak', []);
    end

    HR_Ct_mM = reshape(HR_Ct_mM, [NTrue, NFrames]);
    HR_PS_perMin = reshape(HR_PS_perMin, NTrue);
    HR_vP = reshape(HR_vP, NTrue);
end