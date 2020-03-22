%% Configuration file
%  This configuration file allows adding all relevant folders to the
%  project.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

maxNumCompThreads(15);

root='/DSTORE/BRICIA/';
rootProj='/DSTORE/BRICIA/jbernal_PhD/';

addpath('Artefacts');
addpath('Compensation');
addpath('Evaluation');
addpath('HRModule');
addpath('LRModule');
addpath('Utils');

addpath([rootProj 'Tools', filesep, 'spm12']);
addpath([rootProj 'Software_utils', filesep, 'BRIClib']);
addpath([rootProj 'Software_utils', filesep, 'NIFTI']);
addpath([rootProj 'Software_utils', filesep, 'utilities']);
addpath([rootProj 'Software_utils', filesep, 'DCE-functions']);

procpaa_folder = [root, 'ProcPAA', filesep];

output_folder = 'output';

trans_matrix_pattern = [procpaa_folder, '%s', filesep, '%s', filesep, 'Results_1r1pv', filesep, 'Matrices', filesep, 'permeability', filesep, 'mat_sig_%d_ref.mat'];

mcflirt_command = 'mcflirt -in %s -cost normmi -refvol 1';