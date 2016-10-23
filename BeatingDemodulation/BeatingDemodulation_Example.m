    % Example for the use of BeatingDemodulation
    % Will generate new files containing the demodulated data
    %
    %   by M. Sellahi and M. Myara
    %   for Optics Express 2016 Article "Time-Dependant Laser Linewidth :
    %   beat-note digital acquisition and numerical analysis",
    %   N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.
    %   Signoret.
    %
    % This Code is under BSD Licence. 
    % Please cite our Optics Express publication if you use
    % this software or part of this software in the frame of 
    % scientific works or publications
    %
    % Please mention the two authors of this software if you reuse this 
    % code or part of this code in another software
    %
    % Input Data Files may contain two variables :
    % - dt : the time step between two samples in seconds
    % -  Y : a column vector containing the sample data
    %
    % This Code is independent from LinewidthExplorerGUI and can be used
    % without any GUI context. However, to reduce computation times, 
    % parameters may be chosen with the help of the GUI.


thePath = 'C:\Users\Manip\Desktop\Mike\LimitHetero\';
fileNames = {'nomod.mat','10mV_20dB.mat','1V_40dB.mat'}

for  i = 1:length(fileNames)

str = strcat(thePath,fileNames{i});

BeatingDemodulation(str);
end

