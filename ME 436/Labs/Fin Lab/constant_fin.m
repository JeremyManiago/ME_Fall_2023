clc
clear
close all

set(0,'DefaultFigureWindowStyle','docked')

%% 0 | Data


data = readmatrix('FinData.txt', 'NumHeaderLines', 2);
fin.t = data(:,1)

for i = 1 : size(data, 2) - 1 
    fin(i).ch = data(:,i+1)
end

T_amb = fin(8).ch

%% 1 | Experimental Heat Transfer Coefficient
