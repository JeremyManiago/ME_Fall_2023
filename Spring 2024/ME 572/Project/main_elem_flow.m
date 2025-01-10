clc
clear
close all
format long

set(0,'DefaultFigureWindowStyle','docked')
hold off

% Define grid
[x, y] = meshgrid(-5:0.25:5, -5:0.25:5);    % 41 x 41 grid 

% Define Uniform params
vel_inf = 1;        % uniform flow velocity
thet = deg2rad(0);  % uniform flow angle w.r.t. horizontal

% Define Source or Sink params 
srk = [-0.25, 0, pi; 1, 0, -pi; 0, 2, -pi] % [xloc, yloc, strength]
amt_srk = size(srk, 1) % total amount of source and sink flows
u_srk = 0;  % initialize total source + sink velocity components
v_srk = 0;

% Define Vortex params
vtx = [0, -2, 1/2]
amt_vtx = size(vtx, 1)
u_vtx = 0;
v_vtx = 0;

% Call flow functions
[u_uni, v_uni] = uniform(x, y, vel_inf, thet)

for i = 1 : amt_srk
    [u, v] = source_sink(x, y, srk(i,1), srk(i,2), srk(i,3))
    u_srk = u_srk + u;
    v_srk = v_srk + v;
end

for i = 1 : amt_vtx
    [u, v] = vortex(x, y, vtx(i,1), vtx(i,2), vtx(i,3))
    u_vtx = u_vtx + u;
    v_vtx = v_vtx + v;
end

% Total velocity components, based on the Laplace Equation
u = u_uni + u_srk + u_vtx;
v = v_uni + v_srk + v_vtx;
u(isnan(u)) = 0;                    % replace NaN values with zero
u(isinf(u)) = max(u(~isinf(u)));    % replace Inf values with the maximum value not including Inf
v(isnan(v)) = 0;
v(isinf(v)) = max(v(~isinf(v)));

% Plot velocity flow field + components
hold on
plot([srk(:,1)], [srk(:,2)], Marker=".", MarkerSize=20, LineStyle="none")
plot([vtx(:,1)], [vtx(:,2)], Marker=".", MarkerSize=20, LineStyle="none")


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
% for i = 1 : amt_srk
%     if srk(i,3) < 0
%         [srcX,srcY] = meshgrid(srk(i,1), srk(i,2));
%         streamline(x,y,u,v,srcX,srcY)
%     end
% end
% figure

anim_lines(sl, srk, vtx, false)  % call animation function
