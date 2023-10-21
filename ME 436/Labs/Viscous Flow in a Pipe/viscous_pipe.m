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

u_mano = 0.01;  % in.H2O
rho = 1.204;    % kg/m^3
da = 138/1000;  % m
db = 90/1000;   % m

%% 1 | Conversions and Pressure along Pipe

convx = 1/39.37;    % m
convp = 249.08;     % Pa

for i = 1 : length(set)
    set(i).x = set(i).x .* convx;
    set(i).p = set(i).p .* convp;

    p(i).p = plot(set(i).x, -set(i).p);
    p(i).p.Marker = 'o';
    p(i).p.MarkerSize = 5;
    hold on 
end

p(1).p.LineWidth = 1.5;
p(1).p.Color = 'b';
p(2).p.LineWidth = 1.5;
p(2).p.Color = 'r';

title('Pressure drop along pipe')
xlabel('Distance (m)')
ylabel('Pressure (Pa)')
legend('Set 1 (45Hz)', 'Set 2 (47Hz)')
grid on
hold off

%% 2 | Flow Rate using Venturi vs. Flow Rate using Pitot

syms r

for i = 1: length(set)
    % Venturi flow rate
    set(i).ventdelp = set(i).p(11) - set(i).p(10);
    set(i).Umean = sqrt( (2/(((da/db)^4) - 1)).*(set(i).ventdelp/rho) );
    set(i).venturiQ = set(i).Umean .* (pi()*(db/2)^2);
    set(i).venturiQ = double(set(i).venturiQ);

    % Pitot flow rate
    set(i).delp = set(i).delp .* convp;
    set(i).r = (set(i).r - 1) .* convx;
    set(i).vel = sqrt( 2.*(set(i).delp ./ rho) );
    % u_times_r = set(i).vel * r;
    % pitotQ = 2*pi()*( -int(u_times_r, [-da/2 0]) + int(u_times_r, [0 da/2]) );
    % set(i).pitotQ = double(pitotQ);
    set(i).pitotQ = 2*pi()*trapz(da/20, set(i).vel.*set(i).r);
    set(i).pitotQ = double(set(i).pitotQ);
    set(i).r = set(i).r - da/2;
end

%% 3 | Theoretical and experimental velocity profiles in pipe

figure;
for i = 1: length(set)
    p(i).v = plot(set(i).vel, set(i).r);
    p(i).v.Marker = 'o';
    p(i).v.MarkerSize = 5;
    hold on

    set(i).velmax = max(set(i).vel);
    n = 7;
    r = linspace(-da/2, da/2, 100);
    set(i).veltheor = set(i).velmax * ( 1 - ((r).^2)/((da/2)^2) ).^(1/n);
    plot(set(i).veltheor, r, 'g', LineWidth = 1.5)
end

p(1).v.LineWidth = 1.5;
p(1).v.Color = 'b';
p(2).v.LineWidth = 1.5;
p(2).v.Color = 'r';

title('Velocity vs radius of pipe')
xlabel('Velocity (m/s)')
ylabel('Radius (m)')
legend('Set 1 (45 Hz)', '', 'Set 2 (47Hz)', 'Theoretical')
grid on
hold off

%% 4 | Error in Venturi flow rate, Pitot velocity profile

u_mano = u_mano * convp;

figure;
syms ventdelp delp
for i = 1: length(set)
    % Venturi flow rate error
    venturiQ = sqrt( (2/(((da/db)^4) - 1)).*(ventdelp/rho) ) * (pi()*(db/2)^2);
    pventdelp = subs(diff(venturiQ, ventdelp), ventdelp, set(i).ventdelp);

    venturiQ_err = sqrt( (pventdelp .* u_mano).^2 );
    venturiQ_err = double(venturiQ_err);

    % Pitot velocity profile error
    vel = sqrt( 2*(delp/rho) );
    pdelp = subs(diff(vel, delp), delp, set(i).delp(2:11));

    pdelp_err = sqrt( (pdelp*u_mano).^2 );
    pdelp_err = double(pdelp_err);
end

e1 = errorbar(set(1).vel(2:11), set(1).r(2:11), pdelp_err, 'horizontal');
e1.Color = 'b';
e1.LineWidth = 1.5;
hold on
plot(set(1).veltheor, r, 'g', LineWidth = 1.5)
title('Velocity vs radius of pipe errorbars')
xlabel('Velocity (m/s)')
ylabel('Radius (m)')
legend('Set 1 (45 Hz)', 'Theoretical')
grid on
hold off
figure;

e2 = errorbar(set(2).vel(2:11), set(2).r(2:11), pdelp_err, 'horizontal');
e2.Color = 'r';
e2.LineWidth = 1.5;
hold on
plot(set(2).veltheor, r, 'g', LineWidth = 1.5)
title('Velocity vs radius of pipe errorbars')
xlabel('Velocity (m/s)')
ylabel('Radius (m)')
legend('Set 2 (47 Hz)', 'Theoretical')
grid on
hold off