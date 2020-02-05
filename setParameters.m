%% Parameter file
%  This configuration file allows setting up imaging and tissue
%  characteristics.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

%Imaging parameters
FOV_mm=[240 240 175]; %46 slices acquired in MSS2 (top/bottom 2 are deleted post-acquisition) %NOT SURE HOW YOU GET TO THIS. 46 SLICES X 4MM = 184 MM
NTrue=[480 480 350]; %dimension of image that defines the "true" object
NAcq=[256 46 192]; %number of points acquired; for MSS2: 256x192x46 %STRANGE DIMENSION ORDER?
NDes=[256 46 192]; %dimension of MSS2 image %AS ABOVE
NFrames=21; %number of time frames, =21 for MSS2
t_res_s=73; %temporal resolution
t_acq_s=t_res_s*NFrames; %total acquisition time
t_start_s=t_res_s; %injection starts at this time (following acquisition of 1 volume)
TR_s=8.24e-3;
TE_s=3.1e-3;
FA_deg=12; %flip angle

%Type of experiment
erosion_extent = 0;
regression_type = 'linear'; %either robust or linear

%Noise extent
SNR = 45.5; %Estimated SNR value in MSSII

%%Tissue parameters for each tissue type
Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct); %includes pre-contrast data points (zeros)

%BG CSF NAWM WMH RSL GM Dura Muscle Bone SkullDiploe SkullInner SkullOuter Vessel
NumRegions = 13;
T10_s     = [0   4.22 0.99  1.20 1.27 1.34 0.36 0.23 0.61 0.22 0.88 0.89 1.46];
T2s0_s    = [nan 1    1     1    1    1    1    1    1    1    1    1    1   ]; %note these values don't affect the results
% PS_perMin = [nan 0    2.96  3.96 5.77 3.91 nan  nan  nan  nan  nan  nan  0   ]*1E-4; %permeability
% vP=         [nan 0    0.58  0.80 0.80 1.21 nan  nan  nan  nan  nan  nan  100 ]*1E-2; %plasma volume fraction
PS_perMin = [nan 0    2.75  3.91 7.25 3.85 nan  nan  nan  nan  nan  nan  0   ]*1E-4; %permeability-surface area product
vP=         [nan 0    0.57  0.72 1.05 1.20 nan  nan  nan  nan  nan  nan  100 ]*1E-2; %plasma volume fraction
%FOR VESSELS, VP=HCT, NO?
M0=         [nan 8384 9145  9319 9166 9267 nan  nan  nan  nan  nan  nan  9000]; %equilibrium signal (~proton density)
r1_perSpermM=4.2; %R1 relaxivity for Dotarem
r2_perSpermM=0; %ignore T2* effects for now, 6.7s-1mM-1 otherwise

SI_nonbrain = ... %BEST TO EXPLAIN WHAT THIS IS
    [7	375.063	64.7554	369.188	33.0317	393.938	43.5024	387.313	37.7213	387.125	36.2746	388.125	38.4913	391.313	30.0682	382.438	32.1019	386.25	32.7974	391.813	32.4966	384.313	27.9326	389.25	33.2556	386.5	26.6883	387.5	25.6541	373.625	30.3268	371.813	31.5726	378.25	28.1981	370.188	29.7953	380.938	28.3466	369.313	28.9936	364.188	27.8046;
    8	1385.63	56.7249	1389.13	35.3683	1428.44	36.6969	1378.31	50.7828	1369.63	36.4177	1434.19	80.0702	1402.94	48.8118	1375.56	63.1527	1369.69	55.7682	1315.75	53.0666	1374.31	79.6055	1339.25	65.8458	1366.63	51.8226	1348.88	44.2747	1398.75	26.1445	1365.25	25.4362	1361.88	59.9821	1430.19	34.6145	1412.5	50.4592	1366.56	20.7813	1283.5	78.8771;
    9	573	20.324	580.313	27.8058	658.688	32.2319	679.688	28.3307	690.125	36.8273	704.688	52.249	688.438	26.9517	708	20.5394	690.625	26.0484	612.25	47.3392	775.188	35.5738	680.75	16.2829	782.563	13.0024	746.063	16.3522	743.438	23.8271	838.438	19.4627	805.188	41.3589	741	29.806	842.5	53.1576	776.625	17.1148	724.625	22.9895;
    10	634.192	81.7186	650.769	94.8997	632.962	88.1328	616.462	89.5554	633.808	89.575	629.115	85.4177	620.269	77.2226	639.5	77.0155	624.154	80.5996	607.308	75.0327	597.5	64.9882	612.5	77.9016	640.731	72.8173	603.538	72.2801	621.346	74.7261	611.654	79.0655	579.731	72.519	603.269	74.6718	619.308	86.5609	603	67.3991	586.615	54.475;
    11	199	78.1127	224.813	85.7059	246.5	92.5613	228	122.135	239.375	120.499	228.375	106.33	219.688	104.307	244.813	100.724	224.313	109.357	232.875	103.011	214.875	105.453	220.438	102.825	219.813	88.5891	215.313	94.3403	238	90.2153	225.563	100.887	206.813	114.402	214.5	87.8802	212.625	102.058	224.813	92.1334	231.625	82.5396;
    12	178.423	92.4689	212.423	102.779	201.115	77.3787	202.654	81.9878	216.538	85.4664	203.538	102.021	205.615	92.4234	228.769	91.5905	215.654	98.5787	211.654	103.83	216.654	100.531	234.346	115.177	222.154	106.78	205.769	102.89	218.231	82.7054	211.154	103.634	179.038	116.69	190.308	114.326	180.038	129.69	178.769	107.782	250.5	103.865];

%derive further parameters
NDiscard =(NTrue - NAcq)/2; %number of k-space points to discard on either side when computing the acquired data
HRes_mm = FOV_mm./NTrue; %resolution of high resolution object
LRes_mm = FOV_mm./NDes; %scan resolution

%%Input parameters
seg_fname = ['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_Mod_PVWMH2.nii'];
seg_dgm_fname = ['input', filesep, 'MIDA_v1.0', filesep, 'MIDA_v1_voxels', filesep, 'MIDA_Mod_DGM_PVWMH2.nii'];

load('dataset.mat')
load('motion_labels.mat')
