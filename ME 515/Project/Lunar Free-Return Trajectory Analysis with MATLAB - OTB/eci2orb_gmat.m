function oev = eci2orb_gmat (mu, r, v)

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

% reference: GMAT math spec, chapter 3 (Calculation Objects)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

twopi = 2.0 * pi;

% position and velocity magnitudes

rmag = norm(r);

vmag = norm(v);

% position unit vector

rhat = r / rmag;

% angular momentum vector

hvec = cross(r, v);

% angulat momentum magnitude

hmag = norm(hvec);

% specific orbital energy (km^2/sec^2)

energy = 0.5 * vmag^2 - mu / rmag;

% semimajor axis (kilometers)

sma = -mu / (2.0 * energy);

% nodal vector and magnitude

nvec = cross([0 0 1], hvec);

nmag = norm(nvec);

% nodal unit vector

nhat = nvec / nmag;

% eccentricity vector

rdotv = dot(r, v);

eccv = ((vmag * vmag - mu / rmag) * r - rdotv * v) / mu;

% eccentricity magnitude (non-dimensional)

eccm = norm(eccv);

% eccentricity unit vector

ehat = eccv / eccm;

% orbital inclination (radians)

inc = acos(hvec(3) / hmag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% special case 1: non-circular, inclined orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (eccm >= 1.0e-10)
    
    if ((inc >= 1.0e-10) && (inc ~= pi))
        
        % fprintf('\n\nspecial case 1: non-circular, inclined orbit\n');
        
        raan = acos(nhat(1));
        
        if (nhat(2) < 0.0)
            
            raan = twopi - raan;
            
        end
        
        argper = acos(dot(nhat, ehat));
        
        if (ehat(3) < 0.0)
            
            argper = twopi - argper;
            
        end
        
        tanom = acos(dot(ehat, rhat));
        
        if (rdotv < 0.0)
            
            tanom = twopi - tanom;
            
        end
        
        oev = [sma eccm inc argper raan tanom];
        
        return;
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% special case 2: non-circular, equatorial orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((eccm >= 1.0d-10) && ((inc < 1.0e-10) || (abs(inc - pi) < 1.0e-10)))
    
    % fprintf('\n\nspecial case 2: non-circular, equatorial orbit\n');
    
    raan = 0.0;
    
    argper = acos(ehat(1));
    
    if (ehat(2) < 0.0)
        
        argper = twopi - argper;
        
    end
    
    tanom = vangle(ehat, rhat);
    
%     tanom = acos(dot(ehat, rhat));
%     
%     if (rdotv < 0.0)
%         
%         tanom = twopi - tanom;
%         
%     end
    
    oev = [sma eccm inc argper raan tanom];
    
    return;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% special case 3: circular, inclined orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((eccm < 1.0e-10) && (inc >= 1.0e-10) || (abs(inc - pi) >= 1.0e-10))
    
    % fprintf('\n\nspecial case 3: circular, inclined orbit\n');
    
    raan = acos(nvec(1) / nmag);
    
    if (nhat(2) < 0.0)
        
        raan = twopi - raan;
        
    end
    
    argper = 0.0;
    
    tanom = acos(dot(ehat, rhat));
    
    if (rdotv < 0.0)
        
        tanom = twopi - tanom;
        
    end
    
    oev = [sma eccm inc argper raan tanom];
    
    return;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% special case 4: circular, equatorial orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((eccm < 1.0d-10) && ((inc < 1.0e-10) || (abs(inc - pi) < 1.0e-10)))
    
    % fprintf('\n\nspecial case 4: circular, equatorial orbit\n');
    
    raan = 0.0;
    
    argper = 0.0;
    
    tanom = acos(dot(ehat, rhat));
    
    if (rdotv < 0.0)
        
        tanom = twopi - tanom;
        
    end
    
    oev = [sma eccm inc argper raan tanom];
    
    return;
    
end





