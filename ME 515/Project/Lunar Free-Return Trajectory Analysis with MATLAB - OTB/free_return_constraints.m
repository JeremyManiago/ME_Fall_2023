function [c, ceq] = free_return_constraints(x)

% lunar free return simple shooting constraints

% input

%  x(1) = current update to TLI departure angle
%  x(2) = current update to TLI deltav

% output

%  f(1) = objective function (tli delta-v magnitude)
%  f(2) = selenocentric radius (normalized)
%  f(3) = y-component of relative position vector (kilometers)
%  f(4) = x-component of relative velocity vector (kilometers/second)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global distance_e2m vlc_moon radius_moon omega_moon

global radius_leo radius_lmo vlc_leo tevent yevent rm2sc vm2sc rrel vrel

% current TLI maneuver angle

theta_pe = x(1);

% current inertial TLI state vector

ri(1) = radius_leo * cos(theta_pe);

ri(2) = radius_leo * sin(theta_pe);

vpe = vlc_leo + x(2);

vi(1) = -vpe * sin(theta_pe);

vi(2) = vpe * cos(theta_pe);

% set up options for ode45

options = odeset('RelTol', 1.0e-10, 'AbsTol', 1.0e-10, 'Events', @fpa_event);

% solve for lunar closest approach conditions

tend = 7.0 * 86400.0;

[~, ~, tevent, yevent, ~] = ode45(@free_return_eqm, [0 tend], [ri vi], options);

% geocentric inertial lunar position vector (kilometers)
    
theta_moon = omega_moon * tevent;

re2m(1) = distance_e2m * cos(theta_moon);

re2m(2) = distance_e2m * sin(theta_moon);

% geocentric inertial lunar velocity vector (kilometers/second)

ve2m(1) = -vlc_moon * sin(theta_moon);

ve2m(2) = vlc_moon * cos(theta_moon);

% compute selenocentric inertial state vector of the third body

rm2sc(1) = yevent(1) - re2m(1);

rm2sc(2) = yevent(2) - re2m(2);

vm2sc(1) = yevent(3) - ve2m(1);

vm2sc(2) = yevent(4) - ve2m(2);

% third body position vector in rotating system

rrel(1) = yevent(1) * cos(theta_moon) ...
        + yevent(2) * sin(theta_moon);
    
rrel(2) = -yevent(1) * sin(theta_moon) ...
        + yevent(2) * cos(theta_moon);
    
rrel(3) = 0.0;

% angular rotation vector (radians/second)

omegav = omega_moon * [0.0 0.0 1.0];

% third body velocity vector in rotating system

vrel = cross(omegav, rrel);

% current selenocentric periapsis radius equality constraint

ceq(1) = (norm(rm2sc) / radius_moon) - (radius_lmo / radius_moon);

% y-component of relative position vector constraint

ceq(2) = rrel(2);

% no inequality constraints

c = [];
