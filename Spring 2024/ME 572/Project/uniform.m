function [u, v] = uniform(x, y, vel, thet)
    % Calculate velocity components for uniform flow
    u = (vel * cos(thet)) .* ones(size(x));
    v = (vel * sin(thet)) .* ones(size(y));
end