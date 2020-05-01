%% Create 3D window to avoid phase warping
%  Creates 3D window to avoid phase warping as a result of resampling
%  
%  Inputs:
%  - NTrue: Dimension of image that defines the "true" object
%  - FoV_mm_HR: Field of view in mm of the high resolution scan
%  - FoV_mm_LR: Field of view in mm of the low resolution scan
%  - res_mm_HR: Resolution in mm of the high resolution scan
%  - is_modified: 3D vector with flags indicating whether to filter or not
%  on x, y, z, respectively.
%
%  Outputs:
%   - W: 3D window
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function W = createWindow3D(NTrue, FoV_mm_HR, FoV_mm_LR, res_mm_HR, is_modified)
    if is_modified(1)
        W1 = butterworth(FoV_mm_HR(1), FoV_mm_LR(1), res_mm_HR(1));
    else
        W1 = no_filter(NTrue(1));
    end
    
    if is_modified(2)
        W2 = butterworth(FoV_mm_HR(2), FoV_mm_LR(2), res_mm_HR(2));
    else
        W2 = no_filter(NTrue(2));
    end
    
    if is_modified(3)
        W3 = butterworth(FoV_mm_HR(3), FoV_mm_LR(3), res_mm_HR(3));
    else
        W3 = no_filter(NTrue(3));
    end

    W = (W1.*W2.').*permute(W3, [3, 2, 1]);
end

%Creates a constant signal
function W = no_filter(N)
    W = ones([N, 1]);
end

%Creates a Butterworth filter with cutoff value = FoV_mm_LR / 2
function W = butterworth(FoV_mm_HR, FoV_mm_LR, res_mm_HR)
    D0 = FoV_mm_LR / 2; %cutoff value
    D = (-FoV_mm_HR/2):res_mm_HR:(FoV_mm_HR/2-res_mm_HR);
    W = 1./(1+(D/D0).^64)';
end

