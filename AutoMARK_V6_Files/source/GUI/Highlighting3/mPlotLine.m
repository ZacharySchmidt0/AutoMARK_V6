function mPlotLine(iHandler, colour, startPosition, endPostion)
%HPLOTARROW Plots a line on the sheet, barebones and very simplistic!

% CONSTANTS
lineWidth = 5;

% Grab the four coordinates!
[x0, y0] = iHandler.sheetToImage(startPosition(:,1), startPosition(:,2));
[x1, y1] = iHandler.sheetToImage(endPostion(:,1), endPostion(:,2));

iHandler.pixelData = insertShape(iHandler.pixelData, 'Line', [x0 y0 x1 y1], 'Color', colour, 'LineWidth', lineWidth);
end

