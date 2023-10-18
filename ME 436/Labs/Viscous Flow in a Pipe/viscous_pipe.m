clc
clear
close all

set(0,'DefaultFigureWindowStyle','docked')

%% 0 | Data

set(1).freq = 45;                                                                                       % Hz
set(1).x = [12.75, 28.25, 52.25, 79.5, 103.5, 127.25, 151.25, 175.25, 212.25, 219.25, 229.25, 251.25];  % in.
set(1).p = [0.2, 1.5, 1.54, 1.56, 1.56, 1.58, 1.6, 1.62, 1.6, 1.68, 2.3, 1.8];                          % in.H20
set(1).r = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6]; 
set(1).delp = [0, 0.1, 0.1, 0.14, 0.16, 0.18, 0.2, 0.18, 0.16, 0.14, 0.1];

set(2).freq = 47;                                                                                       % Hz
set(2).x = [12.75, 28.25, 52.25, 79.5, 103.5, 127.25, 151.25, 175.25, 212.25, 219.25, 229.25, 251.25];  % in.
set(2).p = [0.22, 1.7, 1.7, 1.72, 1.72, 1.76, 1.78, 1.78, 1.82, 1.82, 2.54, 2];                         % in.H20
set(2).r = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6]; 
set(2).delp = [0, 0.1, 0.14, 0.16, 0.18, 0.2, 0.18, 0.2, 0.18, 0.14, 0.1];

u_mano = 0.01;
rho = 1.204;    % kg/m^3
da = 138/1000;  % m
db = 90/1000;   % m

%% 1 | Conversions and Pressure along Pipe

convx = 1/39.37;    % m
convp = 249.08;     % Pa

for i = 1 : length(set)
    set(i).x = set(i).x .* convx;
    set(i).p = set(i).p .* convp;

    plot(set(i).x, -set(i).p, '.-')
    hold on 
end

title('Pressure drop along pipe')
xlabel('Distance (m)')
ylabel('Pressure (Pa)')
legend('Set 1', 'Set 2')
grid on
hold off

%% 2 | Flow Rate using Venturi vs. Flow Rate using Pitot

for i = 1: length(set)
    % Venturi flow rate
    set(i).ventdelp = set(i).p(11) - set(i).p(10);
    set(i).Umean = sqrt( (2/(((da/db)^4) - 1)).*(set(i).ventdelp/rho) );
    set(i).venturiQ = set(i).Umean .* (pi()*(db/2)^2);

    % Pitot flow rate
    set(i).delp = set(i).delp .* convp;
    set(i).r = (set(i).r - 1) .* convx - da/2;
    set(i).vel = sqrt( 2*(set(i).delp/rho) );
    set(i).pitotQ = pi() .* ( set(i).vel * set(i).r(11) );
end

%% 3 | Theoretical and experimental velocity profiles in pipe

figure;
for i = 1: length(set)
    plot(set(i).vel, set(i).r, '.-')
    hold on

    set(i).velmax = max(set(i).vel);
    n = 7;
    r = linspace(-da/2, da/2, 100);
    set(i).veltheor = set(i).velmax * ( 1 - ((r).^2)/((da/2)^2) ).^(1/n);
    plot(set(i).veltheor, r)
end

title('Velocity vs radius of pipe')
xlabel('Velocity (m/s)')
ylabel('Radius (m)')
legend('Set 1', 'Set 2', 'Theoretical')
grid on
hold off

%% 4 | Error in Venturi flow rate, Pitot velocity profile

figure;
syms ventdelp delp
for i = 1: length(set)
    % Venturi flow rate error
    venturiQ = sqrt( (2/(((da/db)^4) - 1)).*(ventdelp/rho) ) * (pi()*(db/2)^2);
    pdelp = subs(diff(venturiQ, ventdelp), ventdelp, set(i).ventdelp);

    venturiQ_err = sqrt( (pdelp .* u_mano).^2 );
    venturiQ_err = double(venturiQ_err);

    % Pitot velocity profile error
    vel = sqrt( 2*(delp/rho) );
end
