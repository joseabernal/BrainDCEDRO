function k_space = add_motion_artifacts(k_space, probability_missing_line)
    zeroed_lines = rand(size(k_space, 1), 1, size(k_space, 3)) < probability_missing_line;
    
    disp(sum(zeroed_lines(:)))
    
    zeroed_lines = repmat(zeroed_lines, [1, size(k_space, 2), 1]);

    k_space(zeroed_lines) = 0;
end