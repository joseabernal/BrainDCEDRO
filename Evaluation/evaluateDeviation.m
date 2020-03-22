%% Compute the median and IQR estimation of error between the ground truth and the approximated permeability values
%  Compute the median and IQR estimation of error between the ground truth
%  and the approximated permeability values
%  
%  Inputs:
%  - LR_PS_perMin: Estimated low resolution blood-brain barrier leakage per minute
%                   per voxel or region of interest
%  - LR_vP: Estimated low resolution capillary blood plasma volume fraction per unit
%            of tissue per vpxel or region of interest
%  - PS_perMin_true:  Real low resolution blood-brain barrier leakage per minute
%                   per voxel or region of interest
%  - vP_true: Real low resolution capillary blood plasma volume fraction per unit
%            of tissue per vpxel or region of interest
%  - NumRegions: Number of regions in segmentation map

%  Outputs:
%   - region_results: median and IQR error values per regions of interest
%
% (c) Jose Bernal and Michael J. Thrippleton 2019


function region_results = evaluateDeviation(LR_PS_perMin, LR_vP, PS_perMin_true, vP_true, NumRegions)
    region_results = nan(NumRegions, 6);
    for region=1:NumRegions
        PS_error = (LR_PS_perMin(region) - PS_perMin_true(region)) ./ PS_perMin_true(region) * 100;
        vP_error = (LR_vP(region) - vP_true(region)) ./ vP_true(region) * 100;
        
        region_results(region, :) = [prctile(PS_error, [50, 25, 75]), prctile(vP_error, [50, 25, 75])];
    end
end