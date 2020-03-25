%% Induce motion artefacts by creating composite k-space
%  Induce motion artefacts by creating a composite k-space in which some
%  lines are taken from when the person was in position A and the rest from
%  when it moved to position B.
%  
%  Inputs:
%  - k_space_after_motion: K-space of the object after gross motion
%  - k_space_before_motion: K-space of the object before gross motion
%  - NTrue: Dimension of image that defines the "true" object
%  Outputs:
%   - composite_k_space: Composite k-space
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function composite_k_space = add_motion_artifacts_rotation_kspace(k_space_after_motion, k_space_before_motion, NTrue)
    % how many lines to take from kspace before motion
    k_space_mix_threshold = rand() * NTrue(2) * NTrue(3);
    
    line_count = 0;
    composite_k_space = zeros(size(k_space_before_motion));
    for iSlice=1:NTrue(3)
        for iLine=1:NTrue(2)
            % take only k_space_mix_threshold lines from kspace before
            % motion, and rest from after motion
            if line_count < k_space_mix_threshold
                composite_k_space(:, iLine, iSlice) = k_space_before_motion(:, iLine, iSlice);
            else
                composite_k_space(:, iLine, iSlice) = k_space_after_motion(:, iLine, iSlice);
            end
            line_count = line_count + 1;
        end
    end
end