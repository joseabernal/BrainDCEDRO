root='/home/s1858467/BRICIA/';
rootProj='/home/s1858467/BRICIA/jbernal_PhD/';
% root='U:\Datastore\CMVM\scs\groups\BRICIA\';
% rootProj='U:\Datastore\CMVM\scs\groups\BRICIA\jbernal_PhD\';

addpath([rootProj 'Tools', filesep, 'spm12']);
addpath([rootProj 'Software_utils', filesep, 'BRIClib']);
addpath([rootProj 'Software_utils', filesep, 'NIFTI']);
addpath([rootProj 'Software_utils', filesep, 'utilities']);
addpath([rootProj 'Software_utils', filesep, 'DCE-functions']);

mss_seg_folder = [root, 'MSS_II_segmentation', filesep, 'Permeability_1tp', filesep];
procpaa_folder = [root, 'ProcPAA', filesep];
input_folder = [rootProj, 'Data', filesep, 'DRO_real_patients', filesep];
output_folder = 'output';

ref_seg_fname_pattern = [input_folder, '%s', filesep, 'pby_sig_seg'];
ref_enh_fname_pattern = [input_folder, '%s', filesep, 'enh'];
ref_i0_fname_pattern = [input_folder, '%s', filesep, 's0'];

trans_matrix_pattern = [procpaa_folder, '%s', filesep, '%s', filesep, 'Results_1r1pv', filesep, 'Matrices', filesep, 'permeability', filesep, 'mat_sig_%d_ref.mat'];

mcflirt_command = 'mcflirt -in %s -cost normmi -refvol 1';