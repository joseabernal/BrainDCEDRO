%% Smooth signal-time curves using Kalman filtering
%  Smooth signal-time curves using Kalman filtering
%  
%  Inputs:
%  - SI: signal-time curves
%  - t_res_s: temporal resolution [in s]
%  - uses_acceleration: flag indicating whether to use a model with
%  constant acceleration (1) or constant velocity (0)
%  - NIgnore: number of frames to ignore during fitting

%  Outputs:
%   - SI_filt: filtered signal-time curves
%
% (c) Jose Bernal 2021

function SI_filt = filterTimeKalman(SI, t_res_s, uses_acceleration, NIgnore)    
    dt = t_res_s/60;
    
    % Definition of model
    if uses_acceleration
        A = [1 dt dt^2/2; 0 1 dt; 0 0 1];
        Q = [dt^3/6; dt^2/2; dt] * [dt^3/6; dt^2/2; dt]';
        H = [1 0 0];
        R = 1;
    else
        A = [1 dt; 0 1];
        Q = [dt^2/2; dt] * [dt^2/2; dt]';
        H = [1 0];
        R = 1;
    end
    
    func = @(row) apply_filter(A, Q, H, R, SI(row, :)', NIgnore);
    
    voxels = distributed(1:size(SI, 1));

    SI_filt = cell2mat(gather(arrayfun(func, voxels, 'UniformOutput', 0)))';
end

function filtered = apply_filter(A, Q, H, R, signal, NIgnore)
    x = zeros(size(A, 1), 1);
    P = ones(size(A, 1), size(A, 1)) * 0.5;
    
    x(1) = signal(NIgnore);

    Mdl = ssm(A, Q, H, R, 'Mean0', x, 'Cov0', P, 'StateType', 2*ones(size(A, 1), 1));
    
    [filtered, ~, ~] = smooth(Mdl, signal(NIgnore:end));
    filtered = [signal(1:NIgnore-1); filtered(:, 1)];
end