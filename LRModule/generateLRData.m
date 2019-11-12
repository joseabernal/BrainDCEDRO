function LR_SI = generateLRData(HR_k_space, trans_matrices, SNR, NDiscard, NAcq, NFrames, k_space_mix_proportion)
    %%Truncate HR k-space data to generate "acquired" k-space data
    LR_k_space = HR_k_space(NDiscard(1)+1:NDiscard(1)+NAcq(1),NDiscard(2)+1:NDiscard(2)+NAcq(2),NDiscard(3)+1:NDiscard(3)+NAcq(3),:);

    %%Apply motion artefact to acquired k-space data here
    %%Add noise
    %%FT acquire k-space data and take magnitude to generate "acquired" image
    LR_SI=nan(size(LR_k_space));
    for iFrame=1:NFrames
        LR_k_space_motion=add_motion_artifacts_rotation_kspace(...
            LR_k_space(:,:,:,iFrame), ...
            apply_affine_transform(LR_k_space(:,:,:,iFrame), trans_matrices{iFrame}, trans_matrices{max(1, iFrame-1)}), ...
            k_space_mix_proportion);
        LR_k_space_noisy=add_awgnoise(LR_k_space_motion, SNR);
        LR_SI(:,:,:,iFrame)=abs(fftshift(fftn(ifftshift(LR_k_space_noisy))));
    end

    %%add zero-filling here. In MSS2, phase-encoding direction is zero-filled %%from 192->256

    % LR_SI = padarray(LR_SI, [0, (NDes(2)-NAcq(2))/2, 0, 0], 0, 'both');
    % LR_k_space = padarray(LR_k_space, [0, (NDes(2)-NAcq(2))/2, 0, 0], 0, 'both');
end

function LR_k_space = apply_affine_transform(LR_k_space, trans_matrix_cur, trans_matrix_des)
    if isempty(trans_matrix_cur)
        trans_matrix_cur = affine3d(eye(4));
    end
    if isempty(trans_matrix_des)
        trans_matrix_des = affine3d(eye(4));
    end
    LR_SI = fftshift(fftn(ifftshift(LR_k_space)));
    LR_SI = imwarp(LR_SI, invert(trans_matrix_cur), 'cubic', 'OutputView', imref3d(size(LR_SI)));
    LR_SI = imwarp(LR_SI, trans_matrix_des, 'cubic', 'OutputView', imref3d(size(LR_SI)));
    LR_k_space = fftshift(ifftn(ifftshift(LR_SI)));
end