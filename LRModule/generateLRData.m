%% "Acquire" low resolution signal
%  Truncate high resolution DCE-MRI signal to produce the "acquired" low
%  resolution DCE-MRI signal. The signal is affected by noise, determined
%  by the signal-to-noise ratio, and motion artefacts, give by the
%  transformation matrices.
%  
%  Inputs:
%  - HR_k_space: K-space of each high resolution frame
%  - trans_matrices: Transformation matrices
%  - SNR: Signal-to-noise ratio
%  - NDiscard: Number of k-space lines to discard
%  - NAcq: Number of acquired
%  - NFrames: Number of frames

%  Outputs:
%   - LR_SI: "Acquired" 4D low resolution DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_SI = generateLRData(HR_k_space, trans_matrices, SNR, NDiscard, NAcq, NFrames)
    %%Truncate HR k-space data to generate "acquired" k-space data
    LR_k_space = HR_k_space(NDiscard(1)+1:NDiscard(1)+NAcq(1),NDiscard(2)+1:NDiscard(2)+NAcq(2),NDiscard(3)+1:NDiscard(3)+NAcq(3),:);

    LR_SI=nan(size(LR_k_space));
    for iFrame=1:NFrames
        %%Apply motion artefact to acquired k-space data
        LR_k_space_motion=add_motion_artifacts_rotation_kspace(...
            LR_k_space(:,:,:,iFrame), ...
            apply_affine_transform(LR_k_space(:,:,:,iFrame), trans_matrices{iFrame}, trans_matrices{max(1, iFrame-1)}));
        
        %%Add noise
        LR_k_space_noisy=add_awgnoise(LR_k_space_motion, SNR);
        
        %%FT acquire k-space data and take magnitude to generate "acquired" image
        LR_SI(:,:,:,iFrame)=abs(fftshift(fftn(ifftshift(LR_k_space_noisy))));
    end
end

function LR_k_space = apply_affine_transform(LR_k_space, trans_matrix_cur, trans_matrix_des)
    if isempty(trans_matrix_cur)
        trans_matrix_cur = affine3d(eye(4));
    end
    if isempty(trans_matrix_des)
        trans_matrix_des = affine3d(eye(4));
    end
	
	% Apply transformation matrix on the spatial domain and transform back to k-space
    LR_SI = fftshift(fftn(ifftshift(LR_k_space)));
    LR_SI = imwarp(LR_SI, invert(trans_matrix_cur), 'cubic', 'OutputView', imref3d(size(LR_SI)));
    LR_SI = imwarp(LR_SI, trans_matrix_des, 'cubic', 'OutputView', imref3d(size(LR_SI)));
    LR_k_space = fftshift(ifftn(ifftshift(LR_SI)));
end