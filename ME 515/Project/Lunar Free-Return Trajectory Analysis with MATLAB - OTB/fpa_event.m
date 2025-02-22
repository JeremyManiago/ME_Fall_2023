function [value, isterminal, direction] = fpa_event(t, y)

% selenocentric flight path angle event function

% input

%  t = simulation time (seconds)
%  y = third body geocentric state vector (km, km/sec)

% output

%  value = sine of selenocentric flight path angle

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global distance_e2m vlc_moon omega_moon

% inertial geocentric lunar position vector (kilometers)
    
theta_moon = omega_moon * t;

rmoon(1) = distance_e2m * cos(theta_moon);

rmoon(2) = distance_e2m * sin(theta_moon);

% inertial geocentric lunar velocity vector (kilometers/second)

vmoon(1) = -vlc_moon * sin(theta_moon);

vmoon(2) = vlc_moon * cos(theta_moon);

% form the selenocentric third body position and velocity

rm2sc(1) = y(1) - rmoon(1);

rm2sc(2) = y(2) - rmoon(2);

vm2sc(1) = y(3) - vmoon(1);

vm2sc(2) = y(4) - vmoon(2);

% sine of the selenocentric flight path angle

value = rm2sc * vm2sc' / (norm(rm2sc) * norm(vm2sc));

isterminal = 1;

direction =  [];

