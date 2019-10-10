%% Generate high resolution region segmentation map
function [HR_tissue_map, LR_tissue_map] = generateHRSegMap(seg_fname, NTrue, NAcq)
    %%Load ground truth
    tissue_map = imresize3(double(load_series(seg_fname, [])), NTrue, 'nearest');
    
    %1-BG 2-CSF 3-NAWM 4-WMH 5-XX  6-GM  7-XX  8-RSL 9-S&S 10-VES 11-spacebrain-skull
    %      1-BG 2-GM  3-NAWM 4-CSF 5-SBS 6-S&S 7-VES 8-RSL 9-WMH
    lut = [1,   6,    3,     2,    11,   9,    10,   8,    4];
    
    HR_tissue_map = lut(tissue_map+1);
    
    LR_tissue_map = uint8(imresize3(HR_tissue_map, NAcq, 'nearest'));
end