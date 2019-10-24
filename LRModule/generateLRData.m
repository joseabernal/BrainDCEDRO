%%Truncate HR k-space data to generate "acquired" k-space data
function LR_SI = generateLRData(HR_k_space, probability_missing_line, SNR, NDiscard, NAcq, NFrames)
    LR_k_space = HR_k_space(NDiscard(1)+1:NDiscard(1)+NAcq(1),NDiscard(2)+1:NDiscard(2)+NAcq(2),NDiscard(3)+1:NDiscard(3)+NAcq(3),:);

    %%Apply motion artefact to acquired k-space data here
    %%Add noise
    %%FT acquire k-space data and take magnitude to generate "acquired" image
    LR_SI=nan(size(LR_k_space));
    for iFrame=1:NFrames
        LR_k_space_motion=add_motion_artifacts(LR_k_space(:,:,:,iFrame), probability_missing_line);
        LR_k_space_noisy=add_awgnoise(LR_k_space_motion, SNR);
        LR_SI(:,:,:,iFrame)=abs(fftshift(fftn(ifftshift(LR_k_space_noisy))));
    end

    %%add zero-filling here. In MSS2, phase-encoding direction is zero-filled %%from 192->256

    % LR_SI = padarray(LR_SI, [0, (NDes(2)-NAcq(2))/2, 0, 0], 0, 'both');
    % LR_k_space = padarray(LR_k_space, [0, (NDes(2)-NAcq(2))/2, 0, 0], 0, 'both');
end