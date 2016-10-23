function [ Y,dt ] = importBigTrace( fileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

theFile = fopen(fileName);
for k=1:5
str = fgets(theFile);
end
fclose(theFile);
split = strsplit(str,' ');
dt = str2double(split{2});

% import data themselves
a = importTrace(fileName,8,120000000);
b=importTrace(fileName,120000001,inf);

Y=[a;b];
clear a;
clear b;
end

