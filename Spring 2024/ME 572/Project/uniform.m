function [u, v] = uniform(x, y, vel, thet)
    % Calculate velocity components for uniform flow
    u = (vel * cos(thet));
    v = (vel * sin(thet));
end