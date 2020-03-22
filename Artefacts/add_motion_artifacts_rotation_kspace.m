%% Induce motion artefacts by creating composite k-space
%  Induce motion artefacts by creating a composite k-space in which some
%  lines are taken from when the person was in position A and the rest from
%  when it moved to position B.
%  
%  Inputs:
%  - k_space_position_b: K-space of the object in position B
%  - k_space_position_a: K-space of the object in position A

%  Outputs:
%   - composite_k_space: Composite k-space
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function composite_k_space = add_motion_artifacts_rotation_kspace(k_space_position_b, k_space_position_a)
    k_space_mix_proportion = rand();
    %YOU HAD BETTER TALK ME THROUGH THIS FUNCTION...
    k_space_lines = zeros(size(k_space_position_b, 2) * size(k_space_position_b, 3), 1);

    k_space_position_a_lines = ceil(k_space_mix_proportion * size(k_space_lines, 1));
    
    k_space_lines(1:k_space_position_a_lines) = 1;
    
    k_space_lines = reshape(k_space_lines, [1, size(k_space_position_b, 2), size(k_space_position_b, 3)]);
    
    position_a_k_space_mask = repmat(k_space_lines, [size(k_space_position_b, 1), 1, 1]);    
    position_b_k_space_mask = ~position_a_k_space_mask;
    
    upper_k_space = position_a_k_space_mask .* k_space_position_b;
    lower_k_space = position_b_k_space_mask .* k_space_position_a;
    
    composite_k_space = upper_k_space + lower_k_space;
end
