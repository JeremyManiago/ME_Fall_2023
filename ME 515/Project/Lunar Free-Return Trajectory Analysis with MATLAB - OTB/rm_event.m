function [value, isterminal, direction] = rm_event(t, y)

% selenocentric distance event function

% input

%  t = simulation time (seconds)
%  y = spacecraft geocentric state vector (km, km/sec)

% output

%  value = selenocentric distance delta (kilometers)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global distance_e2m vlc_moon radius_soi omega_moon rm2sc_soi vm2sc_soi

% inertial geocentric lunar position vector (kilometers)
    
theta_moon = omega_moon * t;

rmoon(1) = distance_e2m * cos(theta_moon);

rmoon(2) = distance_e2m * sin(theta_moon);

% inertial geocentric lunar velocity vector (kilometers/second)

vmoon(1) = -vlc_moon * sin(theta_moon);

vmoon(2) = vlc_moon * cos(theta_moon);

% form the moon-centered state vector

rm2sc_soi(1) = y(1) - rmoon(1);

rm2sc_soi(2) = y(2) - rmoon(2);

vm2sc_soi(1) = y(3) - vmoon(1);

vm2sc_soi(2) = y(4) - vmoon(2);

% selenocentric distance

value = norm(rm2sc_soi) - radius_soi;

isterminal = 1;

direction =  [];



