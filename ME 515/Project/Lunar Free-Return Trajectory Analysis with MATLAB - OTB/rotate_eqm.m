function ydot = rotate_eqm (t, y)

% lunar free return geocentric rotating first order equations of motion

% input

%  t    = simulation time (seconds)
%  y(1) = x-component of position vector (xp; kilometers)
%  y(2) = y-component of position vector (yp; kilometers)
%  y(3) = x-component of velocity vector (up; kilometers/second)
%  y(4) = y-component of velocity vector (wp; kilometers/second)

% output

%  ydot(1) = up
%  ydot(2) = wp
%  ydot(3) = up-dot
%  ydot(4) = wp-dot

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu_earth mu_moon omega_moon distance_e2m

% extract current geocentric state vector

xp = y(1);

yp = y(2);

up = y(3);

wp = y(4);

r = sqrt(xp^2 + yp^2);

s = sqrt((xp - distance_e2m)^2 + yp^2);

% first-order equations of motion

ydot = [ up
    
wp

2.0 * omega_moon * wp + omega_moon^2 * xp - (mu_earth / r^3) * xp ...
- (mu_moon / s^3) * (xp - distance_e2m)

-2.0 * omega_moon * up + omega_moon^2 * yp - (mu_earth / r^3) * yp ...
- (mu_moon / s^3) * yp];

