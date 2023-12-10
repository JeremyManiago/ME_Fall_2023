function oev = eci2orb3(mu, r, v)

% convert eci state vector to six classical orbital elements

% special version for free_return.m

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

rmag = norm(r);

vmag = norm(v);

vr = dot(r, v) / rmag;

hv = cross(r, v);

hmag = norm(hv);

rdotv = dot(r, v) / (rmag * vmag);

% orbital inclination (radians)

incl = acos(hv(3) / hmag);

% orbital eccentricity (non-dimensional)

ev = 1.0 / mu * ((vmag^2 - mu / rmag) * r - rmag * vr * v);

eccm = norm(ev);

% semimajor axis (kilometers)

sma = hmag ^ 2 / mu / (1.0 - eccm^2);

% true anomaly

c = mu * rmag;

a = hmag * rdotv / c;

b = hmag * hmag / c - 1.0;

tanom = atan3(a, b);

% right ascension

ras = atan3(r(2), r(1));

% argument of perigee (radians)

argper = ras - tanom;

if (argper < 0.0)
    
    argper = 2.0 * pi + argper;
    
end

% raan 

raan = 0.0;

% load orbital element vector

oev = [sma eccm incl argper raan tanom];

end
