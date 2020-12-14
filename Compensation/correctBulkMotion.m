%% Use FSL to correct for bulk motion
%  This function calls MCFLIRT to correct for gross motion
%
%  Inputs:
%  - mcflirt_command: mcflirt command
%  - output_folder: output folder
%  - fname: base filename
%
% (c) Jose Bernal and Michael J. Thrippleton 2019

function correctBulkMotion(mcflirt_command, output_folder, fname)
    input_fname = [output_folder, filesep, fname];
    system(sprintf(mcflirt_command, input_fname));
end