function createdLines = hPlotLine(iHandler, colour, startPosition, endPostion)
%HPLOTARROW Plots a line on the sheet, barebones and very simplistic!

% CONSTANTS
lineWidth = 1.5;


createdLines = gobjects(1); % Lines are made of 1 lines.

% Grab the four coordinates!
[x0, y0] = iHandler.sheetToAxis(startPosition(1), startPosition(2));
[x1, y1] = iHandler.sheetToAxis(endPostion(1), endPostion(2));

createdLines(1) = line(iHandler.onAxis, 'XData', [x0, x1], 'YData', [y0, y1], 'Color', colour./255, 'LineWidth', lineWidth);
end

