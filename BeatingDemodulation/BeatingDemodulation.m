function  BeatingDemodulation( fileName )
    % The Code for laser carrier demodulation thanks to Hilbert Transform
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
    
load(fileName);
importLib('Fourier')

s_in = Y(1:200e6); % input signal
clear Y;
 
Fs = 1/dt; % sampling frequency
t=[1:length(s_in)]'*dt;

%s_out = s_in;




%% Hilbert : génération du signal analytique
% evaluation grossiere de la fréquence moyenne
[f,laserSpectrum] = calcPSD(s_in(1:1000000)',dt,'Hanning');  
subplot(2,2,1);
title('spectre laser + filtrage')
semilogy(f,laserSpectrum,'b'); hold on;
[amp f0]=max(laserSpectrum); % carrier frequency (beat frequency) 
f0 = f(f0);
s_a = hilbert(s_in,length(t)); % hilbert 
phase_sa = 1*unwrap((angle(s_a.*exp(-1j*2*pi*f0*t)))); %phase instantanée
%clear s_in; 

% evaluation de la dérive pour ajuster f0
p = polyfit(t, phase_sa, 1);
%p(1) est alors la dérive exprimée en pulsation
subplot(2,2,2);
%plot(t,phase_sa,'b');  % should be too long to plot
hold on;
title('phase(t) (av/ap ajust. f0)')
% evaluation précise de la fréquence moyenne et recalcul du signal
% analytique
f0 = f0+p(1)/2/pi;
s_a = hilbert(s_in,length(t)); % hilbert 
phase_sa = 1*unwrap((angle(s_a.*exp(-1j*2*pi*f0*t))));  %phase instantanée
phase_sa = phase_sa  - mean(phase_sa );
A_a = abs(s_a); % amplitude instantanée du signal analytique
subplot(2,2,2);
%plot(t,phase_sa,'r');  % should be too long to plot
data.t = t;
data.t_phase = phase_sa;

%% Extra Filtering if necessary (usually not)
% % 
% Fstop1 = f0-1.5e7;        % First Stopband Frequency
% Fpass1 = f0-1e7;        % First Passband Frequency
% Fpass2 = f0+1e7;        % Second Passband Frequency
% Fstop2 = f0+1.5e7;        % Second Stopband Frequency
% Dstop1 = 0.001;           % First Stopband Attenuation
% Dpass  = 0.05;  % Passband Ripple
% Dstop2 = 0.0001;          % Second Stopband Attenuation
% dens   = 20;              % Density Factor
% 
% % Calculate the order from the parameters using FIRPMORD.
% [N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
%                           0], [Dstop1 Dpass Dstop2]);
% 
% % Calculate the coefficients using the FIRPM function.
% b  = firpm(N, Fo, Ao, W, {dens});
% Hd = dfilt.dffir(b);
% 
% s_in = filter(Hd,s_in);
% [f,laserSpectrum] = calcPSD(s_in(1:1000000)',dt,'Hanning');  
% subplot(2,2,1);
% semilogy(f,laserSpectrum,'r');
% 
% %% Calcul Definitif du signal analytique
% s_a = hilbert(s_in,length(t)); % hilbert 
% phase_sa = 1*unwrap((angle(s_a.*exp(-1j*2*pi*f0*t))));  %phase instantanée
% phase_sa = phase_sa  - mean(phase_sa );
% A_a = abs(s_a); % amplitude instantanée du signal analytique
% 
% 
% drawnow;

%% Densité spectrale de bruit de phase/frequence
% method 1
[f,s_phase_sa] = calcAveragedPSD(phase_sa',dt,100,'Hanning'); %pwelch(phase_sa,w);% 
[f_HF,s_phase_sa_HF] = calcAveragedPSD(phase_sa',dt,10000,'Hanning'); 

s_freq = f.^2.*s_phase_sa; % conversion vers frequence
s_freq_HF = f_HF.^2.*s_phase_sa_HF;

subplot(2,2,3)
loglog(f,s_phase_sa,'b')
hold on; loglog(f_HF,s_phase_sa_HF,'r')

title('Bruit de phase')
subplot(2,2,4)
loglog(f,s_freq,'b')
hold on; loglog(f_HF,s_freq_HF,'r')
title('Bruit de frequence')

data.f = f;
data.f_s_phase_sa = s_phase_sa;
data.s_freq = s_freq;

%sauvegarde des resultats
[pathstr,name,ext] = fileparts(fileName);
newFile = fullfile(pathstr,strcat(name,'-PhaseNoise',ext));
data.t = 0;
data.t_phase = 0;
save(newFile,'data');

end

