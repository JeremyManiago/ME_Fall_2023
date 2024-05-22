function [u,v] = source_sink(x, y, src_x, src_y, strength)
    % Calculate velocity components for source/sink flow
    u = (strength/(2*pi)) .* (x - src_x) ./ ((x - src_x).^2 + (y - src_y).^2);
    v = (strength/(2*pi)) .* (y - src_y) ./ ((x - src_x).^2 + (y - src_y).^2);
end