clc
clear
close all

set(0,'DefaultFigureWindowStyle','docked')

tc = [65, 110, 180, 280, 394, 504, 605]; % mm
tc = tc ./ 1000; % m
L = tc(end); % m
d = 12/1000; % m

V = 40; % Volts
R = 178; % Ohms
A = pi()*((d/2)^2); % m^2
q_flux = (V^2)/(R*A);

q = q_flux * A; % W/m^2

%% 0 | Data
clear data fin
data = readmatrix('FinData.txt', 'NumHeaderLines', 2);
fin.t = data(:,1);
for i = 1 : size(data, 2) - 1 
    fin(i).ch = data(:,i+1);
end

%% 1 | Experimental Heat Transfer Coefficient
T_amb = fin(8).ch(end);

for i = 1 : size(fin,2) - 1
    T_ss(i) = fin(i).ch(end);
end
C = d*pi();
integral = trapz(tc, T_ss -  T_amb)

hbar_exp = q / (integral*C)

%% 2 | Theoretical Temperature
k = 401; % W/m*K
m = sqrt((hbar_exp*C)/(k*A));
rho = 8960; % Copper, kg/m^3
Cp = 386; % Copper, J/kg*K
alph = k/(rho*Cp);

th.t = fin(1).t; % seconds
th.x(:, 1) = 0: 0.0005: L;
th.T = zeros(size(th.x, 1), size(th.t, 1))

for i = 1 : size(th.x, 1)
    for j = 1 : size(th.t, 1)
        summ = zeros(100, 1);
        for n = 1:100
            summ(n) = (cos(n*pi()*th.x(i)/L)*exp((-n^2)*(pi()^2)*alph*th.t(j)/(L^2)))/((m^2)*(L^2)+(n^2)*(pi()^2));
        end
        summ = sum(summ);

        one = (exp(m*(th.x(i) - 2*L)) + exp(-m*th.x(i)))/(m*(1 - exp(-2*m*L)));
        two = -2*exp(alph*th.t(j)*(-m^2));
        three = 1/(2*(m^2)*L) + L*summ;
        
        th.T(i,j) = T_amb + (q_flux/k)*(one + (two*three));
    end
end
th.T = th.T .'

%% 3 | Plot steady state temperatures
clf
fig1 = figure('Name','Steady State');

plot(tc, T_ss, LineWidth = 1.5, Color="r")
hold on
th.ss = th.T(end, :);
plot(th.x, th.ss, LineWidth = 1.5, Color="b")
grid on
title('Steady State Temperatures over Length of Fin')
xlabel('Length of Fin (m)')
ylabel('Temperature (^o C)')
legend('Experimental T_{ss}', 'Theoretical T_{ss}')
ax1 = gca;

%% 4 | Plot transient state temperatures
fig2 = figure('Name','Transient State');

exp_plot = plot(fin(1).t, [fin.ch], LineWidth = 0.1, Color="r");
hold on
th.ss = th.T(:, end);
th.x_real = find(ismember(th.x, tc));
th_plot = plot(th.t, th.T(:, th.x_real), LineWidth = 1.5, Color="b", LineStyle="--");
grid on
title('Transient State Temperatures over Length of Fin')
xlabel('Time (seconds)')
ylabel('Temperature (^o C)')
legend([exp_plot(1), th_plot(1)], {'Experimental T', 'Theoretical T'})
ax2 = gca;

%% 5 | Uncertainty
clear udata u
udata = readmatrix('Uncertainty.txt', 'NumHeaderLines', 2);
u.t = udata(:,1);
for i = 1 : size(udata, 2) - 1 
    u(i).ch = udata(:,i+1);
    u_ss(i) = mean(u(i).ch(:, 1));
end

err = (u_ss(1:7) - T_ss)/2;
errorbar(ax1, tc, T_ss, err, 'DisplayName', 'Experimental T_{ss} errorbars', LineWidth = 1.5, Color="r")


