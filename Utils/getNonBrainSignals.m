%% Create extra-cerebral signal-time curves
%  Create signal-time curves for nine extra-cerebral regions considered in
%  the digital reference objects. These functions are based on data from
%  the MSSII study.
%  
%  Inputs:
%  - t_s: time points (in seconds)
%
%  Outputs:
%   - SI: Signal-time curves of extra-cerebral regions. 2D matrix with signal
%         profile for each non-brain structure. Each row corresponds to the
%         tissue class number, followed by the mean intensity in each frame.
%         The tissue class number and its description are the following:
%          7  - Meninges
%          8  - Muscles and eyes
%          9  - Mandible and vertebrae
%          10 - Skull diploe
%          11 - Skull outer table
%          12 - Skull inner table
%          15 - Skin
%          16 - Adipose tissue
%          17 - Eyes
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function SI=getNonBrainSignals(t_s)  
    SI = zeros(9, 1+length(t_s));
    SI(:, 1) = [7, 8, 9, 10, 11, 12, 15, 16, 17]; % labels in seg map
    SI(1, 2:end) = get_signal_in_meninges(t_s);
    SI(2, 2:end) = get_signal_in_muscles(t_s);
    SI(3, 2:end) = get_signal_in_mandible_and_vertebrae(t_s);
    SI(4, 2:end) = get_signal_in_skull_diploe(t_s);
    SI(5, 2:end) = get_signal_in_skull_outer_table(t_s);
    SI(6, 2:end) = get_signal_in_skull_inner_table(t_s);
    SI(7, 2:end) = get_signal_in_skin(t_s);
    SI(8, 2:end) = get_signal_in_adipose_tissue(t_s);
    SI(9, 2:end) = get_signal_in_eyes(t_s);
end

function SI = get_signal_in_meninges(t_s)
    a = 269.2;
    b = -0.002105;
    c = 568.6;
    d = 4.596e-05;
    
    SI = a*exp(b*t_s)+c*exp(d*t_s);
end

function SI = get_signal_in_muscles(t_s)
    a = 552.8; 
    b = -3.134e-05;
    c = -254.7;
    d = -0.01641;
    
    SI = a*exp(b*t_s)+c*exp(d*t_s);
end
    
function SI = get_signal_in_mandible_and_vertebrae(t_s)
    a = -1135;
    b = -0.4982;
    c = 707.4;
    
    SI = a*t_s.^b+c;
end

function SI = get_signal_in_skull_diploe(t_s)
    a = 367.306;

    SI = a*ones(size(t_s));
end

function SI = get_signal_in_skull_outer_table(t_s)
    a = -382.1;
    b = -0.0491;
    c = 436.4;
    
    SI = a*t_s.^b+c;
end

function SI = get_signal_in_skull_inner_table(t_s)
    a = -1137;
    b = -0.8439;
    c = 226.9;
    
    SI = a*t_s.^b+c;
end

function SI = get_signal_in_skin(t_s)
    a = 1383;
    b = -3.499e-5;
    c = -698.6;
    d = -0.006866;
    
    SI = a*exp(b*t_s)+c*exp(d*t_s);
end

function SI = get_signal_in_adipose_tissue(t_s)
    a = 1064.07;
   
    SI = a*ones(size(t_s));
end

function SI = get_signal_in_eyes(t_s)
    a = 309.60;
    
    SI = a*ones(size(t_s));
end