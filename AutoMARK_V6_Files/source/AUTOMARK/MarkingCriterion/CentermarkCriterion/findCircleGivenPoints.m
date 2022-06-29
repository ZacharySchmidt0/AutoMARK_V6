function [center , radius] = findCircleGivenPoints(points)
%FINDCIRCLEGIVENPOINTS Given some points, [x, y] it finds and returns the
% origin and radius of that circle. 
% Must be at least 3 points. For overdetermined it solves via least
% squares.

% (x-a)^2 + (y-b)^2 = r^2
% x^2 -2ax + a^2 + y^2 -2by + b^2 = r^2
% x^2 + y^2 = (2x)*a + (2y)*b + (1)*(r^2 - a^2 - b^2)
% Now Solve as
% b = Ax

b = sum(points.^2, 2); % b = (x^2 + y^2)

A = [2 * points, ones(size(points, 1), 1)]; % A = [2x 2y 1]
At = transpose(A);

x = (At * A) \ At * b;

center = [x(1), x(2)];

radius = sqrt(x(3) + x(1)^2 + x(2)^2);
end

