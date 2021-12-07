%% Denoise parameter maps using histogram analysis
%  Estimates and denoises parameter maps using histogram analysis
%  
%  Inputs:
%  - input: Parameter map to summarise
%  - tissue_map: 3D segmentation map
%  - NumBins: Number of bins
%  - NumRegions: Number of regions in segmentation map

%  Outputs:
%   - ROI_values: mean value per region of interest
%
% (c) Jose Bernal 2021

function ROI_values = denoise_histogram_analysis(input, tissue_map, NumBins, NumRegions)
    ROI_values = nan(NumRegions, 1);
    for region=1:NumRegions
        mask = tissue_map == region;
        
        data_in_ROI = input(mask);
        
        [N,edges,bin] = histcounts(data_in_ROI, NumBins);
        
        localNumBins = min(length(bin), NumBins);
        
        ref_bin = find(diff(sign(edges)) == 2);
        
        filtered_data = [];
        if isempty(ref_bin)
            filtered_data = data_in_ROI;
        else
            count_in_zero_bin = sum(data_in_ROI(bin==ref_bin)<0);

            noisy_count = [N(1:ref_bin-1), 2*count_in_zero_bin, N(ref_bin-1:-1:1)];
            noisy_count = [noisy_count, zeros(1, max(localNumBins-length(noisy_count),0))];
            
            for binId=1:localNumBins
                data_in_bin = data_in_ROI(bin==binId);
                data_in_bin = sort(data_in_bin);

                lower_bound = min(length(data_in_bin), noisy_count(binId));

                filtered_data = [filtered_data; data_in_bin(lower_bound+1:end)];
            end
        end

        ROI_values(region) = nanmean(filtered_data);
    end
end