%% Configuration file
%  This configuration file allows adding all relevant folders to the
%  project.
%  
% (c) Jose Bernal and Michael J. Thrippleton 2019

maxNumCompThreads(15);

addpath('Artefacts');
addpath('Compensation');
addpath('Evaluation');
addpath('HRModule');
addpath('LRModule');
addpath('Utils');

addpath(['Software', filesep, 'spm12']); % Download from https://www.fil.ion.ucl.ac.uk/spm/software/download/
addpath(['Software', filesep, 'utilities']); % Provided
addpath(['Software', filesep, 'DCE-functions']); % Download from https://github.com/mjt320/DCE-functions

output_folder = 'output';

trans_matrix_pattern = ['input', filesep, 'TransformationMatrices', filesep, '%s.mat'];

mcflirt_command = 'mcflirt -in %s -cost normmi -refvol 0';