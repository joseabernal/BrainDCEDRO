%% Modify FOV and resample accordingly
%  Modify field of view to mimic slab-selective RF excitation
%  
%  Inputs:
%  - HR_SI: 3D high resolution image
%  - FoV_mm_True: Original FOV in mm
%  - NTrue: Dimension of image that defines the "true" object
%  - FoV_mm_Des: Desired FOV in mm
%  - NDes: Spatial dimensions of desired FOV region
%  - NFrames: Number of frames
%
%  Outputs:
%   - LR_k: k-space of the 3D low resolution version the input
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function LR_k = modifyFOV(HR_SI, FoV_mm_True, NTrue, FoV_mm_Des, NDes, NFrames)
    res_mm_HR=FoV_mm_True./NTrue; %HR resolution
    res_mm_LR=FoV_mm_Des./NDes; %LR resolution

    k_FoV_perMM_HR=1./res_mm_HR; %HR FoV in k-space
    k_res_perMM_HR=1./FoV_mm_True; %HR resolution in k-space
    k_FoV_perMM_LR=1./res_mm_LR; %LR FoV in k-space
    k_res_perMM_LR=1./FoV_mm_Des; %LR resolution in k-space

    [x_mm_HR, y_mm_HR, z_mm_HR] = meshgrid(...
        (-FoV_mm_True(2)/2):res_mm_HR(2):(FoV_mm_True(2)/2-res_mm_HR(2)),...    
        (-FoV_mm_True(1)/2):res_mm_HR(1):(FoV_mm_True(1)/2-res_mm_HR(1)),...
        (-FoV_mm_True(3)/2):res_mm_HR(3):(FoV_mm_True(3)/2-res_mm_HR(3))); %HR position values in image
    [kx_perMM_HR, ky_perMM_HR, kz_perMM_HR] = meshgrid(...
        (-k_FoV_perMM_HR(2)/2):k_res_perMM_HR(2):(k_FoV_perMM_HR(2)/2-k_res_perMM_HR(2)),...
        (-k_FoV_perMM_HR(1)/2):k_res_perMM_HR(1):(k_FoV_perMM_HR(1)/2-k_res_perMM_HR(1)),...
        (-k_FoV_perMM_HR(3)/2):k_res_perMM_HR(3):(k_FoV_perMM_HR(3)/2-k_res_perMM_HR(3)));  %HR position values in k-space
    x_mm_LR=[(-FoV_mm_Des(2)/2), (FoV_mm_Des(2)/2-res_mm_LR(2))];
    y_mm_LR=[(-FoV_mm_Des(1)/2), (FoV_mm_Des(1)/2-res_mm_LR(1))];
    z_mm_LR=[(-FoV_mm_Des(3)/2), (FoV_mm_Des(3)/2-res_mm_LR(3))];
    [kx_perMM_LR, ky_perMM_LR, kz_perMM_LR] = meshgrid(...
        (-k_FoV_perMM_LR(2)/2):k_res_perMM_LR(2):(k_FoV_perMM_LR(2)/2-k_res_perMM_LR(2)),...
        (-k_FoV_perMM_LR(1)/2):k_res_perMM_LR(1):(k_FoV_perMM_LR(1)/2-k_res_perMM_LR(1)),...
        (-k_FoV_perMM_LR(3)/2):k_res_perMM_LR(3):(k_FoV_perMM_LR(3)/2-k_res_perMM_LR(3)));  %LR position values in k-space

    SF=prod(FoV_mm_True./FoV_mm_Des); %Scaling factor

    is_within_LR_FoV=(x_mm_HR>=min(x_mm_LR)) & (x_mm_HR<=max(x_mm_LR)) & ...
        (y_mm_HR>=min(y_mm_LR)) & (y_mm_HR<=max(y_mm_LR)) & ...
        (z_mm_HR>=min(z_mm_LR)) & (z_mm_HR<=max(z_mm_LR)); %find HR voxels within LR FoV

    is_modified = FoV_mm_True~=FoV_mm_Des; %flag indicating whether to filter or not on a certain direction
    
    W = createWindow3D(NTrue, FoV_mm_True, FoV_mm_Des, res_mm_HR, is_modified); %create 3D window to reduce phase warping
    
    HR_SI_windowed = (HR_SI .* W) .* is_within_LR_FoV;  %discard outlier lines and multiply by window
    
    HR_k = generateKSpace(HR_SI_windowed, NFrames); %compute corresponding k-space
    
    LR_k = SF * interp3(kx_perMM_HR, ky_perMM_HR, kz_perMM_HR, HR_k, ...
            kx_perMM_LR, ky_perMM_LR, kz_perMM_LR, 'spline'); %resample
end