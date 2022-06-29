function createdLines = hPlotArrow(iHandler, colour, startPosition, endPosition)
%HPLOTARROW Plots an Arrow on the sheet

% CONSTANTS

tipSize = 0.025; % tipSize is given in fraction of sheet width
rotationAngle = 30; % Degrees

createdLines = gobjects(1,3); % Arrows are made of 3 lines.

arrowtipsize = tipSize * iHandler.sheet_width;


arrowVector = (endPosition - startPosition);
arrowVector = arrowVector / norm(arrowVector) * arrowtipsize;

rotationAngle = deg2rad(rotationAngle);
% -1 since its backwards, also its transposed as its a back multiplication
rotationMatrix = -1 * [cos(rotationAngle), sin(rotationAngle); -sin(rotationAngle), cos(rotationAngle) ]; 



createdLines(1) = hPlotLine(iHandler, colour, startPosition, endPosition);
createdLines(2) = hPlotLine(iHandler, colour, endPosition, endPosition + arrowVector * rotationMatrix);
createdLines(3) = hPlotLine(iHandler, colour, endPosition, endPosition + arrowVector / rotationMatrix);
end

