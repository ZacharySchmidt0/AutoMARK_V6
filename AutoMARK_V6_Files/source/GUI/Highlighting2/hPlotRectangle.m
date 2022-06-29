function createdLines = hPlotRectangle(iHandler, colour, startPosition, endPosition)
%HPLOTARROW Plots a rectangle on the sheet

createdLines = gobjects(1); % Rectangles are given by 1 rectangle

% Extract the two points
x0 = startPosition(1);
y0 = startPosition(2);
x1 = endPosition(1);
y1 = endPosition(2);

% Translate them
[x0, y0] = iHandler.sheetToAxis(x0, y0);
[x1, y1] = iHandler.sheetToAxis(x1, y1);


createdLines(1) = rectangle(iHandler.onAxis, 'Position', [min(x0, x1), min(y0, y1), abs(x0-x1), abs(y0-y1)], 'EdgeColor', colour./255, 'LineWidth', 1.5);
end

