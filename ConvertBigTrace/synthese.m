clear
load('VDI_10MHz+ZFL-PhaseNoise.mat');
VDI_f = data.f;
VDI_sfreq = (data.f_s_phase_sa-1e-10).*(VDI_f.^2);
figure;
loglog(VDI_f,VDI_sfreq);

load('VecselTHz_10MHz+ZFL_2-PhaseNoise.mat');
VeCSEL_f = data.f;
VeCSEL_sfreq = (data.f_s_phase_sa-1e-10).*(VeCSEL_f.^2);
hold on;
loglog(VeCSEL_f,VeCSEL_sfreq,'r');

load('VecselTHz_35MHz+ZFL_instable02-PhaseNoise.mat');
VeCSELi_f = data.f;
VeCSELi_sfreq = (data.f_s_phase_sa-1e-10).*(VeCSELi_f.^2);
hold on;
loglog(VeCSELi_f,VeCSELi_sfreq,'g');