function retArrows = plotArrow(startPosition, endPosition, tipSize, colour, linewidth, ax)
%PLOTARROW 

if nargin < 4
    colour = [0, 0, 0];
end

if nargin < 5
    linewidth = 2;
end

if nargin < 6
    ax = gca();
end

retArrows = [];

% Main line
primativeLine(startPosition, endPosition)

% Vector which goes from start to end
v = endPosition - startPosition;

% Normalized to tipSize
nv = v*tipSize/norm(v);

% Tip angle in degrees
tipAngle = 20;

computedAngle = deg2rad(180 - tipAngle);
tipRotationVector = transpose([cos(computedAngle), -sin(computedAngle); sin(computedAngle), cos(computedAngle)]);

% Top Line ----\
primativeLine(endPosition, endPosition + nv*tipRotationVector);
% Bottom Line ----/
primativeLine(endPosition, endPosition + nv/tipRotationVector);

function primativeLine(startPosition, endPosition)
%PRIMATIVELINE Line in matlab has annoying syntax in regards to vector math
% this function is nicer in that respect.

newLine = line(ax, 'XData', [startPosition(1), endPosition(1)], 'YData', [startPosition(2), endPosition(2)], 'Color', colour, 'LineWidth', linewidth);
retArrows = [retArrows newLine];
end
end

