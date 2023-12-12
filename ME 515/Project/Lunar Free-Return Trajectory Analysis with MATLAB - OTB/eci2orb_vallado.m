function oev = eci2orb_vallado (mu, r, v)

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

% position and velocity magnitudes

rmag = norm(r);

vmag = norm(v);

% position unit vector

rhat = r / rmag;

% angular momentum vectors

hvec = cross(r, v);

hhat = hvec / norm(hvec);

% angulat momentum magnitude

hmag = norm(hvec);

% specific orbital energy

energy = 0.5 * vmag^2 - mu / rmag;

% semimajor axis

sma = -mu / (2.0 * energy);

if (hmag > 1.0e-10)
    
    % nodal vector
    
    nvec(1) = -hvec(2);
    
    nvec(2) = hvec(1);
    
    nvec(3) = 0.0;
    
    nmag = norm(nvec);
    
    c1 = vmag * vmag - mu / rmag;
    
    rdotv = dot(r, v);
    
    % orbital eccentricity vector
    
    for i = 1 : 3
        
        eccv(i)= (c1 * r(i) - rdotv * v(i)) / mu;
        
    end
    
    % eccentricity magnitude (non-dimensional)
    
    eccm = norm(eccv);
    
    % orbital inclination (radians)
    
    inc = acos(hhat(3));
    
    % determine type of orbit
    % (elliptical, parabolic, hyperbolic inclined)
    
    typeorbit = 'ei';
    
    % check for circular orbit
    
    if (eccm < 1.0e-10)
        
        % check for circular equatorial (inc = 0 or inc = 180)
        
        if  (inc < 1.0e-10) || (abs(inc - pi) < 1.0e-10)
            
            typeorbit = 'ce';
            
        else
            
            % circular inclined
            
            typeorbit = 'ci';
            
        end
        
    else
        
        % elliptical, parabolic, hyperbolic equatorial
        
        if  (inc < 1.0e-10) || (abs(inc - pi) < 1.0e-10)
            
            typeorbit = 'ee';
            
        end
        
    end
    
    % raan (radians)
    
    if (nmag > 1.0e-10)
        
        temp = nvec(1) / nmag;
        
        if (abs(temp) > 1.0)
            
            temp = sign(temp);
            
        end
        
        raan = acos(temp);
        
        if (nvec(2) < 0.0)
            
            raan = pi2 - raan;
            
        end
        
    else
        
        % no equatorial crossing
        
        raan = 0.0;
        
    end
    
    % argument of perigee
    
    if (strcmp(typeorbit, 'ei') == 1)
        
        argper = acos(dot(nvec, eccv) / (nmag * eccm));
        
        if (eccv(3) < 0.0)
            
            argper = pi2 - argper;
            
        end
        
    else
        
        argper = 0.0;
        
    end
    
    % true anomaly (radians)
    
    if (strcmp(typeorbit(1:1), 'e') == 1)
        
        tanom = dot(eccv, r) / (eccm * rmag);
        
        if (rdotv < 0.0)
            
            tanom = pi2 - tanom;
            
        end
        
    else
        
        tanom = 0.0;
        
    end
   
end

% load orbital element vector

oev(1) = sma;
oev(2) = eccm;
oev(3) = inc;
oev(4) = argper;
oev(5) = raan;
oev(6) = tanom;



