clc
clear
close all
format long

set(0,'DefaultFigureWindowStyle','docked')
hold off

% Define grid
[x, y] = meshgrid(-5:0.25:5, -5:0.25:5);

% Define Uniform params
vel_inf = 1
thet = deg2rad(0)

% Define Source or Sink params
srk = [-1, 0, pi; 1, 0, -pi; 0, 2, -pi]
amt = size(srk, 1) % total amount of source and sink flows
u_srk = 0
v_srk = 0

% Call flow functions
[u_uni, v_uni] = uniform(x, y, vel_inf, thet)
for i = 1 : amt
    [u, v] = source_sink(x, y, srk(i,1), srk(i,2), srk(i,3))
    u_srk = u_srk + u
    v_srk = v_srk + v
end

% Total velocity components, based on Laplace'S Equation
u = u_uni + u_srk
v = v_uni + v_srk

% Plot velocity flow field + components
hold on
for i = 1 : amt
    plot(srk(i,1), srk(i,2), Marker=".", MarkerSize=20)
end
quiver(x, y, u, v, Color='r');
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

% plot(x_stag, y_stag, Marker="x", MarkerSize=10)
% Streamlines
[startX,startY] = meshgrid(-5, -5:0.25:5);
sl = streamline(x,y,u,v,startX,startY)
% figure
anim_lines(sl, srk, amt)
