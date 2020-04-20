%% "Acquire" scanning resolution signal
%  Truncate high resolution DCE-MRI signal to produce the "acquired" scanning
%  resolution DCE-MRI signal. The signal is affected by noise, determined
%  by the signal-to-noise ratio.
%  
%  Inputs:
%  - HR_k_space: K-space of each high resolution frame
%  - trans_matrices: Transformation matrices
%  - SDnoise: Standard deviation of noise
%  - NDiscard: Number of k-space lines to discard on each side of echo
%  - NAcq: Sptial dimensions of acquired images
%  - NFrames: Number of frames
%  - apply_awgn: flag indicating whether to add white Gaussian noise or not

%  Outputs:
%   - LR_SI: "Acquired" 4D (scanning resolution) DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_SI = generateLRData(HR_k_space, SDnoise, NDiscard, NAcq, NFrames, apply_awgn)
    %%Truncate HR k-space data symmetrically to generate "acquired" k-space data
    LR_k_space = HR_k_space(...
        NDiscard(1)+1:NDiscard(1)+NAcq(1),...
        NDiscard(2)+1:NDiscard(2)+NAcq(2),...
        NDiscard(3)+1:NDiscard(3)+NAcq(3),:,:);
    
    LR_k_space_motion = nan([NAcq, NFrames]);
    for iFrame=1:NFrames
        LR_k_space_motion(:, :, :, iFrame) = add_motion_artifacts_rotation_kspace(...
            LR_k_space(:, :, :, iFrame, 2), LR_k_space(:, :, :, iFrame, 1), NAcq);
    end

    %% Transform to image space
    LR_SI = generateImageSpace(LR_k_space_motion, NFrames);

    if apply_awgn
        %% Add white Gaussian noise
        LR_SI = add_awgnoise(LR_SI, SDnoise, NAcq, NFrames);
    end
    
    LR_SI = abs(LR_SI);
end