%% Summarise parameter maps per region of interest
%  Summarise parameter maps per region of interest
%  
%  Inputs:
%  - input: Parameter map to summarise
%  - tissue_map: 3D segmentation map
%  - NumRegions: Number of regions in segmentation map

%  Outputs:
%   - ROI_values: mean value per region of interest
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function ROI_values = organiseParamsPerROI(input, tissue_map, NumRegions)
    ROI_values = zeros(NumRegions, 1);
    for region=1:NumRegions
        mask = tissue_map == region;

        ROI_values(region) = nanmean(input(mask));
    end
end