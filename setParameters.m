%% Parameter file
%  This configuration file allows setting up imaging and tissue
%  characteristics.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

%Imaging parameters
FOV_mm=[240 240 175]; %46 slices acquired in MSS2 (top/bottom 2 are deleted post-acquisition) %NOT SURE HOW YOU GET TO THIS. 46 SLICES X 4MM = 184 MM
NTrue=[480 480 350]; %dimension of image that defines the "true" object
NAcq=[256 60 187]; %number of points acquired; for MSS2: 256x192x46
NDes=[256 60 187]; %dimension of MSS2 image
NFrames=21; %number of time frames, =21 for MSS2
t_res_s=73; %temporal resolution
t_acq_s=t_res_s*NFrames; %total acquisition time
t_start_s=t_res_s; %injection starts at this time (following acquisition of 1 volume)
TR_s=8.24e-3;
TE_s=3.1e-3;
FA_deg=12; %flip angle

%Type of experiment
experiment_idx = 4;
erosion_extent = 0;
regression_type = 'linear'; %either robust or linear

%Noise extent
SDnoise = 33.176421730654326; %Estimated noise SD value for MSSII

%%Tissue parameters for each tissue type
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct); %includes pre-contrast data points (zeros)

%BG CSF NAWM WMH RSL CGM Dura Muscle Bone SkullDiploe SkullInner SkullOuter Vessel DGM Skin+Connective_tissue Adipose_tissue
NumRegions = 16;
T10_s     =   [0   4.22 0.99  1.20 1.27 1.34  nan  nan  nan  nan  nan  nan  1.46  1.34  nan   nan];
T2s0_s    =   [nan 1    1     1    1    1     1    1    1    1    1    1    1     1     1     1  ];
PS_perMin =   [nan 0    2.75  3.91 7.25 3.85  nan  nan  nan  nan  nan  nan  0     3.85  nan   nan]*1E-4; %permeability
vP=           [nan 0    0.57  0.72 1.05 1.20  nan  nan  nan  nan  nan  nan  100   1.20  nan   nan]*1E-2; %plasma volume fraction
M0=           [nan 8520 10000 9400 10700 9298 nan  nan  nan  nan  nan  nan  8817  9298  nan   nan]; %equilibrium signal (~proton density)

r1_perSpermM=4.2; %R1 relaxivity;
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

SI_nonbrain = ...
    [7	375.063	369.188	393.938	387.313	387.125	388.125	391.313	382.438	386.25	391.813	384.313	389.25	386.5	387.5	373.625	371.813	378.25	370.188	380.938	369.313	364.188	;
     8	1385.63	1389.13	1428.44	1378.31	1369.63	1434.19	1402.94	1375.56	1369.69	1315.75	1374.31	1339.25	1366.63	1348.88	1398.75	1365.25	1361.88	1430.19	1412.5	1366.56	1283.5	;
     9	573	580.313	658.688	679.688	690.125	704.688	688.438	708	690.625	612.25	775.188	680.75	782.563	746.063	743.438	838.438	805.188	741	842.5	776.625	724.625	;
     10	634.192	650.769	632.962	616.462	633.808	629.115	620.269	639.5	624.154	607.308	597.5	612.5	640.731	603.538	621.346	611.654	579.731	603.269	619.308	603	586.615	;
     11	199	224.813	246.5	228	239.375	228.375	219.688	244.813	224.313	232.875	214.875	220.438	219.813	215.313	238	225.563	206.813	214.5	212.625	224.813	231.625	;
     12	178.423	212.423	201.115	202.654	216.538	203.538	205.615	228.769	215.654	211.654	216.654	234.346	222.154	205.769	218.231	211.154	179.038	190.308	180.038	178.769	250.5	;
     15	745.571	974.857	1108.07	1154.64	1190.5	1208.29	1222.93	1237.07	1246	1253.07	1241.57	1259.29	1262.79	1249.93	1258.43	1244	1249.64	1262.07	1233.43	1215.64	1218.86	;
     16	1175.5	1126.82	1105.59	1096	1085.18	1075.73	1072.36	1059.59	1069.18	1046.32	1057.32	1049.32	1056.82	1050.41	1042.05	1047.23	1037	1032.23	1033.23	1037.23	1029.41];

%derive further parameters
NDiscard =(NTrue - NAcq)/2; %number of k-space points to discard on either side when computing the acquired data
HRes_mm = FOV_mm./NTrue; %resolution of high resolution object
LRes_mm = FOV_mm./NDes; %scan resolution

%%Input parameters
HR_seg_fname = ['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_Mod_DGM_PVWMH2.nii'];
LR_seg_fname = ['output', filesep, 'LR_tissue_map.nii.gz'];

load('dataset.mat')
load('motion_labels.mat')