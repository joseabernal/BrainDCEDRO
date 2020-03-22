%% Add additive white Gaussian noise to input signal
%  Add additive white Gaussian noise to input DCE-MRI signal
%  
%  Inputs:
%  - SI: DCE-MRI signal
%  - SDnoise: Standard deviation of the noise
%  - NAcq: Number of acquired
%  - NFrames: Number of frames

%  Outputs:
%   - SI_noisy: Noise DCE-MRI signal
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function SI_noisy=add_awgnoise(SI, SDnoise, NAcq, NFrames)
    %% Generate additive white Gaussian noise (AWGN)
    AWGN = 1/sqrt(2) * (normrnd(0, SDnoise, [NAcq, NFrames]) + 1i*normrnd(0, SDnoise, [NAcq, NFrames]));
    
    %% Add additive white Gaussian noise
    SI_noisy = SI + AWGN;
end