%% Add Riccian noise to k-space
%  Add Rician noise to input DCE-MRI k-space.
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
%  - k_space: Input k-space
%  - SDnoise: Standard deviation of the noise
%  - NAcq: Number of acquired
%  - NFrames: Number of frames

%  Outputs:
%   - k_space_noisy: Noisy k-space
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function k_space_noisy=add_noise(k_space, SDnoise, NAcq, NFrames)
    N_voxels = prod(NAcq);

    SD = SDnoise/sqrt(2-pi/2) * 1/sqrt(2*N_voxels);

    %% Generate Rician noise
    noise = normrnd(0, SD, [NAcq, NFrames]) + 1i*normrnd(0, SD, [NAcq, NFrames]);
    
    %% Add noise
    k_space_noisy = k_space + noise;
end