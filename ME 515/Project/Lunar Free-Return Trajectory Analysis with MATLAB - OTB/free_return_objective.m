function f = free_return_objective(x)

% lunar free return objective function

% input

%  x(1) = current update to TLI departure angle
%  x(2) = current update to TLI deltav

% output

%  f = objective function (tli delta-v magnitude)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% objective function (tli deltav magnitude, kilometers/second)

f = x(2);

