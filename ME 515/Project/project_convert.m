%% *Orbital Mechanics Project: Free-Return Trajectory for Earth-Moon Mission*
% Code Initiation:

clc
clear
close all

set(0,'DefaultFigureWindowStyle','normal')
%% Optimal Parking Orbit Altitude
% For Hohmann Transfer between two circular orbits (from earth to parking orbit)

syms dVt dVp dVa ra z e
re = 6378;  % km
mu = 3.986e5;
ra = re + z
e = (ra - re)/(ra + re)
dVp = sqrt(mu/re)*(sqrt(1 + e) - 1);
dVa = sqrt(mu/ra)*(1 - sqrt(1 - e));
f1 = dVt == abs(dVp) + abs(dVa);
dVt = rhs(f1);
derdVt = diff(dVt, z)
f2 = 0 == derdVt;
x = lhs(f2);
% y = subs(rhs(f2), mu, 3.986e5)
y = rhs(f2);
zs = 100:50:5000;
plot(zs, subs(y, z, zs))
title({'Change of total velocity impulse for Hohmann Transfers', 'over different parking orbit altitudes'})
xlabel('z (km)')
ylabel('$\frac{d\Delta V_{total}}{dz} \ \left(\frac{1}{\rm{s}}\right)$', Interpreter='latex')
% dVt = subs(dVt, mu, 3.986e5)
plot(zs, subs(dVt, z, zs))
% title({'Total Velocity Impulse required to perform Hohmann Transfer', 'for different parking orbit altitudes'})
xlabel('z')
ylabel('dVt')
hold on
syms dep 
dep = (mu/2)*( (1/re) - (1/ra) )
% dep = subs(dep, mu, 3.986e5)
plot(zs, subs(dep, z, zs))
title({'Kinetic Energy and Total Velocity Impulse', 'for different parking orbit altitudes'})
xlabel('z')
ylabel('$\Delta \varepsilon$', Interpreter='latex')
legend('Total Velocity Impulse required to perform Hohmann Transfer', 'Kinetic Energy imparted to vehicle during two burns', Location='southoutside')
hold off
%% 
% Based on online sources, it is generally accepted that the optimal earth parking 
% orbit is in LEO (Low Earth Orbit), which is between 160km - 2000km. Apollo 11 
% went into a nearly circular earth parking orbit of ~185.9 km. Since that mission 
% was successful, a parking orbit of 190km will be used. It requires less total 
% velocity impulse to obtain the orbit via Hohmann Transfer compared to higher 
% LEOs, while still being high enough to avoid atmospheric drag.
%% 
% So, for z = 190km, we can get $\Delta V_p$, $\Delta V_a$, and $\Delta V_{total}$

z_val = 190;    % km
dVp_val = double(subs(dVp, z, z_val));  dVa_val = double(subs(dVa, z, z_val));  dVt_val = dVp_val + dVa_val;
disp([dVp_val, dVa_val, dVt_val])
%% 
% Assuming that the earth rotate counterclockwise, and 1 Sidereal Day = 86400 
% seconds, we can find the angular velocity of earth and thus the tangential velocity

ra_po = re + z_val
v_po = sqrt(mu/ra_po)
%% 
% Since c $\Delta V_p \approx \Delta V_a$, then at z = 190km, the velocity of 
% our spacecraft is $V_e$. Since we needs a 3-hour system checkout in the parking 
% orbit, we need to make sure that the orbit period is greater than 3 hours

sys_check = 3 * 60 * 60    % seconds
T_po = 2*pi*sqrt((ra_po^3)/mu)  % seconds
if (T_po > sys_check)
    disp('Proceed')
else
    disp('Spacecraft will orbit Earth more than once')
end
%% 
% Find eccentricity of transfer ellipse toward Lunar radius

rm = 1749;  % km, radius of Moon
a = re + z_val  % Semi-major axis of earth parking orbit
rp = a  % Perigee Radius of Transfer Ellipse
rem = 384400 % Apogee Radius of Transfer Ellipse, which is approximately the distance from the earth to the moon
e_em = 1 - rp/rem
% e_em = (rm - rp)/(rm + rp)  % Eccentricity of earth-moon transfer ellipse
a_em = rp / (1 - e_em)  % Semi-major axis of earth-moon transfer ellipse
soi_m = (0.073e24/5.97219e24)^(2/5)*(3.844e5)   % Radius of Sphere of Influence of Moon
a_em = sqrt( (rem)^2 + (soi_m)^2 )
dVp_m = sqrt(mu/rp)*(sqrt(1+e_em) - 1)
alpha = 90;    % Degrees
gamma = 12;     % Degrees
r0 = [-rp*cosd(alpha) -rp*sind(alpha)];
r1 = [ rem - soi_m*cosd(gamma) soi_m*sind(gamma)];
e = [0 0];
m = [rem 0];
x = [r0(1) r1(1) e(1) m(1)]
y = [r0(2) r1(2) e(2) m(2)]
fig = figure(); 
fig.Position(3:4) = [1000, 500];
% axis([(-1.0e4)*2 (5.0e5)*2 (-1.0e4) (5.0e5)]);
hold on
plot(x, y, Marker="o", MarkerSize=10, MarkerFaceColor="auto", LineStyle="none")
t = 0: pi / 50.0: 2.0 * pi;

% plot Earth

plot(re*sin(t), re*cos(t), 'Color', 'g');
plot(rm*sin(t) + rem, rm*cos(t), 'Color', 'g');

% plot circular earth orbit

plot(rp * sin(t), rp * cos(t), 'Color', 'r');

% plot Moon SOI

plot((soi_m * sin(t)) + rem, (soi_m * cos(t)), 'Color', 'r');

rvec = r1 - r0
% plot([r0(1) r1(1)], [r0(2) r1(2)])