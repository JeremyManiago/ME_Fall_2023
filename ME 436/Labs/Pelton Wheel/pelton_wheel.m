clc
clear
close all

set(0,'DefaultFigureWindowStyle','docked')

%% Data
set1.p = 0.5;                                           %bar
set1.q = 0.5173;                                        % L/s
set1.m = [0, 100, 300, 500, 700, 800, 900];             % g
set1.springm = [0.1, 0.14, 0.2, 0.3, 0.38, 0.42, 0.46]; % kg
set1.rpm = [1250, 1194, 1086, 949.5, 786, 763.4, 698];  % rpm