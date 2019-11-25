function k_space = add_motion_artifacts_phase_shift(k_space, probability_missing_line)
   phase = angle(k_space);
   magnitude = abs(k_space);
   
   k_space = magnitude.*exp(1i*phase-1i*pi/4); % -pi/4 shift
end