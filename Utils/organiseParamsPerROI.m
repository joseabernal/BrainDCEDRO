function ROI_values = organiseParamsPerROI(input, tissue_map, NumRegions)
    ROI_values = cell(NumRegions, 1);
    for region=1:NumRegions
        mask = tissue_map == region;

        ROI_values{region} = nanmean(input(mask));
    end
end