function k_space = add_motion_artifacts(k_space, missing_lines)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     motion_artifacts.m
%
%   CONTENTS:   Simulates a motion artifact
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Politecnica de Valencia, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   k_space                    : original k-space
%   missing_lines   : magnitude of the motion artifact
%                                   (selected with the slider)
%
%   OUTPUT PARAMETERS:
%
%   k_space                   : k-space with the simulated motion
%                                    artifact
%
%-------------------------------------------------
% David Moratal, Ph.D.
% Center for Biomaterials and Tissue Engineering
% Universitat Politecnica de Valencia
% Valencia, Spain
%
% web page:   http://dmoratal.webs.upv.es
% e-mail:     dmoratal@eln.upv.es
%-------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    zeroed_lines = randi(size(k_space, 1), missing_lines, 1);

    k_space(zeroed_lines, :, :) = 0;
end