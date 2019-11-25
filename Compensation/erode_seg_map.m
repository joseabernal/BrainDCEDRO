%% Erode segmentation map
%  Generate 3D low resolution segmentation map from a high resolution
%  segmentation map
%  
%  Inputs:
%  - tissue_map: segmentation map
%  - relevant_regions: regions to erode
%  - erosion_extent: radius of the structural element
%  - NumRegions: Number of regions of interest

%  Outputs:
%   - tissue_map_eroded: Eroded low resolution segmentation map
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function tissue_map_eroded = erode_seg_map(tissue_map, relevant_regions, erosion_extent, NumRegions)
    disk = strel('disk', erosion_extent);
    tissue_map_eroded = zeros(size(tissue_map));
    for c = 1:NumRegions
        if any(ismember(relevant_regions, c))
            tissue_map_eroded = tissue_map_eroded + imerode(tissue_map == c, disk) * c;
        else
            tissue_map_eroded = tissue_map_eroded + (tissue_map == c) * c;
        end
    end
    tissue_map_eroded(tissue_map_eroded == 0) = 1;
end