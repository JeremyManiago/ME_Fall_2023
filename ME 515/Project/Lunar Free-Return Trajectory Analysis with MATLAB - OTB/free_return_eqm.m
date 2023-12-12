function ydot = free_return_eqm (t, y)

% lunar free return geocentric first order equations of motion

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

rpe = sqrt(xp^2 + yp^2);

% angular location of the moon

theta_moon = omega_moon * t;

% geocentric position vector of the moon (kilometers)

xm = distance_e2m * cos(theta_moon);

ym = distance_e2m * sin(theta_moon);

rpm = sqrt((xp - xm)^2 + (yp - ym)^2);

% first-order equations of motion

ydot = [ up
    
wp

-(mu_earth / rpe^3) * xp - (mu_moon / rpm^3) * (xp - xm)

-(mu_earth / rpe^3) * yp - (mu_moon / rpm^3) * (yp - ym)];

