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
%  - FOV_mm_Acq: Acquired FOV in mm
%  - NDes: Spatial dimensions of desired FOV region
%  - NAcq: Spatial dimensions of acquired images
%  - NFrames: Number of frames
%  - apply_noise: flag indicating whether to add Rician noise or not

%  Outputs:
%   - LR_SI: "Acquired" 4D (scanning resolution) DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_SI = generateLRData(HR_SI, FOV_mm_True, NTrue, SDnoise, FOV_mm_Acq, NAcq, NFrames, apply_noise)   
    LR_k_space_acq = nan([NAcq, NFrames]);
    for iFrame=1:NFrames
        %% Adjust FOV and acquisition matrices
        LR_k_space = cat(4, ...
            resample(HR_SI(:, :, :, iFrame, 1), FOV_mm_True, NTrue, FOV_mm_Acq, NAcq, NFrames),...
            resample(HR_SI(:, :, :, iFrame, 2), FOV_mm_True, NTrue, FOV_mm_Acq, NAcq, NFrames));

        %% Induce motion artefacts
        % Combine pre and post movement k-spaces to produce motion
        % artifacts
        LR_k_space_motion = add_motion_artifacts_rotation_kspace(...
            LR_k_space(:, :, :, 2), LR_k_space(:, :, :, 1), NAcq);
        
        %% Add noise
        if apply_noise
            LR_k_space_acq(:, :, :, iFrame) = add_noise(LR_k_space_motion, SDnoise, NAcq, 1);
        else
            LR_k_space_acq(:, :, :, iFrame) = LR_k_space_motion;
        end
    end
    
    %% Transform to image space
    LR_SI = abs(generateImageSpace(LR_k_space_acq, NFrames));
end