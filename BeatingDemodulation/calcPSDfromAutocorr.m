function [ f,PSD ] = calcPSDfromAutocorr( y,dt )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


fs   = 1/dt;
%fmax = fs/2;

%df = fs/N;

N = length(y);
Y=abs(fft(y));

f = fs/2*linspace(0,1,N/2+1);
Y = Y(1:N/2+1);
PSD = Y/(N*fs);

end
