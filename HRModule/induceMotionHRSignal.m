%% Induce motion artefacts on a 4D high resolution DCE-MRI signal scan
%  Motion is induced by creating composite kspaces for each frame in which
%  some lines of the kspace are acquired when the head was at a certain
%  position and the rest when it moved to another one.
%  
%  Inputs:
%  - HR_SI: 4D high resolution signal-time curves
%  - trans_matrices_pre: Transformation matrices that give information of
%  the head position at the begining of each frame
%  - trans_matrices_post: Transformation matrices that give information of
%  the head position at the end of each frame 
%  - NTrue: Dimension of image that defines the "true" object
%  - NFrames: Number of frames
%  - apply_gross_motion: flag indicating whether to apply gross motion
%  - apply_motion_artefacts: flag indicating whether to induce motion
%  artefacts

%  Outputs:
%   - HR_SI_motion: 4D high resolution signal-time curves with gross motion
%   artefacts
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function [HR_SI_motion_pre, HR_SI_motion_post] = induceMotionHRSignal(HR_SI, trans_matrices_pre, trans_matrices_post, NTrue, NFrames, apply_gross_motion, apply_motion_artefacts)
    if ~apply_gross_motion
        % no modification
        HR_SI_motion_pre = HR_SI;
        HR_SI_motion_post = HR_SI;
    else
        if ~apply_motion_artefacts
            % Pre and post HR SI are the same, motion artefacts do not
            % occur during acquisition
            HR_SI_motion_post = applyGrossMotion(...
                HR_SI, trans_matrices_post, NTrue, NFrames);
            HR_SI_motion_pre = HR_SI_motion_post;
        else
            % Pre and post HR SI are different, motion artefacts occur
            % during acquisition
            HR_SI_motion_pre = applyGrossMotion(...
                HR_SI, trans_matrices_pre, NTrue, NFrames);

            HR_SI_motion_post = applyGrossMotion(...
                HR_SI, trans_matrices_post, NTrue, NFrames);
        end
    end
end