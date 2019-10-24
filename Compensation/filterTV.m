function LR_SI_filt = filterTV(LR_SI, NAcq, NFrames, NIter, TVWeight)
    LR_SI_filt = zeros([NAcq, NFrames]);
    for iFrame=1:NFrames
       LR_SI_filt(:, :, :, iFrame) = filterTVSingleFrame(...
           LR_SI(:, :, :, iFrame), NIter, TVWeight);
    end
end

function LR_SI_filt = filterTVSingleFrame(LR_SI, NIter, TVWeight)
    % initialize parameters for reconstruction
    param = init;
    param.FT = 1;
    param.XFM = 1;
    param.TV = TVOP3;
    param.data = LR_SI;
    param.TVWeight = TVWeight;     % TV penalty 
    param.xfmWeight = 0;  % L1 wavelet penalty
    param.Itnlim = NIter;
    
    LR_SI_filt = fnlCg3(res, param);
end