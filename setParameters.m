%%Imaging parameters
FOV_mm=[240 240 4*42]; %46 slices acquired in MSS2 (top/bottom 2 are deleted post-acquisition)
NTrue=[512 512 512]; %dimension of image that defines the "true" object
% NAcq=[256 192 42]; %number of points acquired; for MSS2: 256x192x46
NAcq=[256 256 42]; %number of points acquired; for MSS2: 256x192x46
NDes=[256 256 42]; %dimension of MSS2 image
NFrames=21; %number of time frames, =21 for MSS2
t_res_s=73; %temporal resolution
t_acq_s=t_res_s*NFrames; %total acquisition time
t_start_s=t_res_s; %injection starts at this time
TR_s=8.24e-3;
TE_s=3.1e-3;
FA_deg=12; %flip angle

%High resolution parameters
save_HR_scans = true;

%Low resolution parameters
save_LR_scans = false;

%Type of experiment
region_wise_computations = true;

%Distortion extent
SNR = Inf;
motion_extent = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%Correction params
use_correction = false;

%%Tissue parameters for each tissue type
is_voxel_wise = true;
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct); %includes pre-contrast data points (zeros)

%BG CSF NAWM WMH XX GM XX RSL S&S VES spacebrain-skull
NumRegions = 11;
T10_s     = [0   4.22  0.99  1.10  nan 1.34  nan 1.27 1.39 1.46 2.67]; % MSS2 population average values except for S&S, VES, SBS
T2s0_s    = [nan 1     1     1     1   1     1   1    1    1    1   ];
PS_perMin = [nan 0     2.75  3.91  nan 3.85  nan 5.02 0    0    0   ]*1E-4; %permeability
vP=         [nan 0     0.57  0.72  nan 1.20  nan 0.72 0    100  0   ]*1E-2; %plasma volume fraction
S0=         [nan 6900  7300  8200  nan 7000  nan 4537 nan  9000  nan ]; %equilibrium signal (~proton density)
r1_perSpermM=4.2; %R1 relaxivity;
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

%derive further parameters
NDiscard =(NTrue - NAcq)/2; %number of k-space points to discard on either side when computing the acquired data
HRes_mm = FOV_mm./NTrue;
LRes_mm = FOV_mm./NDes;

%%Input parameters
seg_fname = ['input', filesep, 'sub-S03_ses-SES01_anat_sub-S03_ses-SES01_run-02_T1w_seg_wmhrsl.nii'];
dataset = {'MSSB330','0101761104','19438','19547'};

ref_seg_fname = sprintf(ref_seg_fname_pattern, dataset{1});
ref_enh_fname = sprintf(ref_enh_fname_pattern, dataset{1});
ref_i0_fname = sprintf(ref_i0_fname_pattern, dataset{1});

trans_matrices = cell(NFrames, 1);
for iFrame = 2:NFrames
    trans_matrix_fname = sprintf(trans_matrix_pattern, dataset{2}, dataset{4},iFrame);
    trans_matrices{iFrame} = invert(affine3d(load(trans_matrix_fname, '-ASCII')'));
end
