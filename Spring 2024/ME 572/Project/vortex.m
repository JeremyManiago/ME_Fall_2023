function [u,v] = vortex(x, y, vtx_x, vtx_y, circ)
    % Calculate velocity components for vortex flow
    u = (circ/(2*pi)) .* (y - vtx_x) ./ ((x - vtx_x).^2 + (y - vtx_y).^2);
    v = -(circ/(2*pi)) .* (x - vtx_y) ./ ((x - vtx_x).^2 + (y - vtx_y).^2);
end