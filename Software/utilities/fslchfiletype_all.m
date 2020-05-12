function fslchfiletype_all(filesStr,fileTypeStr)
% perform dir on argument filesStr and apply "fslchfiletype fileTypeStr" on
% each file

[dirName,name,ext] = fileparts(filesStr);
files=dir(filesStr);
N=size(files,1);

for n=1:N
    system(['fslchfiletype ' fileTypeStr ' ' dirName '/' files(n).name]);
end

end