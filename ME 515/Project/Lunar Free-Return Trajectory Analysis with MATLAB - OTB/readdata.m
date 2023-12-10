function [fid, radius_leo, vlc_leo, radius_lmo, theta_pe, deltav_tli] = readdata(filename)

% read simulation definition and data

% version for free_return.m

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu_earth mu_moon radius_earth radius_moon 

global distance_e2m radius_soi vlc_moon omega_moon

% open data file

fid = fopen(filename, 'r');

% check for file open error

if (fid == -1)
    
    clc; home;
    
    fprintf('\n\n error: cannot find this file!!');
    
    pause;
    
    return;
    
end

% read 34 lines of data

for i = 1:1:34
    
    cline = fgetl(fid);
    
    switch i
        
        case 7
            
            % earth gravitational constant (kilometers^3/second^2)
            
            mu_earth = str2double(cline);
            
        case 10
            
            % moon gravitational constant (kilometers^3/second^2)
            
            mu_moon = str2double(cline);
            
        case 13
            
            % radius of the earth (kilometers)
            
            radius_earth = str2double(cline);
            
        case 16
            
            % radius of the moon (kilometers)
            
            radius_moon = str2double(cline);
            
        case 19
            
            % distance from the earth to the moon (kilometers)
            
            distance_e2m = str2double(cline);
         
        case 22

            % lunar sphere-of-influence radius (kilometers)

            radius_soi = str2double(cline);

        case 25
            
            % altitude of circular earth park orbit (kilometers)
            
            hleo = str2double(cline);
            
        case 28
            
            % altitude of circular lunar orbit (kilometers)
            
            hlmo = str2double(cline);
            
        case 31
            
            % initial guess for geocentric angular location of the tli delta-v (degrees)
            
            theta_pe = str2double(cline);
            
        case 34
            
            % initial guess for tli delta-v magnitude (kilometers/second)
            
            deltav_tli = str2double(cline);           
    end
    
end

fclose(fid);

% compute angular orbital rate of the moon (radians/second)

omega_moon = sqrt(mu_earth / distance_e2m^3);

% local circular velocity of the moon (kilometers/second)

vlc_moon = sqrt(mu_earth / distance_e2m);

% radius of the circular earth park orbit (kilometers)

radius_leo = radius_earth + hleo;

% local circular velocity of the earth park orbit (kilometers/second)

vlc_leo = sqrt(mu_earth / radius_leo);

% radius of the circular lunar arrival orbit (kilometers)

radius_lmo = radius_moon + hlmo;
