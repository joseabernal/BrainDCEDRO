function k_space = add_motion_artifacts(k_space, probability_missing_line)
    zeroed_lines = rand(size(k_space, 1), 1) < probability_missing_line;

    k_space(zeroed_lines, :, :) = 0;
    
    disp(sum(zeroed_lines))
end