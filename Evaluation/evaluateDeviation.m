function region_results = evaluateDeviation(LR_PS_perMin, LR_vP, PS_perMin, vP, NumRegions)
    region_results = nan(NumRegions, 6);
    for region=1:NumRegions
        PS_true  = PS_perMin(region);
        vP_true  = vP(region);

        PS_error = (LR_PS_perMin{region} - PS_true) ./ PS_true * 100;
        vP_error = (LR_vP{region} - vP_true) ./ vP_true * 100;
        
        region_results(region, :) = [prctile(PS_error, [50, 25, 75]), prctile(vP_error, [50, 25, 75])];
    end
end