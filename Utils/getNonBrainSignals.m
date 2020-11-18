%% Create extra-cerebral signal-time curves
%  Create signal-time curves for nine extra-cerebral regions considered in
%  the digital reference objects. These functions are based on data from
%  the MSSII study.
%  
%  Inputs:
%  - t_s: time points (in seconds)
%  - SI0: Pre-contrast signal intensity
%
%  Outputs:
%   - SI: Signal-time curves of extra-cerebral regions (matrix containing 9
%   rows [regions] and as many time points as in t_s.
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function SI=getNonBrainSignals(t_s, SI0)
    Enh = [get_enhancement_in_meninges(t_s)'; get_enhancement_in_muscles(t_s)'; ...
        get_enhancement_in_mandible_and_vertebrae(t_s)'; get_enhancement_in_skull_diploe(t_s)'; ...
        get_enhancement_in_skull_outer_table(t_s)'; get_enhancement_in_skull_inner_table(t_s)'; ...
        get_enhancement_in_skin(t_s)'; get_enhancement_in_adipose_tissue(t_s)'; ...
        get_enhancement_in_eyes(t_s)'];
    
    SI = zeros(9, 1+length(t_s));
    SI(:, 1) = [7, 8, 9, 10, 11, 12, 15, 16, 17]; % labels in seg map
    SI(:, 2:end) = (1+Enh/100) .* SI0;
end

function Enh = get_enhancement_in_meninges(t_s)
    a = -2.432e7;
    b = -0.3469;
    c = 78.37;
    d = -0.0004956;
    
    Enh = a*exp(b*t_s)+c*exp(d*t_s);
end

function Enh = get_enhancement_in_muscles(t_s)
    a = 34.33; 
    b = -0.0001196;
    c = -64.21;
    d = -0.0171;
    
    Enh = a*exp(b*t_s)+c*exp(d*t_s);
end

function Enh = get_enhancement_in_mandible_and_vertebrae(t_s)
    a = -263.4;
    b = -0.5585;
    c = 35.29;
    
    Enh = a*t_s.^b+c;
end

function Enh = get_enhancement_in_skull_diploe(t_s)
    a = 0;

    Enh = a*t_s;
end

function Enh = get_enhancement_in_skull_outer_table(t_s)
    a = 129.7;
    b = 0.06482;
    c = -160.1;
    
    Enh = a*t_s.^b+c;
end

function Enh = get_enhancement_in_skull_inner_table(t_s)
    a = -617.1;
    b = -0.6995;
    c = 51.4;
    
    Enh = a*t_s.^b+c;
end

function Enh = get_enhancement_in_skin(t_s)
    a = 66.09;
    b = -7.621e-5;
    c = -86.48;
    d = -0.00734;
    
    Enh = a*exp(b*t_s)+c*exp(d*t_s);
end

function Enh = get_enhancement_in_adipose_tissue(t_s)
    a = 0;
   
    Enh = a*t_s;
end

function Enh = get_enhancement_in_eyes(t_s)
    a = 0;

    Enh = a*t_s;
end