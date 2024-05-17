clc
clear
close all
format long

set(0,'DefaultFigureWindowStyle','docked')
hold off

% Define grid
[x, y] = meshgrid(-5:0.25:5, -5:0.25:5);
[u_uni, v_uni] = uniform(x, y, 1, deg2rad(0))
[u, v] = source_sink(x, y, 0, 0, 1)
u = u_uni + u
v = v_uni + v

% Total velocity components, based on Laplace'S Equation

% Plot velocity flow field + components
% plot(src_x, src_y, Marker=".", MarkerSize=20)
hold on
% plot(sink_x, sink_y, Marker=".", MarkerSize=20)
quiver(x, y, u, v);
xlabel('x');
ylabel('y');
% title('Flow Visualization: Uniform and Sink Flow');
% title('Flow Visualization: Uniform and Source Flow');
title('Flow Visualization: Rankine Oval');
axis equal
grid

% Stagnation (for source or sink + uni only)
r_stag = 1./(2*pi*u_uni)
thet_Stag = pi
x_stag = r_stag * cos(thet_Stag)
y_stag = r_stag * sin(thet_Stag)

plot(x_stag, y_stag, Marker=".", MarkerSize=20)
% Streamlines
[startX,startY] = meshgrid(-5, -5:0.25:5);
streamline(x,y,u,v,startX,startY)