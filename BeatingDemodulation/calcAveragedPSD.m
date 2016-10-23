function [ f,PSD ] = calcAveragedPSD( y,dt,nAvg,window )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
splSize = floor(length(y)/nAvg);


for k=1:nAvg
    [f,PSDlocal] = calcPSD(y((k-1)*splSize+1:k*splSize),dt,window);
    PSDlocal = PSDlocal;
    if(k==1)
        PSD = PSDlocal;
    else
        PSD = (PSDlocal+PSD*(k-1))/k;
    end
end

