%% Erode segmentation map
%  Generate 3D low resolution segmentation map from a high resolution
%  segmentation map
%  
%  Inputs:
%  - tissue_map: segmentation map
%  - erosion_extent: radius of the structural element
%  - NumRegions: Number of regions of interest

%  Outputs:
%   - tissue_map_eroded: Eroded low resolution segmentation map
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function tissue_map_eroded = erode_seg_map(tissue_map, erosion_extent, NumRegions)
    disk = strel('sphere', erosion_extent);
    tissue_map_eroded = zeros(size(tissue_map));
    for c = 1:NumRegions
        tissue_map_eroded = tissue_map_eroded + imerode(tissue_map == c, disk) * c;
    end
    tissue_map_eroded(tissue_map_eroded == 0) = 1;
end