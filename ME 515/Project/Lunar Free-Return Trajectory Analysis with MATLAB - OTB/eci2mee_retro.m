function mee = eci2mee_retro(mu, reci, veci)

% convert eci state vector to retrograde modified equinoctial elements

% input

%  mu   = gravitational constant (km**3/sec**2)
%  reci = eci position vector (kilometers)
%  veci = eci velocity vector (kilometers/second)

% output

%  mee(1) = semiparameter (kilometers)
%  mee(2) = f equinoctial element
%  mee(3) = g equinoctial element
%  mee(4) = h equinoctial element
%  mee(5) = k equinoctial element
%  mee(6) = true longitude (radians)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radius = norm(reci);

hvec = cross(reci, veci);

hmag = norm(hvec);

pmee = hmag^2 / mu;

rdotv = dot(reci, veci);

rzerod = rdotv / radius;

eccen = cross(veci, hvec);

uhat = reci / radius;

uhat = uhat / norm(uhat);

vhat = (radius * veci - rzerod * reci) / hmag;

vhat = vhat / norm(vhat);

eccen = eccen / mu - uhat;

% unit angular momentum vector

what = hvec / hmag;

% compute kmee and hmee

denom = 1.0 - what(3);

kmee = what(1) / denom;

hmee = -what(2) / denom;

% construct unit vectors in the equinoctial frame

fhat(1) = 1.0 - kmee^2 + hmee^2;
fhat(2) = 2.0 * kmee * hmee;
fhat(3) = 2.0 * kmee;

ghat(1) = -fhat(2);
ghat(2) = -(1.0 + kmee^2 - hmee^2);
ghat(3) = 2.0 * hmee;

ssqrd = 1.0 + kmee^2 + hmee^2;

% normalize

fhat = fhat / ssqrd;

ghat = ghat / ssqrd;

% compute fmee and gmee

fmee = dot(eccen, fhat);

gmee = dot(eccen, ghat);

% compute true longitude

cosl = uhat(1) - vhat(2);

sinl = -uhat(2) - vhat(1);

lmee = atan3(sinl, cosl);

% load modified equinoctial orbital elements array

mee(1) = pmee;
mee(2) = fmee;
mee(3) = gmee;
mee(4) = hmee;
mee(5) = kmee;
mee(6) = lmee;


