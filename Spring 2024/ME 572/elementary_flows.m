clc
clear
close all

format long

set(0,'DefaultFigureWindowStyle','docked')
figure;

% Define grid
[x, y] = meshgrid(-5:0.5:5, -5:0.5:5);

% Define uniform flow parameters
uniform_velocity = 1; % magnitude of uniform flow
uniform_angle = 0;   % angle of uniform flow (in radians)

% Define source flow parameters
source_strength = 1; % strength of the source
source_x = 0;  % x-coordinate of the source
source_y = 0;  % y-coordinate of the source

% Calculate velocity components for uniform flow
u_uniform = uniform_velocity * cos(uniform_angle);
v_uniform = uniform_velocity * sin(uniform_angle);

% Calculate velocity components for source flow
u_source = source_strength .* (x - source_x) ./ ((x - source_x).^2 + (y - source_y).^2);
v_source = source_strength .* (y - source_y) ./ ((x - source_x).^2 + (y - source_y).^2);

% Total velocity components
u = u_uniform + u_source;
v = v_uniform + v_source;

% Plot flow field + components
plot(source_x, source_y, Marker=".", MarkerSize=20)
hold on
quiver(x, y, u, v);
xlabel('x');
ylabel('y');
title('Flow Visualization: Uniform and Source Flow');
axis equal
grid