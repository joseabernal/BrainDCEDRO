function [espai_k_out]=add_awgnoise(espai_k_in,SignalToNoiseRatio)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     add_awgnoise.m
%
%   CONTENTS:   add an additive white gaussian noise to the complex data
%
%   COPYRIGHT:  David Moratal-Perez, 2004
%                Universitat Politecnica de Valencia, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   SignalToNoiseRatio             : value of the noise (in dB) to add
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : k-space with the added noise
%   SNR_SignalNoiseIndependent    : resulting signal-to-noise ratio
%
%-------------------------------------------------
% David Moratal, Ph.D.
% Center for Biomaterials and Tissue Engineering
% Universitat Polit�cnica de Val�ncia
% Valencia, Spain
%
% web page:   http://dmoratal.webs.upv.es
% e-mail:     dmoratal@eln.upv.es
%-------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Signal
NumberComponents=numel(espai_k_in);
AverageSignal=(1/NumberComponents)*sum(sum(sum(abs(espai_k_in))));

% Unbiased estimate of the Standard Deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%              /-----------------------------------------------\
%             /                      /----|
%            /        1              \                      2
%   s  = -  /  --------------------  /       ( a(m,n) - m  )
%    a    \/    NumberComponents-1   \----|              a
%                                      m,n
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UnbiasedEstStDeviationSignal=sqrt( (1/(NumberComponents-1)) * sum(sum(sum(abs(espai_k_in-AverageSignal)).^2 ))  );

% Using the SNR given by the user, we build the standard deviation of the noise
StdDeviationNoise=UnbiasedEstStDeviationSignal/(10^(SignalToNoiseRatio/20));

% Additive White Gaussian Noise
Noise=StdDeviationNoise*randn(size(espai_k_in(:,:,:)));

% I add the noise to the frame (in k-space domain)
espai_k_out(:,:,:)=espai_k_in(:,:,:)+Noise;
end