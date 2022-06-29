function mPlotRectangle(iHandler, colour, startPosition, endPosition)
%HPLOTARROW Plots a rectangle on the sheet


lineWidth = 5;

% Extract the two points (or more since its vectorized)
[x1, y1] = iHandler.sheetToImage(startPosition(:,1), startPosition(:,2));
[x2, y2] = iHandler.sheetToImage(endPosition(:,1), endPosition(:,2));

% Corner
x = min(x1, x2);
y = min(y1, y2);

% Width
w = abs(x1-x2);
h = abs(y1-y2);

iHandler.pixelData = insertShape(iHandler.pixelData, 'Rectangle', [x y w h], 'LineWidth', lineWidth , 'Color', colour);
end

