%% Parameter file
%  This configuration file allows setting up imaging and tissue
%  characteristics.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

%Imaging parameters - dimensions are AP (Freq Encoding), SI (Slice encoding), LR (Phase encoding)
FOV_mm_True=[240 240 240]; %Default FOV
NTrue=[480 480 480]; %Dimension of image that defines the "true" object

FOV_mm_Acq=[240, 184, 240]; %Acquired FoV
MSSII_res_mm = [0.9375, 4, 1.25];%MSSII resolution
NAcq = floor(FOV_mm_Acq./MSSII_res_mm);%number of points acquired

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

apply_awgn = 1; %flag indicating whether to add white Gaussian noise or not
apply_erosion = 0; %flag indicating whether to erode seg masks or not
erosion_extent = 1; %radius in voxels of the erosion element (requires apply_erosion=1)
regression_type = 'linear'; %either robust or linear

% Noise extent
% We represent the signal-to-noise ratio (SNR) as the quotient
% between the mean signal value and the standard deviation of the
% background noise. The SNR of the real scans should be similar to that of
% our simulations, i.e. SNR_real = SNR_sim or mu_real/SD_real =
% mu_sim/SD_sim. Thus, the standard deviation of the noise in
% our simulations should be equal to (mu_sim*SD_real)/mu_real. First, we 
% estimated the standard deviation of the noise in real scans by computing 
% the mean signal within the normal-appearing white matter region and the
% standard deviation of the noise from background area. Second, we multiplied
% the estimated standard deviation by sqrt(2-pi/2). Third, we computed the
% standard deviation value for our simulations.
SDnoise = 7.0849; %Estimated noise SD 7.0849 value for MSSII

%%Tissue parameters for each tissue type
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct,'MSS2'); %includes pre-contrast data points (zeros)

%BG CSF NAWM WMH RSL CGM Dura Muscle Bone SkullDiploe SkullInner SkullOuter
%Vessel DGM Skin+Connective_tissue Adipose_tissue Eyes
NumRegions = 17;
T10_s     =   [0   4.22 0.99  1.20 1.27 1.34  nan  nan  nan  nan  nan  nan  1.46        1.34  nan   nan nan];
T2s0_s    =   [nan 1    1     1    1    1     1    1    1    1    1    1    1           1     1     1   1  ];
PS_perMin =   [nan 0    2.75  3.91 7.25 3.85  nan  nan  nan  nan  nan  nan  0           3.85  nan   nan nan]*1E-4; %permeability
vP=           [nan 0    0.57  0.72 1.05 1.20  nan  nan  nan  nan  nan  nan  (1-Hct)*100 1.20  nan   nan nan]*1E-2; %plasma volume fraction
M0=           [nan 8520 10000 9400 10700 9298 nan  nan  nan  nan  nan  nan  8817        9298  nan   nan nan]; %equilibrium signal (~proton density)

r1_perSpermM=4.2; %R1 relaxivity;
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

% 2D matrix with signal profile for each non-brain structure. Each row 
% corresponds to the tissue class number, followed by the mean intensity in
% each frame.
% The tissue class number and its description are the following:
% 7  - Meninges
% 8  - Muscles and eyes
% 9  - Mandible and vertebrae
% 10 - Skull diploe
% 11 - Skull outer table
% 12 - Skull inner table
% 15 - Skin
% 16 - Adipose tissue
% 17 - Eyes
SI_nonbrain = ...
   [7 431.415 784.151 763.019 722.415 711 705.226 677.094 666.585 663.604 658.019 632.434 623.642 630.811 635.226 632.132 623.113 616.792 628.943 628.623 610.038 620.943
    8 413.278 501.784 550.323 543.775 537.826 545.594 546.445 540.14 539.147 537.195 537.142 540.388 545.158 550.952 533.211 528.773 533.289 525.761 529.172 529.782 525.844
    9 517.882 592.078 635.272 636.486 649.992 656.68 652.459 653.712 668.105 622.444 670.004 655.131 666.491 672.232 695.943 686.771 662.246 676.842 663.12 677.244 695.307
    10 367.306 360.653 347.542 343.889 347.139 341.5 347.764 338.194 343.667 344.653 337.681 343.333 332.528 324.181 333.847 333.958 324.986 334.319 324.278 326.125 339.806
    11 114.988 136.073 140.061 147.366 144.89 154.146 152.512 157.573 152.915 160.817 158.805 163.634 164.72 156.646 170.756 167.683 163.817 174.5 168.305 156.598 177.159
    12 170.905 213.919 211.378 212.946 213.054 218.959 214.541 218.446 222.284 223.851 225.824 223.838 227.297 220.595 237 221.919 221.122 217 221.324 221.135 234.905
    15 833.631 1048.38 1197.93 1249.45 1279.36 1299.43 1330.32 1335.45 1346.75 1347.94 1356.98 1354.86 1342.33 1340.33 1331.76 1327.06 1325.38 1324.11 1313.58 1303.29 1318.35
    16 1064.07 1030.97 1028.85 1029.18 1027.25 1030.37 1029.13 1027.79 1029.26 1028.55 1024.43 1018.8 1018.14 1009.05 1017.1 1016.91 1018.43 1009.68 1009.15 1009.85 1006.34
    17 309.60 377.76 321.89 333.62 318.76 329.80 349.59 354.63 343.17 332.92 326.33 385.35 350.94 338.10 341.60 295.70 309.19 333.52 325.42 308.74 356.733];

%derive further parameters
HRes_mm = FOV_mm_True./NTrue;
LRes_mm = FOV_mm_Acq./NAcq;

%%Input parameters
HR_seg_fname = ['input', filesep, 'HR_tissue_map.nii.gz'];
LR_seg_fname = ['input', filesep, 'LR_tissue_map.nii.gz'];