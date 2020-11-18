%% Apply gross motion to DCE-MRI acquisition
%  This function applies the gross motion to a given 
%  in the input DCE-MRI acquisition.
%  
%  Inputs:
%  - SI: 3D/4D DCE-MRI signal
%  - trans_matrices: Transformation matrices per frame
%  - Dim: Dimension of each frame
%  - NFrames: NUmber of frames
%
%  Outputs:
%   - SI: 3D/4D DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function SI = applyGrossMotion(SI, trans_matrices, Dim, NFrames)
    if ndims(SI) == 4
        %%Apply gross motion to each frame
        for iFrame = 1:NFrames
            SI(:, :, :, iFrame) = applyGrossMotionFrame(SI(:, :, :, iFrame), trans_matrices{iFrame}, Dim);
        end
    else
        SI = applyGrossMotionFrame(SI, trans_matrices, Dim);
    end
end


function SI = applyGrossMotionFrame(SI, trans_matrices, Dim)
    SI = imwarp(SI, trans_matrices, 'cubic', 'OutputView', imref3d(Dim));
end