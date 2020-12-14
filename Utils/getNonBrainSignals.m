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
%         the mean intensity in each frame.
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function SI=getNonBrainSignals(t_s)  
    SI = zeros(9, length(t_s));
    SI(1, :) = get_signal_in_meninges(t_s);
    SI(2, :) = get_signal_in_muscles(t_s);
    SI(3, :) = get_signal_in_mandible_and_vertebrae(t_s);
    SI(4, :) = get_signal_in_skull_diploe(t_s);
    SI(5, :) = get_signal_in_skull_outer_table(t_s);
    SI(6, :) = get_signal_in_skull_inner_table(t_s);
    SI(7, :) = get_signal_in_skin(t_s);
    SI(8, :) = get_signal_in_adipose_tissue(t_s);
    SI(9, :) = get_signal_in_eyes(t_s);
end

function SI = get_signal_in_meninges(t_s)
    a = 568.6;
    b = 4.596e-5;
    c = 269.2;
    d = -0.002105;
    
    p1 = 4.832;
    p2 = 255;
    
    t_thres = 109.5;
    
    SI = (t_s<=t_thres) .* (p1*t_s+p2) + ...
        (t_s>t_thres) .* (a*exp(b*t_s)+c*exp(d*t_s));
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