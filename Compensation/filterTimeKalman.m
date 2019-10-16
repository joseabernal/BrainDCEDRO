function LR_SI_filt = filterTimeKalman(LR_SI, t_res_s, NAcq, NFrames)
    LR_SI = reshape(LR_SI, [prod(NAcq), NFrames]);
    
    LR_SI_valid_idx = sum(LR_SI, 2) ~= 0;
    LR_SI_valid = LR_SI(LR_SI_valid_idx, :);
    
    dt = t_res_s/60;
    A = [1 dt dt^2/2; 0 1 dt; 0 0 1];
    Q = [dt^3/6; dt^2/2; dt] * [dt^3/6; dt^2/2; dt]';
    H = [1 0 0];
    R = 1;
    
    x = zeros(3, 1);
    P = ones(3, 3) * 0.5;
    Mdl = ssm(A, Q, H, R, 'Mean0', x, 'Cov0', P, 'StateType', [2, 2, 2]);
    
    func = @(row) apply_filter(Mdl, LR_SI_valid(row, :)');
    
    voxels = distributed(1:size(LR_SI_valid, 1));

    LR_SI_valid_filt = cell2mat(arrayfun(func, voxels, 'UniformOutput', 0))';
    
    LR_SI_filt = zeros([NAcq, NFrames]);
    LR_SI_filt(LR_SI_valid == 1, :) = LR_SI_valid_filt;
    
    LR_SI_filt = reshape(LR_SI_filt, [NAcq, NFrames]);
end

function filtered = apply_filter(Mdl, signal)
    [filtered, ~, ~] = filter(Mdl, signal);
    filtered = filtered(:, 1);
end