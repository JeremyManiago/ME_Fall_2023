function oev = eci2orb5(mu, r, v)

% convert eci state vector to six classical orbital elements

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
%  oev(5) = argument of perigee (radians)
%           (0 <= argument of perigee <= 2 pi)
%  oev(5) = right ascension of ascending node (radians)
%           (0 <= raan <= 2 pi)
%  oev(6) = true anomaly (radians)
%           (0 <= true anomaly <= 2 pi)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ww(1) = r(2) * v(3) - r(3) * v(2);

ww(2) = r(3) * v(1) - r(1) * v(3);

ww(3) = r(1) * v(2) - r(2) * v(1);

c = sqrt(ww(1)^2 + ww(2)^2 + ww(3)^2);

ww(1) = ww(1) / c;

ww(2) = ww(2) / c;

ww(3) = ww(3) / c;

xnu(1) = -ww(2);

xnu(2) = ww(1);

xnum = sqrt(ww(2)^2 + ww(1)^2);

p = c * c / mu;

rm = sqrt(r(1)^2 + r(2)^2 + r(3)^2);

vm = sqrt(v(1)^2 + v(2)^2 + v(3)^2);

rd = (r(1) * v(1) + r(2) * v(2) + r(3) * v(3));

% semimajor axis

oev(1) = rm / (2.0 - rm * vm * vm / mu);

% eccentricity

oev(2) = sqrt(abs(1.0 - p / oev(1)));

% orbital inclination

oev(3) = acos(ww(3));

% true anomaly

if (oev(2) < 1.0e-10)
    
    oev(2) = 0.0;
    
else
    
    cta = (p - rm) / (oev(2) * rm);
    
    sta = rd * c / (oev(2) * mu * rm);
    
    oev(6) = atan3(sta, cta);
    
end

if (abs(oev(3)) < 1.0e-10)
    
    cta = r(1) / rm;
    
    sta = r(2) / rm;
    
    oev(6) = atan3(sta, cta);
    
else
    
    xnup(1) = -ww(3) * ww(1);
    
    xnup(2) = -ww(3) * ww(2);
    
    xnup(3) = ww(1)^2 + ww(2)^2;
    
    xnupm = sqrt(xnup(1)^2 + xnup(2)^2 + xnup(3)^2);
    
    cta = (r(1) * xnu(1) + r(2) * xnu(2)) / (rm * xnum);
    
    sta = (r(1) * xnup(1) + r(2) * xnup(2) + r(3) * xnup(3)) / (rm * xnupm);
    
    oev(6) = atan3(sta, cta);
    
end

% raan

oev(5) = 0.0;

if (ww(3) == 0.0 || ww(3) == 1.0)
    
    % equatorial orbit
    
    oev(5) = 0.0;
    
else
    
    oev(5) = atan3(ww(1), -ww(2));
    
end

% argument of perigee

oev(4) = 0.0;

if (oev(2) < 1.0e-10)
    
    return;
    
else
    
    f = vm^2 - mu / rm;
    
    for i  =  1:3
        
        xl(i) = f * r(i) - rd * v(i);
        
    end
    
    dnul = xnu(1) * xl(1) + xnu(2) * xl(2);
    
    xlm = sqrt(xl(1)^2 + xl(2)^2 + xl(3)^2);
    
    if (abs(oev(3)) < 1.0e-10)
        
        cw = xl(1) / xlm;
        
        sw = xl(2) / xlm;
        
        oev(4) = atan3(sw, cw);
        
    else
        
        oev(4) = acos(dnul / (xnum * xlm));
        
        oev(4) = sign(xl(3)) * oev(4);
        
    end
    
end
