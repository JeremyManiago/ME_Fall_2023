%% *Orbital Mechanics Project: Free-Return Trajectory for Earth-Moon Mission*
% Code Initiation:

clc
clear
close all
format long

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
%% Parking Orbit, 3 hour system check, and preparation for TLI
% For z = 190km, we can get $\Delta V_p$, $\Delta V_a$, and $\Delta V_{total}$

z_val = 190;    % km
dVp_val = double(subs(dVp, z, z_val));  dVa_val = double(subs(dVa, z, z_val));  dVt_val = dVp_val + dVa_val;
disp([dVp_val, dVa_val, dVt_val])
po.r = re + z_val;
po.v = sqrt(mu/po.r)
a_transfer = (re + po.r)/2
%% 
% Since c $\Delta V_p \approx \Delta V_a$, then at z = 190km, the velocity of 
% our spacecraft is $V_e$. Since we needs a 3-hour system checkout in the parking 
% orbit, we need to make sure that the spacecraft orbits for more than 3 hours

sys_check = 3    % hours
po.T = 2*pi*sqrt((po.r^3)/mu)/ (60*60)  % hours
if (po.T > sys_check)
    disp('Proceed')
else
    disp('Spacecraft will orbit Earth more than once')
end
sys_check/po.T
sys_check - (po.T * 2)
%% 
% Assuming that the spacecraft launched at the left of the Earth ($0 ^o$ w.r.t. 
% the earth-moon line) and the spacecraft reached parking orbit at the right of 
% Earth ($180^o$ counterclockwise w.r.t. the earth-moon line), the spacecraft 
% must stay in the parking orbit for at least 3 hours, orbiting 2 and a half times 
% if we want to apply TLI at $0 ^o$ w.r.t. the earth-moon line.

T.hohmann = pi*sqrt((a_transfer^3)/mu) / (60*60);   % hours
T.sys = sys_check;
T.sys_to_tli = (po.T * 2.5) - sys_check
%% Transfer from Earth to Moon, Earth Centered Frame
% Find eccentricity of transfer ellipse toward Lunar radius

m.r = 1749;  % km, radius of Moon
a = po.r  % Semi-major axis of earth parking orbit
rp = a  % Perigee Radius of Transfer Ellipse
rem = 384400 % Apogee Radius of Transfer Ellipse, which is approximately the distance from the earth to the moon
e_em = 1 - rp/rem
% e_em = (m.r - rp)/(m.r + rp)  % Eccentricity of earth-moon transfer ellipse
a_em = rp / (1 - e_em)  % Semi-major axis of earth-moon transfer ellipse
m.soi = (0.073e24/5.97219e24)^(2/5)*(3.844e5)   % Radius of Sphere of Influence of Moon
a_em = sqrt( (rem)^2 + (m.soi)^2 )
dVp_m = sqrt(mu/rp)*(sqrt(1+e_em) - 1)
%% 
% *Figure 9.2* from _Orbital Mechanics for Engineering Students, Fourth Edition_ 
% by Howard D. Curtis:
% 
% 

alpha = 0;      % Degrees
gamma = 0;      % Degrees
lam = 69;       % Degrees (guess value, preferable close to textbook examples and Lecture Notes 17 example)
r0 = [-rp*cosd(alpha) -rp*sind(alpha) 0];           % Position Vector of Translunar Injection
r1 = [ rem - m.soi*cosd(lam) m.soi*sind(lam) 0];    % Position Vector of Patch Point
x = [r0(1) r1(1)]
y = [r0(2) r1(2)]
fig = figure(); 
fig.Position(3:4) = [1000, 500];
axis([(-1.0e4)*2 (5.0e5)*2 (-1.0e4) (5.0e5)]);
hold on
plot(x, y, Marker="x", MarkerSize=8, MarkerEdgeColor="b", LineWidth=1.5, LineStyle="none")

te = 0: 180.0 / 50.0: 2.0 * 180.0;

% plot Earth and Moon

plot(re*sind(te), re*cosd(te), 'Color', 'g');
plot(m.r*sind(te) + rem, m.r*cosd(te), 'Color', 'g');

% plot circular earth orbit

plot(rp * sind(te), rp * cosd(te), 'Color', 'r');

% plot Moon SOI

plot((m.soi * sind(te)) + rem, (m.soi * cosd(te)), 'Color', 'r');
% lam = atand(r1(2)/(rem - r1(1)))

% plot predicted transfer ellipse
rvec = r1 - r0
% x_ell = rvec(1) * sind(t)
% y_ell = rp * cosd(t)
% plot(x_ell + , y_ell, 'Color', 'b') 
plot([rem r1(1)], [0 0])
plot([r1(1) r1(1)], [0 r1(2)])
hold off
% Unit vectors of position vectors r0 and r1
r0mag = norm(r0);
u0 = r0/r0mag;
r1mag = norm(r1);
u1 = r1/r1mag;

% Lagrange Coefficients
%% 
% Sweep angle: 
% 
% $$\cos(\Delta \theta) = \bf{\hat{u}}_{\rm{r_0}} \cdot \bf{\hat{u}}_{\rm{r_1}} 
% $$

sweep = acosd(dot(u0, u1))
h1 = (sqrt(mu*r0mag))*(sqrt( (1 - cosd(sweep)) / ((r0mag/r1mag) + sind(sweep)*tand(gamma) - cosd(sweep)) ))
f = 1 - (mu*r1mag/(h1^2))*(1 - cosd(sweep))
g = (r0mag*r1mag/h1)*(sind(sweep))
g_dot = 1 - (mu*r0mag/(h1^2))*(1 - cosd(sweep))
% Velocities vectors
v0 = (1/g)*(r1 - f.*r0)
v0mag = norm(v0)
vr0 = dot(v0, u0)
v1 = (1/g)*(g_dot.*r1 - r0)
v1mag = norm(v1)
vr1 = dot(v1, u1)
dV0 = sqrt(po.v^2 + v0mag^2 - 2*po.v*v0mag*cosd(gamma)) % Delta V (TLI)
e1 = (1/mu)*((v0mag^2 - (mu/r0mag))*r0 - r0mag*vr0*v0)  % Eccentricity vector of translunar trajectory
e1mag = norm(e1)   % Eccentricity of translunar trajectory
%% 
% Perifocal Unit Vectors

p1 = e1/e1mag
w1 = cross(r1, v1)/h1
q1 = cross(w1, p1)
a1 = (h1^2/mu)*(1/(1 - (e1mag)^2)) % Semimajor axis of transfer ellipse
T1 = 2*pi*sqrt((a1^3)/mu)   % Period of TLJ in Seconds
theta0 = acosd(dot(p1, u0))
theta1 = theta0 + sweep
%% 
% Time of TLI and time of arrival at patch point:

Tterm = T1/(2*pi);
eterm = sqrt((1 - e1mag)/(1 + e1mag));
term0 = 2*atan(eterm*tand(theta0/2));
t0 = Tterm*( term0 - (e1mag*sin(term0)) )
term1 = 2*atan(eterm*tand(theta1/2));
t1 = Tterm*( term1 - (e1mag*sin(term1)) )
T.tli = t1 - t0
%% 
% Here, $\Delta t_1 = t_1 - t_0 = t_1$ because we applied TLI at $\alpha_o= 
% 0^o$
%% Moon-Centered Frame
% Now we can treat this problem like a Lunar Flyby.

m.mu = 4.90487e3;  % Gravitational Parameter of Moon
%% 
% The angular speed of the Moon w.r.t to the Earth can be estimated to be the 
% tangential velocity for a rotating frame and assuming a circular orbit

m.V = [0 sqrt(mu/rem) 0]
%% 
% Velocity at arrival point relative to the Moon

r2 = [ -m.soi*cosd(lam) m.soi*sind(lam) 0]    % Position Vector of Lunar Arrival relative to Moon
r2mag = norm(r2);
u2 = r2/r2mag;  % Unit Vector of r2
v2 = v1 - m.V
v2mag = norm(v2)
vr2 = dot(v2, u2)
h2 = cross(r2, v2)
h2mag = norm(h2)
e2 = ((cross(v2, h2))/m.mu) - u2
e2mag = norm(e2)
%% 
% Perilune Radius and Altitude

m.rp = ((h2mag^2)/m.mu)*(1/(1+ e2mag))
m.z = m.rp - m.r;
disp("Perilune Altitude = " + m.z + " > 100km")
%% 
% Perifocal Unit Vector

p2 = (e2/e2mag)
%% 
% True anomaly of patch point on lunar approach hyperbola, measured positive 
% clockwise from perilune

theta2 = 360 - acosd(dot(p2, u2))
%% 
% Time relative to Perilune at patch point

one = (h2mag^3)/((m.mu^2)*(((e2mag^2) - 1)^(3/2)));
e2term = sqrt((e2mag - 1)/(e2mag + 1));
term2 = 2*atanh(e2term*tand(theta2/2));
t2 = one*( (e2mag*sinh(term2)) - 2*term2 )
%% 
% Since this is time _until_ Perilune, the elapsed time from the Patch Point 
% to Perilune is

T.perilune = 0 - t2
%% Lunar Exit and Earth return

T.tli = T.tli/(60*60);          % hours
T.perilune = T.perilune/(60*60); % hours
%% 
% Assuming that the return trajectory is a mirror of the approach trajectory, 
% then the time elapsed from TLI to Earth Orbit Return is

T.translunar = 2*(T.tli + T.perilune)
%% Earth Splashdown
% Assume that the spacecraft has 

global beta rho0 H g
A = 19.87e-6;
m = 9300;
Cd = 1.5
rho0 = 1.28e9;
H = 9;
y0 = 190;
gamma = 0;
v0 = 11;
g = 9.81e-3;
beta = (Cd*A)/(2*m);
tspan = [0 500];
yi = [v0*cosd(gamma) v0*sind(gamma) 0 y0];
[ts, y] = ode45(@yprime, tspan, yi);
plot(y(:, 3), y(:, 4))
xlabel('x (km)')
ylabel('y (km)')
grid
T.splashdown = ts(154) / (60*60)
%% Mission Parameters

T.total = T.hohmann + T.sys + T.sys_to_tli + T.translunar + T.splashdown;
total = T.total / 24;
T.begin = caldays(0) + hours(0.0);
T.launch = time(T.begin);
T.parking = time(T.begin + hours(T.hohmann));
T.system_check = T.parking + hours(T.sys);
T.TranslunarInjection = T.system_check + hours(T.tli);
T.Perilune = T.TranslunarInjection + hours(T.perilune);
T.EarthArrival = T.system_check + hours(T.translunar);
T.Splashdown = T.EarthArrival + hours(T.splashdown);
fields = {'hohmann', 'sys', 'sys_to_tli', 'tli', 'perilune', 'translunar', 'splashdown', 'total'};
T = rmfield(T, fields);
T
disp("Total Mission time = " + total + " days")
disp("Delta V required for Translunar Injection Burn = " + dV0 + " km/s at a flight path angle of " + gamma + " degrees")
%%
function  yp = yprime(ts,y)
global beta rho0 H g
rho = rho0*exp(-y(4)/H);
v = sqrt(y(1)^2 + y(2)^2);
yp = [-beta*rho*v*y(1);
      -beta*rho*v*y(2) - g;
      y(1);
      y(2)];
end