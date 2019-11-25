clc;
clear all;
close all;

root='/home/s1858467/BRICIA/';
rootProj='/home/s1858467/BRICIA/jbernal_PhD/';

addpath([rootProj 'Software_utils', filesep, 'DCE-functions']);

NFrames=21;
t_res_s=73; %temporal resolution
t_acq_s=t_res_s*NFrames; %total acquisition time
t_start_s=t_res_s; %injection starts at this time

Hct=0.45;
[t_s, Cp_AIF_mM] = DCEFunc_getParkerModAIF(t_res_s,t_acq_s,t_start_s,Hct); %includes pre-contrast data points (zeros)

dt = t_res_s/60;
A = [1 dt dt^2/2; 0 1 dt; 0 0 1];
B = [dt^3/6; dt^2/2; dt] * [dt^3/6; dt^2/2; dt]';
C = [1 0 0];
D = 1;

x = [0; 0; 0];
P = [1 1 1; 1 1 1; 1 1 1] * 0.5;
Mdl = ssm(A,B,C,D, 'Mean0', x, 'Cov0', P, 'StateType', [2, 2, 2]);

yf = filter(Mdl, Cp_AIF_mM);

plot(t_s, [Cp_AIF_mM, yf(:, 1)])