function  convertBigTrace( fileName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[pathstr,name,ext]=fileparts(fileName);
newname = fullfile(pathstr, [name '.mat']);
[Y,dt] = importBigTrace(fileName);
clear fileName;
clear name;
clear pathstr;
save(newname);
end

