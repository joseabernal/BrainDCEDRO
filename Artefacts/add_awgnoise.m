%% Add additive white Gaussian noise to input signal
%  Add additive white Gaussian noise to input DCE-MRI signal.
%  We represent the signal-to-noise ratio (SNR) as the quotient
%  between the mean signal value and the standard deviation of the
%  background noise. The SNR of the real scans should be similar to that of
%  our simulations, i.e. SNR_real = SNR_sim or mu_real/SD_real =
%  mu_sim/SD_sim. Thus, the standard deviation of the noise in
%  our simulations should be equal to (mu_sim*SD_real)/mu_real. First, we 
%  estimated the standard deviation of the noise in real scans by computing 
%  the mean signal within the normal-appearing white matter region and the
%  standard deviation of the noise from background area. Second, we multiplied
%  the estimated standard deviation by sqrt(2-pi/2). Third, we computed the
%  standard deviation value for our simulations.
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
    AWGN = normrnd(0, SDnoise, [NAcq, NFrames]);% + 1i*normrnd(0, SDnoise, [NAcq, NFrames]);
    
    %% Add additive white Gaussian noise
    SI_noisy = SI + AWGN;
end