% free_return_otb          December 11, 2019

% lunar free return trajectory analysis

% Optimization Toolbox

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all
set(0,'DefaultFigureWindowStyle','docked')

global mu_earth mu_moon radius_earth radius_moon distance_e2m omega_moon

global radius_soi radius_leo vlc_leo radius_lmo tevent yevent

global rm2sc vm2sc rrel vrel

% angular conversion factors

dtr = pi / 180.0;

rtd = 180.0 / pi;

clc; home;

fprintf('\nLunar free return trajectory analysis');
fprintf('\n=====================================\n');

% request user-defined input data file

[filename, pathname] = uigetfile('*.in', 'please select an input data file');

% read contents of data file

[fid, radius_leo, vlc_leo, radius_lmo, theta_tli, deltav_tli] = readdata(filename);

%%%%%%%%%%%%%%%%%%
% begin simulation
%%%%%%%%%%%%%%%%%%

fprintf('\nplease wait, solving optimization problem ...\n');

% initial guesses

xg(1) = dtr * theta_tli;

xg(2) = deltav_tli;

% lower and upper bounds for TLI theta (radians)

xlwr(1) = xg(1) - 10.0 * dtr;

xupr(1) = xg(1) + 10.0 * dtr;

% lower and upper bounds for TLI delta-v (meters/second)

xlwr(2) = xg(2) - 0.100;

xupr(2) = xg(2) + 0.100;

% solve trajectory optimization problem

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point', ...
    'MaxFunctionEvaluations', 5000, 'FiniteDifferenceType', 'forward');

[xsol, fval] = fmincon('free_return_objective', xg, [], [], [], [], ...
    xlwr, xupr, 'free_return_constraints', options);
    
% extract solution

theta_tli = xsol(1);

deltav_tli = xsol(2);

% geocentric position vector of the moon at closest approach (kilometers)

theta_moon = omega_moon * tevent;

re2m_ca(1) = distance_e2m * cos(theta_moon);

re2m_ca(2) = distance_e2m * sin(theta_moon);

% compute geocentric position and velocity vectors at TLI

ri(1) = radius_leo * cos(theta_tli);

ri(2) = radius_leo * sin(theta_tli);

ri(3) = 0.0;

vpe = vlc_leo + deltav_tli;

vi(1) = -vpe * sin(theta_tli);

vi(2) = vpe * cos(theta_tli);

vi(3) = 0.0;

oev_tli = eci2orb_gooding (mu_earth, ri, vi);

fprintf('\nTLI delta-v                %14.8f meters/second\n', 1000.0 * deltav_tli);

fprintf('\none way time of flight     %14.8f hours\n', tevent / 3600.0);
fprintf('                           %14.8f days\n', tevent / 86400.0);

fprintf('\nround trip time of flight  %14.8f hours\n', 2.0 * tevent / 3600.0);
fprintf('                           %14.8f days\n', 2.0 * tevent / 86400.0);

fprintf('\ngeocentric orbital elements and state vector at Earth departure');
fprintf('\n---------------------------------------------------------------\n');

oeprint1(mu_earth, oev_tli, 2);

svprint(ri, vi);

fprintf('altitude                %14.8f kilometers\n', norm(ri) - radius_earth);

rdotv_tli = dot(ri, vi) / (norm(ri) * norm(vi));

fprintf('\nflight path angle       %14.8f degrees\n', rtd * asin(rdotv_tli));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute selenocentric conditions at lunar flyby
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rm2sc(3) = 0.0;

vm2sc(3) = 0.0;

fprintf('\nselenocentric orbital elements and state vector at lunar flyby');
fprintf('\n--------------------------------------------------------------\n');

oev_sel = eci2orb_gooding(mu_moon, rm2sc, vm2sc);

oeprint1(mu_moon, oev_sel, 1);

svprint(rm2sc, vm2sc);

rdotv = dot(rm2sc, vm2sc) / (norm(rm2sc) * norm(vm2sc));

fprintf('altitude                %14.8f kilometers\n', norm(rm2sc) - radius_moon);

fprintf('\nflight path angle       %14.8f degrees\n', rtd * asin(rdotv));

fprintf('\nmission time at flyby   %14.8f hours\n', tevent / 3600.0);
fprintf('                        %14.8f days\n', tevent / 86400.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% propagate system of first-order differential equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ttof = 2.0 * tevent;

r(1) = radius_leo * cos(theta_tli);

r(2) = radius_leo * sin(theta_tli);

vpe = vlc_leo + deltav_tli;

v(1) = -vpe * sin(theta_tli);

v(2) = vpe * cos(theta_tli);

options = odeset('RelTol', 1.0e-10, 'AbsTol', 1.0e-10);

[tn, xn] = ode45('free_return_eqm', [0.0 ttof], [r v], options);

% extract transfer orbit geocentric state vector

re2sc(:, 1) = xn(:, 1);

re2sc(:, 2) = xn(:, 2);

ve2sc(:, 1) = xn(:, 3);

ve2sc(:, 2) = xn(:, 4);

% create geocentric position vector of the moon (kilometers)

theta_moon = omega_moon * tn;

re2m_x = distance_e2m * cos(theta_moon);

re2m_y = distance_e2m * sin(theta_moon);

% create geocentric position vector of the moon every 12 hours (kilometers)

npts = fix(tn(end) / 43200.0);

theta_moon = 0.0;

re2m_x12 = zeros(npts, 1);

re2m_y12 = zeros(npts, 1);

for i = 1:1:npts
    
    theta_moon = theta_moon + omega_moon * 43200.0;
    
    re2m_x12(i) = distance_e2m * cos(theta_moon);
    
    re2m_y12(i) = distance_e2m * sin(theta_moon);
    
end

% create transfer trajectory position vector in rotating coordinates

stn = size(tn);

ntn = stn(1, 1);

re2sc_rx = zeros(ntn, 1);

re2sc_ry = zeros(ntn, 1);

re2sc_rz = zeros(ntn, 1);

for i = 1:1:ntn
    
    re2sc_rx(i) = re2sc(i, 1) * cos(omega_moon * tn(i)) ...
        + re2sc(i, 2) * sin(omega_moon * tn(i));
    
    re2sc_ry(i) = -re2sc(i, 1) * sin(omega_moon * tn(i)) ...
        + re2sc(i, 2) * cos(omega_moon * tn(i));
    
    re2sc_rz(i) = 0.0;
    
end

% create selenocentric position vector in inertial coordinates

rm2sc_x = zeros(ntn, 1);

rm2sc_y = zeros(ntn, 1);

rm2sc_z = zeros(ntn, 1);

for i = 1:1:ntn
    
    rm2sc_x(i) = re2sc(i, 1) - re2m_x(i);
    
    rm2sc_y(i) = re2sc(i, 2) - re2m_y(i);
    
    rm2sc_z(i) = 0.0;
    
end

fclose('all');

% geocentric state vector and orbital elements at Earth orbit arrival

r(1) = re2sc(end, 1);

r(2) = re2sc(end, 2);

r(3) = 0.0;

v(1) = ve2sc(end, 1);

v(2) = ve2sc(end, 2);

v(3) = 0.0;

oev_eoi = eci2orb_gooding (mu_earth, r, v);

fprintf('\ngeocentric orbital elements and state vector at Earth arrival');
fprintf('\n-------------------------------------------------------------\n');

oeprint1(mu_earth, oev_eoi, 2);

svprint(r, v);

fprintf('altitude                %14.8f kilometers\n', norm(r) - radius_earth);

rdotv_eoi = dot(r, v) / (norm(r) * norm(v));

fprintf('\nflight path angle       %14.8f degrees\n', rtd * asin(rdotv_eoi));

vlc = sqrt(mu_earth / norm(r));

deltav = norm(v) - vlc;

fprintf('\ncircularization deltav  %14.8f meters/second\n', 1000.0 * deltav);

fprintf('\nimage trajectory mission constraints at lunar closest approach')
fprintf('\n--------------------------------------------------------------\n');

fprintf('\ny-component of relative position vector      %14.8f meters\n', 1000.0 * rrel(2));

fprintf('\nx-component of relative velocity vector      %14.8f meters/second\n', 1000.0 * vrel(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute inertial mission constraints at lunar closest approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% unit vector from earth to the moon at close approach

re2m_ca(3) = 0.0;

ue2m_ca = re2m_ca / norm(re2m_ca);

% unit vector from earth to the third body at close approach

re2sc_ca(1) = yevent(1);

re2sc_ca(2) = yevent(2);

re2sc_ca(3) = 0.0;

ure2sc_ca = re2sc_ca / norm(re2sc_ca);

dotprod1 = dot(ue2m_ca, ure2sc_ca);

ve2sc_ca(1) = yevent(3);

ve2sc_ca(2) = yevent(4);

ve2sc_ca(3) = 0.0;

uve2sc_ca = ve2sc_ca / norm(ve2sc_ca);

dotprod2 = dot(ure2sc_ca, uve2sc_ca);

fprintf('\nmoon-third body geocentric separation angle  %14.8f degrees\n', rtd * real(acos(dotprod1)));

fprintf('\ngeocentric inertial flight path angle        %14.8f degrees\n\n', rtd * real(asin(dotprod2)));

while (1)
    
    fprintf('\nwould you like to display trajectory graphics (y = yes, n = no)\n');
    
    slct = lower(input('? ', 's'));
    
    if (slct == 'y' || slct == 'n')
        
        break;
        
    end
    
end

fprintf('\n\n');

if (slct == 'y')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lunar free return trajectory graphics in inertial frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(1);
    
    hold on;
    
    axis([-5.0 60.0 -5.0 60.0]);
    
    % create array of polar angles (radians)
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot Earth
    
    plot(sin(t), cos(t), 'Color', 'g');
    
    % plot circular earth orbit
    
    rratio = radius_leo / radius_earth;
    
    plot(rratio * sin(t), rratio * cos(t), 'Color', 'g');
    
    % plot geocentric transfer trajectory
    
    plot(re2sc(:, 1) / radius_earth, re2sc(:, 2) / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    % plot geocentric orbit of the moon
    
    plot(re2m_x / radius_earth, re2m_y / radius_earth, 'Color', 'r', 'LineWidth', 1.5);
    
    rratio = radius_moon / radius_earth;
    
    % plot moon at beginning of simulation and at flyby
    
    plot(re2m_x(1) / radius_earth + rratio * sin(t), rratio * cos(t), 'k');
    
    plot(re2m_ca(1) / radius_earth + rratio * sin(t), re2m_ca(2) ...
        / radius_earth + rratio * cos(t), 'k');
    
    % plot location of the moon every 12 hours
    
    for i = 1:1:npts
        
        plot(re2m_x12(i) / radius_earth + rratio * sin(t), re2m_y12(i) ...
            / radius_earth + rratio * cos(t), 'k');
        
    end
    
    % plot selenocentric circular orbit
    
    rratio = radius_lmo / radius_earth;
    
    plot(re2m_ca(1) / radius_earth + rratio * sin(t), ...
        re2m_ca(2) / radius_earth + rratio * cos(t), 'k');
    
    title('Lunar Free Return Trajectory (Inertial System)', 'FontSize', 18);
    
    xlabel('inertial x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('inertial y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis equal;
    
    print -depsc -tiff -r300 free_return1.eps
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % earth departure/arrival graphics in inertial frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(2);
    
    hold on;
    
    axis([-6.0 6.0 -6.0 6.0]);
    
    % create array of polar angles (radians)
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot Earth
    
    plot(sin(t), cos(t), 'Color', 'g');
    
    % plot circular earth orbit
    
    rratio = radius_leo / radius_earth;
    
    plot(rratio * sin(t), rratio * cos(t), 'Color', 'g');
    
    % plot geocentric transfer trajectory
    
    plot(re2sc(:, 1) / radius_earth, re2sc(:, 2) / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    title('Earth Departure/Arrival Trajectory (Inertial System)', 'FontSize', 18);
    
    xlabel('inertial x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('inertial y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return2.eps
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lunar flyby graphics in inertial frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(3);
    
    hold on;
    
    axis([40.0 50.0 30.0 40.0]);
    
    % plot moon at arrival
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot moon at flyby
    
    rratio = radius_moon / radius_earth;
    
    plot(re2m_ca(1) / radius_earth + rratio * sin(t), ...
        re2m_ca(2) / radius_earth + rratio * cos(t), 'k');
    
    % plot geocentric orbit of the moon
    
    plot(re2m_x / radius_earth, re2m_y / radius_earth, 'Color', 'r', 'LineWidth', 1.5);
    
    % plot selenocentric circular orbit at flyby
    
    rratio = radius_lmo / radius_earth;
    
    plot(re2m_ca(1) / radius_earth + rratio * sin(t), ...
        re2m_ca(2) / radius_earth + rratio * cos(t), 'k');
    
    % plot lunar sphere-of-influence at flyby
    
    rratio = radius_soi / radius_earth;
    
    plot(re2m_ca(1) / radius_earth + rratio * sin(t), ...
        re2m_ca(2) / radius_earth + rratio * cos(t), 'k');
    
    % plot transfer trajectory
    
    plot(re2sc(:, 1) / radius_earth, re2sc(:, 2) / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    title('Lunar Flyby Trajectory (Inertial System)', 'FontSize', 18);
    
    xlabel('inertial x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('inertial y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return3.eps
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % free return trajectory in rotating frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(4);
    
    hold on;
    
    axis([-5.0 65.0 -35.0 35.0]);
    
    % plot geocentric transfer trajectory
    
    plot(re2sc_rx / radius_earth, re2sc_ry / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot the earth
    
    plot(sin(t), cos(t), 'Color', 'g');
    
    % plot the leo
    
    rratio = radius_leo / radius_earth;
    
    plot(rratio * sin(t), rratio * cos(t), 'Color', 'g');
    
    % plot moon and lunar orbit
    
    xmoon = distance_e2m;
    
    ymoon = 0.0;
    
    rratio = radius_moon / radius_earth;
    
    plot(xmoon / radius_earth + rratio * sin(t), ymoon / radius_earth + rratio * cos(t), 'Color', 'k');
    
    rratio = radius_lmo / radius_earth;
    
    plot(xmoon / radius_earth + rratio * sin(t), ymoon / radius_earth + rratio * cos(t), 'Color', 'k');
    
    title('Lunar Free Return Trajectory (Rotating System)', 'FontSize', 18);
    
    xlabel('rotating x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('rotating y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return4.eps
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % earth depature/arrival graphics in rotating frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(5);
    
    hold on;
    
    axis([-5.0 10.0 -5.0 10.0]);
    
    % plot geocentric transfer trajectory
    
    plot(re2sc_rx / radius_earth, re2sc_ry / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot the earth
    
    plot(sin(t), cos(t), 'Color', 'g');
    
    % plot the leo
    
    rratio = radius_leo / radius_earth;
    
    plot(rratio * sin(t), rratio * cos(t), 'Color', 'g');
    
    title('Earth Departure/Arrival Trajectory (Rotating System)', 'FontSize', 18);
    
    xlabel('rotating x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('rotating y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return5.eps
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lunar flyby in rotating frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(6);
    
    hold on;
    
    axis([59.0 61.0 -1.0 1.0]);
    
    % plot flyby trajectory
    
    plot(re2sc_rx / radius_earth, re2sc_ry / radius_earth, 'Color', 'b', 'LineWidth', 1.5);
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot moon and circular lunar orbit
    
    xmoon = distance_e2m;
    
    ymoon = 0.0;
    
    rratio = radius_moon / radius_earth;
    
    plot(xmoon / radius_earth + rratio * sin(t), ymoon / radius_earth + rratio * cos(t), 'Color', 'k');
    
    rratio = radius_lmo / radius_earth;
    
    plot(xmoon / radius_earth + rratio * sin(t), ymoon / radius_earth + rratio * cos(t), 'Color', 'k');
    
    title('Lunar Flyby Trajectory (Rotating System)', 'FontSize', 18);
    
    xlabel('rotating x-coordinate (Earth radii)', 'FontSize', 14);
    
    ylabel('rotating y-coordinate (Earth radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return6.eps

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lunar flyby graphics in selenocentric inertial frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(7);
    
    hold on;
    
    axis([-40.0 40.0 -40.0 40.0]);
    
    % create angular data
    
    t = 0: pi / 50.0: 2.0 * pi;
    
    % plot moon
    
    rratio = radius_moon / radius_moon;
    
    plot(rratio * sin(t), rratio * cos(t), 'k');
    
    % plot selenocentric circular orbit at flyby
    
    rratio = radius_lmo / radius_moon;
    
    plot(rratio * sin(t), rratio * cos(t), 'k');
    
    % plot lunar sphere-of-influence
    
    rratio = radius_soi / radius_moon;
    
    plot(rratio * sin(t), rratio * cos(t), 'k');
    
    % plot selenocentric trajectory
    
    plot(rm2sc_x / radius_moon, rm2sc_y / radius_moon, 'Color', 'b', 'LineWidth', 1.5);
    
    title('Lunar Flyby Trajectory (Selenocentric Inertial System)', 'FontSize', 18);
    
    xlabel('inertial x-coordinate (lunar radii)', 'FontSize', 14);
    
    ylabel('inertial y-coordinate (lunar radii)', 'FontSize', 14);
    
    grid;
    
    axis square;
    
    print -depsc -tiff -r300 free_return7.eps

end
