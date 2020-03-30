%% Induce motion artefacts on a 4D high resolution DCE-MRI signal scan
%  Motion is induced by creating composite kspaces for each frame in which
%  some lines of the kspace are acquired when the head was at a certain
%  position and the rest when it moved to another one.
%  
%  Inputs:
%  - HR_SI_clean: 4D high resolution signal-time curves
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
%   - HR_SI_motion: 4D high resolution signal-time curves with motion
%   artefacts
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function HR_SI_motion = induceMotionHRSignal(HR_SI_clean, trans_matrices_pre, trans_matrices_post, NTrue, NFrames, apply_gross_motion, apply_motion_artefacts)
    if ~apply_gross_motion
        HR_SI_motion = HR_SI_clean;
    else
        if ~apply_motion_artefacts
            HR_SI_motion = zeros([NTrue, NFrames]);
            for iFrame=1:NFrames
                % apply gross motion to high resolution signal
                HR_frame_gross_motion_post = applyGrossMotion(...
                    HR_SI_clean(:, :, :, iFrame), trans_matrices_post{iFrame}, NTrue, NFrames);

                % compute the corresponding high resolution k-space
                HR_frame_k_space_post = generateKSpace(HR_frame_gross_motion_post, NFrames);

                HR_SI_motion(:, :, :, iFrame) = abs(generateImageSpace(HR_frame_k_space_post));
            end
        else
            HR_SI_motion = zeros([NTrue, NFrames]);
            for iFrame=1:NFrames
                % apply gross motion to high resolution signal
                HR_frame_gross_motion_pre = applyGrossMotion(...
                    HR_SI_clean(:, :, :, iFrame), trans_matrices_pre{iFrame}, NTrue, NFrames);
                HR_frame_gross_motion_post = applyGrossMotion(...
                    HR_SI_clean(:, :, :, iFrame), trans_matrices_post{iFrame}, NTrue, NFrames);

                % compute the corresponding high resolution k-space
                HR_frame_k_space_pre = generateKSpace(HR_frame_gross_motion_pre, NFrames);
                HR_frame_k_space_post = generateKSpace(HR_frame_gross_motion_post, NFrames);

                % add motion artefacts by creating composite kspaces between
                % kspaces pre and post motion
                HR_frame_k_space_motion = add_motion_artifacts_rotation_kspace(...
                    HR_frame_k_space_post, HR_frame_k_space_pre, NTrue);

                HR_SI_motion(:, :, :, iFrame) = abs(generateImageSpace(HR_frame_k_space_motion));
            end
        end
    end
end