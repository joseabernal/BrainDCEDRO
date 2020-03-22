%% Compute 3D Fourier transform to each frame in DCE-MRI acquisition
%  This function computes the 3D discrete Fourier transform to each frame
%  in the input DCE-MRI acquisition.
%  
%  Inputs:
%  - HR_SI: 3D/4D high resolution scan
%  - NFrames: Number of frames
%
%  Outputs:
%   - HR_k_space: k-space for each 3D frame
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function k_space = generateKSpace(SI, NFrames)
    if ndims(SI) == 4
        %%Inverse FT to calculate HR k-space image
        k_space=nan(size(SI));
        for iFrame=1:NFrames
            k_space(:,:,:,iFrame)=generateKSpaceFrame(SI(:,:,:,iFrame));
        end
    else
        k_space=generateKSpaceFrame(SI);
    end
end

function k_space = generateKSpaceFrame(SI)
    k_space=fftshift(ifftn(ifftshift(SI)));
end