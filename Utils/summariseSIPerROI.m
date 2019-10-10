function ROI_SI = summariseSIPerROI(LR_SI, LR_tissue_map, NAcq, NFrames, NumRegions)
    LR_SI = reshape(LR_SI, [prod(NAcq), NFrames]);

    ROI_SI = zeros(NumRegions, NFrames);
    for region=1:NumRegions
        mask = reshape(imerode(LR_tissue_map == region, strel('disk', 2)), [prod(NAcq), 1]);

        ROI_SI(region, :) = nanmean(LR_SI(mask, :), 1);
    end
end