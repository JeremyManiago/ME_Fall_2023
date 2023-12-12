function theta = sepang (r1, r2, rhat)

% separation angle between two coplanar vectors

% input

%  r1 = first vector
%  r2 = second vector
%  rhat = rotation direction unit vector
%       = [+1 0 0] ==> from r1 to r2 
%       = [-1 0 0] ==> from r2 to r1

% output

%  theta = separation angle (radians)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r1xr2 = cross(r1, r2);

% sine of sep angle

sa = norm(r1xr2);

sa = sign(dot(r1xr2, rhat)) * sa;

% cosine of sep angle

ca = dot(r1, r2);

theta = atan3(sa, ca);
