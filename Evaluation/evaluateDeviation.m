function region_results = evaluateDeviation(LR_PS_perMin, LR_vP, LR_tissue_map, PS_perMin, vP, NumRegions)
    region_results = nan(NumRegions, 6);
    for region=1:NumRegions
        region_mask = imerode(LR_tissue_map == region, strel('disk', 2));
        PS_estimated = LR_PS_perMin(region_mask);
        vP_estimated = LR_vP(region_mask);

        PS_true  = PS_perMin(region);
        vP_true  = vP(region);

        PS_error = (PS_estimated - PS_true) ./ PS_true * 100;
        vP_error = (vP_estimated - vP_true) ./ vP_true * 100;
        
        region_results(region, :) = [prctile(PS_error, [50, 25, 75]), prctile(vP_error, [50, 25, 75])];
    end
end