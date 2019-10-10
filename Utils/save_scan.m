function finished_successfully = save_scan(scans, filenames, N, output_folder, Res_mm)
    try
        info.fname=[output_folder '/output'];
        info.dim=N;
        info.dt=[16 0];
        info.mat=[Res_mm(1) 0 0 0; 0 Res_mm(2) 0 0;0 0 Res_mm(3) 0; 0 0 0 1];
        dataToWrite = scans;
        NFiles=size(dataToWrite, 2);
        for iFile=1:NFiles
            SPMWrite4D(info, dataToWrite{iFile}, output_folder, filenames{iFile}, 16);
        end

        finished_successfully = true;
    catch 
        warning('Problem saving image');
        finished_successfully = false;
    end
end