function mPlotCircle(iHandler, colour, startPosition, radius)
%HPLOTARROW Plots a cross on the sheet

lineWidth = 5;
[x0, y0] = iHandler.sheetToImage(startPosition(:,1), startPosition(:,2));

circleData = [x0 y0];

circleData(:, 3) = radius;

iHandler.pixelData = insertShape(iHandler.pixelData, 'Circle', circleData, 'Color', colour, 'LineWidth', lineWidth);
end
