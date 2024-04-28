clc
clear
close all


% Parameters
numParticles = 100;        % Number of particles
dt = 0.01;                 % Time step
h = 1.0;                   % Smoothing length
rho0 = 1000;               % Reference density
k = 1;                     % Bulk modulus
mu = 1;                    % Viscosity coefficient
gravity = [0, -9.81];      % Gravity vector

% Initialize particle positions and velocities
particles.position = rand(numParticles, 2) * 10;  % Random positions within a 10x10 domain
particles.velocity = zeros(numParticles, 2);

% Main simulation loop
numSteps = 1000;
for step = 1:numSteps
    % Compute density and pressure
    particles.density = computeDensity(particles.position, h);
    particles.pressure = k * (particles.density - rho0);
    
    % Compute forces
    forces = computeForces(particles, h, gravity, mu);
    
    % Update velocities and positions
    particles.velocity = particles.velocity + (forces ./ particles.density) * dt;
    particles.position = particles.position + particles.velocity * dt;
    
    % Plot particles
    scatter(particles.position(:,1), particles.position(:,2), 'b.');
    axis([0 10 0 10]);
    title(['SPH Simulation Step: ', num2str(step)]);
    xlabel('X');
    ylabel('Y');
    drawnow;
end

% Function to compute density using a smoothing kernel
function density = computeDensity(position, h)
    numParticles = size(position, 1);
    density = zeros(numParticles, 1);
    for i = 1:numParticles
        r = position - position(i,:);
        distSq = sum(r.^2, 2);
        W = (1/pi/h^2) * exp(-distSq/(h^2));
        density(i) = sum(W);
    end
end

% Function to compute forces (pressure, viscosity, gravity)
function forces = computeForces(particles, h, gravity, mu)
    numParticles = size(particles.position, 1);
    forces = zeros(numParticles, 2);
    for i = 1:numParticles
        r = particles.position - particles.position(i,:);
        distSq = sum(r.^2, 2);
        W = (1/pi/h^2) * exp(-distSq/(h^2));
        
        % Pressure force
        pressureForce = -particles.pressure .* W ./ particles.density;
        
        % Viscosity force
        viscosityForce = mu * sum((particles.velocity - particles.velocity(i,:)) .* W, 1) ./ particles.density(i);
        
        % Gravity force
        gravityForce = gravity * particles.density(i);
        
        % Total force
        forces(i,:) = sum([pressureForce; viscosityForce; gravityForce], 1);
    end
end