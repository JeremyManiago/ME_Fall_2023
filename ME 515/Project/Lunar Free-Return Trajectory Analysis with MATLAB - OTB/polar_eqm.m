function ydot = polar_eqm (t, y)

% lunar free return geocentric polar equations of motion

% input

%  t    = simulation time (seconds)
%  y(1) = radial distance (kilometers)
%  y(2) = radial component of velocity vector (kilometers/second)
%  y(3) = tangential component of velocity vector (kilometers/second)
%  y(4) = earth-to-spacecraft central angle (radians)

% output

%  ydot(1) = r-dot
%  ydot(2) = vr-dot
%  ydot(3) = vt-dot
%  ydot(4) = theta-dot

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu_earth mu_moon omega_moon distance_e2m

% extract current geocentric polar coordinates

r = y(1);

vr = y(2);

vt = y(3);

theta = y(4);

rm2sc = sqrt(r^2 + 2.0 * distance_e2m * r * cos(theta) + distance_e2m^2);

% first-order equations of motion

ydot = [ vr
    
(vt^2 / r) - (mu_earth / r^2) + 2.0 * omega_moon * vt + (omega_moon^2 * r) ...
- (mu_moon * (r + distance_e2m * cos(theta)) / rm2sc^3) ...
+ (mu_moon * cos(theta)) / distance_e2m^2;

-vr * vt / r - 2.0 * omega_moon * vr - mu_moon * sin(theta) / distance_e2m^2 ...
    + (mu_moon * distance_e2m * sin(theta)) / rm2sc^3;

vt / r];



