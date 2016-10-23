function [ f,PSD ] = calcPSD( y,dt,window )
%calcPSD genere un vecteur de densite spectrale calibre calcule a partir
%d'un signal temporel donne en parametre
%   Entrees : le vecteur d'amplitudes temporelles et la periode
%        d'echantillonnage
%   Sorties : le vecteur des frequences et la densite spectrale calibree
if(nargin==2)
    fs   = 1/dt;
    N = length(y);
    Y=abs(fft(y));
    f = fs/2*linspace(0,1,N/2+1);
    Y = Y(1:N/2+1);
    PSD = 2*Y.*conj(Y)/(N*fs);
else 
    fs   = 1/dt;
    N = length(y);
    [w,cal] = calcFFTWindow(N,window);

    Y=abs(fft(y.*w));
    f = fs/2*linspace(0,1,N/2+1);
    Y = Y(1:N/2+1);
    PSD = 2*Y.*conj(Y)/(cal*fs);

end

