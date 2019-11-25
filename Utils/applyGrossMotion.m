%% Apply gross motion to DCE-MRI acquisition
%  This function applies the gross motion to a given 
%  in the input DCE-MRI acquisition.
%  
%  Inputs:
%  - SI: 4D DCE-MRI signal
%  - trans_matrices: Transformation matrices per frame
%  - Dim: Dimension of each frame
%  - NFrames: NUmber of frames
%
%  Outputs:
%   - SI: 4D DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function SI = applyGrossMotion(SI, trans_matrices, Dim, NFrames)
    %%Apply gross motion to each frame
    for iFrame = 2:NFrames
        SI(:, :, :, iFrame) = imwarp(SI(:, :, :, iFrame), trans_matrices{iFrame}, 'cubic', 'OutputView', imref3d(Dim));
    end
end