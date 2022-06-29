function  plotCross(position, tipsize, colour, linewidth, ax)
%PLOTCROSS

if nargin < 4
    colour = [0, 0, 0];
end

if nargin < 5
    linewidth = 2;
end

if nargin < 6
    ax = gca();
end


leftup = [-tipsize/2, tipsize/2];
leftdown = [-tipsize/2, -tipsize/2];
rightup = [tipsize/2, tipsize/2];
rightdown = [tipsize/2, -tipsize/2];

% Forward diagonal
primativeLine(position + leftup, position + rightdown);
% Backwards diagonal
primativeLine(position + leftdown, position + rightup);


function primativeLine(startPosition, endPosition)
%PRIMATIVELINE Line in matlab has annoying syntax in regards to vector math
% this function is nicer in that respect.
line(ax, 'XData', [startPosition(1), endPosition(1)], 'YData', [startPosition(2), endPosition(2)], 'Color', colour, 'LineWidth', linewidth);
end
end
