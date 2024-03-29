%% Parameter file
%  This configuration file allows setting up imaging and tissue
%  characteristics.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

%Imaging parameters - dimensions are LR (Phase encoding), AP (Freq Encoding), SI (Slice encoding)
FOV_mm_True=[240 240 240]; %Default FOV
NTrue=[480 480 480]; %Dimension of image that defines the "true" object

FOV_mm_Acq=[240, 240, 184]; %Acquired FoV
MSSII_res_mm = [1.25, 0.9375, 4];%MSSII resolution
NAcq = floor(FOV_mm_Acq./MSSII_res_mm);%number of points acquired
NIgnore = 3; % number of frames to ignore during fitting

NFrames=21; %number of time frames, =21 for MSS2
t_res_s=73; %temporal resolution
t_acq_s=t_res_s*NFrames; %total acquisition time
t_start_s=t_res_s; %injection starts at this time
TR_s=8.24e-3;
TE_s=3.1e-3;
FA_deg=12; %flip angle

%Type of experiment
apply_gross_motion = 1; %flag indicating whether to apply gross motion
apply_motion_artefacts = 1; %flag indicating whether to induce motion artefacts.
% Of note, motion artefacts will only appear if apply_gross_motion = 1.

apply_lowpass = 0; %flag indicating whether to apply a low pass filter or not
apply_noise = 1; %flag indicating whether to add noise or not
apply_erosion = 0; %flag indicating whether to erode seg masks or not
erosion_extent = 1; %radius in voxels of the erosion element (requires apply_erosion=1)
regression_type = 'linear'; %either robust or linear
apply_histogram_analysis = 0; %flag indicating whether to apply histogram analysis for denoising estimates
NumBins = 1000; % number of bins for histogram analysis parameter denoising
apply_kalman_filtering = 0; % flat indicating whether or not to use the Kalman filter
use_acceleration_model = 1; % either 1 (assume constant acceleration) or 0 (assume constant velocity)
apply_sg_filtering = 0; % flat indicating whether or not to use the SG filter
sg_order = 2; % SG filter order
sg_framelength = 17; % SG filter framelength

% Noise extent
% We represent the signal-to-noise ratio (SNR) as the quotient
% between the mean signal value and the standard deviation of the
% background noise. The SNR of the real scans should be similar to that of
% our simulations, i.e. SNR_real = SNR_sim or mu_real/SD_real =
% mu_sim/SD_sim. Thus, the standard deviation of the noise in
% our simulations should be equal to (mu_sim*SD_real)/mu_real.
SDnoise = 7.0849; %Estimated noise SD 7.0849 value for MSSII

%%Tissue parameters for each tissue type
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct,'MSS2'); %includes pre-contrast data points (zeros)

% Tissue parameters per class
%  1  - Background
%  2  - Cerebrospinal fluid
%  3  - Normal-appearing white matter
%  4  - White matter hyperintensity
%  5  - Recent stroke lesion
%  6  - Cortical grey matter
%  7  - Meninges
%  8  - Muscles and eyes
%  9  - Mandible and vertebrae
%  10 - Skull diploe
%  11 - Skull outer table
%  12 - Skull inner table
%  13 - Blood vessels
%  14 - Deep grey matter
%  15 - Skin
%  16 - Adipose tissue
%  17 - Eyes
NumRegions = 17;
T10_s     =   [0   4.22 0.99  1.20 1.27 1.34  nan  nan  nan  nan  nan  nan  1.46        1.34  nan   nan nan];
T2s0_s    =   [nan 1    1     1    1    1     1    1    1    1    1    1    1           1     1     1   1  ];
PS_perMin =   [nan 0    2.75  3.91 7.25 3.85  nan  nan  nan  nan  nan  nan  0           3.85  nan   nan nan]*1E-4; %permeability
vP=           [nan 0    0.57  0.72 1.05 1.20  nan  nan  nan  nan  nan  nan  (1-Hct)*100 1.20  nan   nan nan]*1E-2; %plasma volume fraction
M0=           [nan 8520 9726 9402 9858 9298 nan  nan  nan  nan  nan  nan  8817        9298  nan   nan nan]; %equilibrium signal (~proton density)

r1_perSpermM=4.2; %R1 relaxivity;
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

% Create extra-cerebral signal-time curves
SI_nonbrain = getNonBrainSignals(t_s);

% Derive further parameters
HRes_mm = FOV_mm_True./NTrue;
LRes_mm = FOV_mm_Acq./NAcq;

% Input parameters
HR_seg_fname = ['input', filesep, 'HR_tissue_map.nii'];
LR_seg_fname = ['input', filesep, 'LR_tissue_map.nii'];