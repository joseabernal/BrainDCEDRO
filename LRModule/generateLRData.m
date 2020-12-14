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
%  - apply_noise: flag indicating whether to add noise or not
%  - apply_lowpass: flag indicating whether to apply a low pass filter on
%                   the acquired k-space

%  Outputs:
%   - LR_SI: "Acquired" 4D (scanning resolution) DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function LR_SI = generateLRData(HR_SI, FOV_mm_True, NTrue, SDnoise, FOV_mm_Acq, NAcq, NFrames, apply_noise, apply_lowpass)   
    LR_k_space_acquired = nan([NAcq, NFrames]);
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
            LR_k_space_acquired(:, :, :, iFrame) = add_noise(LR_k_space_motion, SDnoise, NAcq, 1);
        else
            LR_k_space_acquired(:, :, :, iFrame) = LR_k_space_motion;
        end
        
        %% Apply low pass filter to reduce ringing artefacts
        if apply_lowpass
            res_mm_Acq=FoV_mm_Acq./NAcq; %LR resolution
            k_FoV_perMM_LR=1./res_mm_Acq; %LR FoV in k-space
            k_res_perMM_LR=1./FoV_mm_Acq; %LR resolution in k-space

            LR_k_space_acquired = LR_k_space_acquired .* createBesselWindow3D(k_FoV_perMM_LR, k_res_perMM_LR);
        end
    end

    %% Transform to image space
    LR_SI = abs(generateImageSpace(LR_k_space_acquired, NFrames));
end

function W = createBesselWindow3D(k_FoV_perMM, k_res_perMM)
    W1 = bessel(k_FoV_perMM(1), k_res_perMM(1));
    W2 = bessel(k_FoV_perMM(2), k_res_perMM(2));
    W3 = bessel(k_FoV_perMM(3), k_res_perMM(3));
    
    W = (W1'.*W2).*reshape(W3, 1, 1, []);
end

function W = bessel(k_FoV_perMM, k_res_perMM)
    n = 5; % filter order
    D0 = k_FoV_perMM / 2; %cutoff value
    D = (-k_FoV_perMM/2):k_res_perMM:(k_FoV_perMM/2-k_res_perMM);

    [b, a] = besself(n, D0);

    W = freqs(b, a, D);
end