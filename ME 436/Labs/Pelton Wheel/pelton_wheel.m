clc
clear
close all

set(0,'DefaultFigureWindowStyle','docked')

%% Data
set(1).p = 0.5;                                                 % bar
set(1).q = 0.5173;                                              % L/s
set(1).m = [0, 100, 300, 500, 700, 800, 900];                   % g
set(1).springm = [0.1, 0.14, 0.2, 0.3, 0.38, 0.42, 0.46];       % kg
set(1).wheel = [1250, 1194, 1086, 949.5, 786, 763.4, 698];      % rpm

set(2).p = 0.7;                                                 % bar
set(2).q = 0.5284;                                              % L/s
set(2).m = [0, 100, 300, 500, 700, 800, 900];                   % g
set(2).springm = [0.1, 0.14, 0.2, 0.3, 0.38, 0.42, 0.46];       % kg
set(2).wheel = [1430, 1361,1210, 1015, 830.7, 762.2, 702.8];    % rpm

set(3).p = 0.9;                                                 % bar
set(3).q = 0.4381;                                              % L/s
set(3).m = [0, 100, 300, 500, 700, 800, 900];                   % g
set(3).springm = [0.1, 0.12, 0.2, 0.28, 0.36, 0.41, 0.46];      % kg
set(3).wheel = [1553, 1454, 1284, 1094, 897, 807.7, 714.7];     % rpm

set(4).p = 1.1;                                                 % bar
set(4).q = 0.3721;                                              % L/s
set(4).m = [0, 100, 300, 500, 700, 800, 900];                   % g
set(4).springm = [0.1, 0.12, 0.2, 0.28, 0.38, 0.46, 0.5];       % kg
set(4).wheel = [1604, 1494, 1271, 1015, 773.6, 620.7, 527.3];   % rpm

set(5).p = 1.3;                                                 % bar
set(5).q = 0.303;                                               % L/s
set(5).m = [0, 100, 300, 500, 700, 800, 900];                   % g
set(5).springm = [0.1, 0.12, 0.2, 0.3, 0.4, 0.46, 0.52];        % kg
set(5).wheel = [1608, 1478, 1195, 859.7, 584, 452.1, 343.7];    % rpm


breakwheel_r = (60e-3)/2; % m

%% 1
convq = 1/1000;          % m^3/s
convp = 1e5;             % Pa
convm = 1e-3;            % kg
convwheel = (2*pi())/60; % rad/s

figure;

for i = 1 : length(set)
    set(i).p = set(i).p .* convp;
    set(i).m = set(i).m .* convm;
    set(i).q = set(i).q .* convq;
    set(i).wheel = set(i).wheel .* convwheel;
    set(i).T = zeros(1, length(set(i).m));

    % for j = 1 : length(set(i).m)
    %     set(i).T(j) = ( set(i).m(j) - set(i).springm(j) ) * breakwheel_r;
    % end

    set(i).T = ( set(i).m - set(i).springm ) * breakwheel_r;

    plot(set(i).wheel, set(i).T)
    hold on 

end

title('Torque vs Wheel Speed')
xlabel('\Wheel speed (rad/s)')
ylabel('Torque (Nm)')
legend('Set 1', 'Set 2', 'Set 3', 'Set 4', 'Set 5')
hold off

%% 2
for i = 1 : length(set)
    set(i).p_i = set(i).p * set(i).q;
    disp("Set " + i + " Power input = " + set(i).p_i + " Watts")
end

disp(" ")

%% 3
figure;

for i = 1 : length(set)
    set(i).p_o = set(i).T .* set(i).wheel;
    plot(set(i).wheel, set(i).p_o)
    hold on
end

title('Power Output vs Wheel Speed')
xlabel('Wheel speed (rad/s)')
ylabel('Power Output (W)')
legend('Set 1', 'Set 2', 'Set 3', 'Set 4', 'Set 5')
hold off

disp(" ")


%% 4

figure;

for i = 1 : length(set)
    set(i).eff = set(i).p_o ./ set(i).p_i;
    plot(set(i).wheel, set(i).eff)
    hold on
end

title('Efficiency vs Wheel Speed')
xlabel('Wheel speed (rad/s)')
ylabel('Efficiency, \eta (%)')
legend('Set 1', 'Set 2', 'Set 3', 'Set 4', 'Set 5')
hold off

disp(" ")

%% 5
tach_u = [1248, 1254, 1263, 1247, 1240, 1241, 1245, 1245, 1244, 1240]; % rpm
tach_u = tach_u * convwheel;
x_bar = mean(tach_u);
N = length(tach_u);
x_sum = zeros(1, length(tach_u));

for i = 1 : N
    x_sum(i) = (tach_u(i) - x_bar)^2
end

x_sum = sum(x_sum)

s_x = sqrt( (1/(N-1))*(x_sum) )

s_x_bar = s_x/sqrt(N)

DoF = N - 1

t_95 = 2.262

e_ep = sqrt((t_95*s_x_bar)^2)

figure;

for i = 1 : length(set)
    set(i).u_x = sqrt((t_95*s_x_bar)^2) .* set(i).eff;
    plot(set(i).wheel, set(i).eff)
    hold on
    errorbar(set(i).wheel, set(i).eff, e_ep)
end