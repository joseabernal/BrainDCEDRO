%%Imaging parameters
FOV_mm=[240 240 175]; %46 slices acquired in MSS2 (top/bottom 2 are deleted post-acquisition)
NTrue=[480 480 350]; %dimension of image that defines the "true" object
NAcq=[256 46 192]; %number of points acquired; for MSS2: 256x192x46
NDes=[256 46 192]; %dimension of MSS2 image
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
save_LR_scans = true;

%Type of experiment
regression_type = 'linear'; %either robust or linear
region_wise_computations = false;

%Distortion extent
SNR = 43; %Estimated SNR value in MSSII
k_space_mix_proportion = 0.6;

%Correction params
use_correction = false;

%%Tissue parameters for each tissue type
is_voxel_wise = true;
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct); %includes pre-contrast data points (zeros)

%BG CSF NAWM WMH RSL GM Dura Muscle Bone SkullDiploe SkullInner SkullOuter Vessel
NumRegions = 13;
T10_s     = [0   4.22 0.99  1.20 1.27 1.34 0.36 0.23 0.61 0.22 0.88 0.89 1.46];
T2s0_s    = [nan 1    1     1    1    1    1    1    1    1    1    1    1   ];
PS_perMin = [nan 0    2.75  3.91 5.02 3.85 nan  nan  nan  nan  nan  nan  0   ]*1E-4; %permeability
vP=         [nan 0    0.57  0.72 0.72 1.20 nan  nan  nan  nan  nan  nan  100 ]*1E-2; %plasma volume fraction
S0=         [nan 8384 9145  9319 9267 9166 nan  nan  nan  nan  nan  nan  9000]; %equilibrium signal (~proton density)
r1_perSpermM=4.2; %R1 relaxivity;
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

%derive further parameters
NDiscard =(NTrue - NAcq)/2; %number of k-space points to discard on either side when computing the acquired data
HRes_mm = FOV_mm./NTrue;
LRes_mm = FOV_mm./NDes;

%%Input parameters
seg_fname = ['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_Mod_PVWMH2.nii'];

load('dataset.mat')
load('motion_labels.mat')
patient_idx = 172;


