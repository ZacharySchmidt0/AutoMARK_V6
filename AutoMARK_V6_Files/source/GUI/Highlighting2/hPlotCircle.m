function createdLines = hPlotCircle(iHandler, colour,  startPosition, radius)
%HPLOTARROW Plots a rectangle on the sheet

createdLines = gobjects(1); % Circles are just a circle

% Extract the two points
[x0, y0] = iHandler.sheetToAxis(startPosition(1), startPosition(2));

% Radius is given in coordinates on the drawing, so you need to figure it
% out.

[x1, y1] = iHandler.sheetToAxis(0, 0);
[x2, y2] = iHandler.sheetToAxis(0, radius);

trueRadius = norm([x1,y1] - [x2,y2]);

%createdLines(1) = viscircles(iHandler.onAxis, [x0, y0], trueRadius, 'Color', colour./255);

% viscircles does not support uifigure axis, try a rectangle with infinite curvature instead

createdLines(1) = rectangle(iHandler.onAxis, 'Position', [x0 - trueRadius, y0 - trueRadius, 2*trueRadius, 2*trueRadius], 'Curvature', [1, 1], 'EdgeColor', colour./255, 'LineWidth', 1.5);
end

