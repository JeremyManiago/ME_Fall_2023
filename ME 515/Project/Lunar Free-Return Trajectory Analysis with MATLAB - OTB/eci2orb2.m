function oev = eci2orb2 (mu, r, v)

% convert eci state vector to six classical orbital
% elements via equinoctial elements

% input

%  mu = central body gravitational constant (km**3/sec**2)
%  r  = eci position vector (kilometers)
%  v  = eci velocity vector (kilometers/second)

% output

%  oev(1) = semimajor axis (kilometers)
%  oev(2) = orbital eccentricity (non-dimensional)
%           (0 <= eccentricity < 1)
%  oev(3) = orbital inclination (radians)
%           (0 <= inclination <= pi)
%  oev(4) = argument of perigee (radians)
%           (0 <= argument of perigee <= 2 pi)
%  oev(5) = right ascension of ascending node (radians)
%           (0 <= raan <= 2 pi)
%  oev(6) = true anomaly (radians)
%           (0 <= true anomaly <= 2 pi)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pi2 = 2.0 * pi;

% position and velocity magnitude

rmag = norm(r);

vmag = norm(v);

% position unit vector

rhat = r / rmag;

% angular momentum vectors

hv = cross(r, v);

% eccentricity vector

vtmp = v / mu;

ecc = cross(vtmp, hv);

ecc = ecc - rhat;

% semimajor axis

sma = 1.0 / (2.0 / rmag - vmag * vmag / mu);

% orbital eccentricity

eccm = norm(ecc);

% orbital inclination

inc = 0.0;

% raan

raan = 0.0;

% argument of periapsis

argper = 0.0;

% true anomaly

tanom = 0.0;

% load orbital element vector

oev(1) = sma;
oev(2) = eccm;
oev(3) = inc;
oev(4) = argper;
oev(5) = raan;
oev(6) = tanom;
