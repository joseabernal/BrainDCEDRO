%% "Acquire" scanning resolution signal
%  Truncate high resolution DCE-MRI signal to produce the "acquired" scanning
%  resolution DCE-MRI signal. The signal is affected by noise, determined
%  by the signal-to-noise ratio.
%  
%  Inputs:
%  - HR_SI: 4D high resolution image
%  - FOV_mm_True: Default FOV in mm
%  - NTrue: Dimension of image that defines the "true" object
%  - SDnoise: Standard deviation of noise
%  - FOV_mm_Des: Desired FOV in mm
%  - NDes: Spatial dimensions of desired FOV region
%  - NAcq: Spatial dimensions of acquired images
%  - NFrames: Number of frames
%  - apply_awgn: flag indicating whether to add white Gaussian noise or not

%  Outputs:
%   - LR_SI: "Acquired" 4D (scanning resolution) DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_SI = generateLRData(HR_SI, FOV_mm_True, NTrue, SDnoise, FOV_mm_Des, NDes, NAcq, NFrames, apply_awgn)   
    LR_k_space_motion = nan([NAcq, NFrames]);
    for iFrame=1:NFrames
        %% Adjust FOV and acquisition matrices
        LR_k_space = cat(4, ...
            modifyFOV(HR_SI(:, :, :, iFrame, 1), FOV_mm_True, NTrue, FOV_mm_Des, NDes, NFrames),...
            modifyFOV(HR_SI(:, :, :, iFrame, 2), FOV_mm_True, NTrue, FOV_mm_Des, NDes, NFrames));

        %% Truncate frequencies
        NDiscard = floor((NDes(1)-NAcq(1))/2);
        LR_k_space_trunc = LR_k_space(NDiscard:NAcq(1)+NDiscard-1, :, :, :);

        %% Induce motion artefacts
        % Combine pre and post movement k-spaces to produce motion
        % artifacts
        LR_k_space_motion(:, :, :, iFrame) = add_motion_artifacts_rotation_kspace(...
            LR_k_space_trunc(:, :, :, 2), LR_k_space_trunc(:, :, :, 1), NAcq);
    end

    %% Transform to image space
    LR_SI = generateImageSpace(LR_k_space_motion, NFrames);

    if apply_awgn
        %% Add white Gaussian noise
        LR_SI = add_awgnoise(LR_SI, SDnoise, NAcq, NFrames);
    end

    LR_SI = abs(LR_SI);
end