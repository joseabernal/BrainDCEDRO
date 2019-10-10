function HR_k_space = generateHRKSpace(HR_SI, trans_matrices, NTrue, NFrames)
    %%Apply gross motion to each frame
    for iFrame = 2:NFrames
        HR_SI(:, :, :, iFrame) = imwarp(HR_SI(:, :, :, iFrame), trans_matrices{iFrame}, 'cubic', 'OutputView', imref3d(NTrue));
    end

    %%Inverse FT to calculate HR k-space image
    HR_k_space=nan(size(HR_SI));
    for iFrame=1:NFrames
        HR_k_space(:,:,:,iFrame)=fftshift(ifftn(ifftshift(HR_SI(:,:,:,iFrame))));
    end
end