function ydot = eci_eqm (t, y)

% geocentric equations of motion

% version for free_return.m

% input

%  t = simulation time (seconds)
%  y = state vector (kilometers and kilometers/second)

% output

%  ydot = integration vector

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu_moon mu_earth omega_moon distance_e2m

% acceleration due to the earth

r2 = y(1) * y(1) + y(2) * y(2) + y(3) * y(3);

r1 = sqrt(r2);

r3 = r2 * r1;

for i = 1:1:3
    
    agrav(i) = -mu_earth * y(i) / r3;
    
end

theta_moon = omega_moon * t;

% geocentric position vector of the moon (kilometers)

rmoon(1) = distance_e2m * cos(theta_moon);

rmoon(2) = distance_e2m * sin(theta_moon);

rmoon(3) = 0.0;

% selenocentric position vector of the third body

for i = 1:1:3
    
    rm2sc(i) = y(i) - rmoon(i);
    
end

% f(q) formulation

for i = 1:1:3
    
    vtmp(i) = y(i) - 2.0d0 * rmoon(i);
    
end

dot1 = dot(y(1:3), vtmp);

dot2 = dot(rmoon, rmoon);

qmoon = dot1 / dot2;

fmoon = qmoon * ((3.0d0 + 3.0d0 * qmoon + qmoon * qmoon) ...
    / (1.0d0 + (1.0d0 + qmoon)^1.5d0));

d3moon = norm(rm2sc)^3;

% point-mass gravity of the moon

for i = 1:1:3
    
    amoon(i) = -mu_moon * (y(i) + fmoon * rmoon(i)) / d3moon;
    
end

% compute total integration vector

ydot = [ y(4)
    y(5)
    y(6)
    agrav(1) + amoon(1)
    agrav(2) + amoon(2)
    agrav(3) + amoon(3)];








