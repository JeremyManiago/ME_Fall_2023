clc
clear
close all
format long

set(0,'DefaultFigureWindowStyle','docked')
hold off

%% Test plotting methods using numerical values and built in "streamline" function
% Define grid
[x, y] = meshgrid(-5:0.25:5, -5:0.25:5);

% Define uniform flow parameters
uni_vel = 1;    % magnitude of uniform flow, V_inf
uni_thet = deg2rad(0);   % angle of uniform flow (input degrees)

% Calculate velocity components for uniform flow
u_uni = uni_vel * cos(uni_thet);
v_uni = uni_vel * sin(uni_thet);

% Define source flow parameters
src_strength = 1;   % strength of the source
src_x = -2;          % x-coordinate of the source
src_y = 0;          % y-coordinate of the source


% Calculate velocity components for source flow
u_src = src_strength .* (x - src_x) ./ ((x - src_x).^2 + (y - src_y).^2);
v_src = src_strength .* (y - src_y) ./ ((x - src_x).^2 + (y - src_y).^2);

% Define sink flow parameters
sink_strength = -1;   % strength of the sink
sink_x = 2;          % x-coordinate of the sink
sink_y = 0;          % y-coordinate of the sink

% Calculate velocity components for source flow
u_sink = sink_strength .* (x - sink_x) ./ ((x - sink_x).^2 + (y - sink_y).^2);
v_sink = sink_strength .* (y - sink_y) ./ ((x - sink_x).^2 + (y - sink_y).^2);

% Total velocity components, based on Laplace'S Equation
% u = u_uni  + u_src + u_sink;
% v = v_uni  + v_src + v_sink;
u = u_uni
v = v_uni

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
r_stag = sink_strength/(2*pi*uni_vel)
thet_Stag = pi
x_stag = r_stag * cos(thet_Stag)
y_stag = r_stag * sin(thet_Stag)

% Plot streamlines
% figure
% plot(x_stag, y_stag, Marker=".", MarkerSize=20)
[startX,startY] = meshgrid(-5, -5:0.25:5);
streamline(x,y,u,v,startX,startY)


%% Symbolic Variables
%{
Now use symbolic variables, allowing for indefinite integration of 
velocity components to compute stream and potential functions
%}

clear
hold off
syms v_inf thet u v x y 
% v_inf = 1;          % velocity magnitude of uniform flow
% thet = deg2rad(0);  % theta angle of uniform flow w.r.t. horizontal

u = v_inf * cos(thet);
v = v_inf * sin(thet);

y = int(v/u, x)
y = subs(y, [v_inf,thet], [1,0])
% y = subs(y, x, -5:1:5)
c = -5:1:5
y = y + c

% partial_stream_y = u
% partial_stream_x = -v
% 
% stream_y = int(partial_stream_y, y)
% stream_x = int(partial_stream_x, x)
% stream_uni = stream_x + stream_y
% 
% stream_uni = subs(stream_uni, [v_inf,thet], [1,0])
% xn = subs(x, x, -5:1:5)
% yn = subs(y, y, -5:1:5)
% stream_uni = subs(stream_uni, [x,y], [xn,yn])

figure
% plot(src_x, src_y, Marker=".", MarkerSize=20)
hold on
fplot(y,[-5 5], Color='b')
xlabel('x');
ylabel('y');
title('Flow Visualization: Uniform and Source Flow');
axis equal
grid
