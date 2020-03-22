%% Compute 3D Fourier transform to each frame in DCE-MRI acquisition
%  This function computes the 3D discrete Fourier transform to each frame
%  in the input image.
%  
%  Inputs:
%  - HR_SI: 4D high resolution scan
%  - NFrames: Number of frames
% DONT THINK NFRAMES IS REQUIRED AS AN INPUT
%
%  Outputs:
%   - HR_k_space: k-space for each 3D frame
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

% YOU COULD GENERALISE THIS FUNCTION BY REMOVING "HR" FROM NAME AND VARIABLE NAMES
function HR_k_space = generateHRKSpace(HR_SI, NFrames)
    %%Inverse FT in each of 3 spatial dimensions to calculate HR k-space image
    HR_k_space=nan(size(HR_SI));
    for iFrame=1:NFrames
        HR_k_space(:,:,:,iFrame)=fftshift(ifftn(ifftshift(HR_SI(:,:,:,iFrame))));
    end
end
