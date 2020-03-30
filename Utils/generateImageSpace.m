%% Compute 3D Fourier transform to each frame in DCE-MRI acquisition
%  This function computes the 3D discrete Fourier transform to each frame
%  in the input DCE-MRI acquisition.
%  
%  Inputs:
%  - HR_SI: 3D/4D high resolution scan
%  - NFrames: Number of frames
%
%  Outputs:
%   - SI: image space for each 3D frame
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function SI = generateImageSpace(k_space, NFrames)
    if ndims(k_space) == 4
        %%Inverse FT to calculate HR k-space image
        SI=nan(size(k_space));
        for iFrame=1:NFrames
            SI(:,:,:,iFrame)=generateImageSpaceFrame(k_space(:,:,:,iFrame));
        end
    else
        SI=generateImageSpaceFrame(k_space);
    end
end

function k_space = generateImageSpaceFrame(SI)
    k_space=abs(fftshift(fftn(ifftshift(SI))));
end