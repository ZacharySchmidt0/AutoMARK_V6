function mPlotArrow(iHandler, colour, startPosition, endPosition)
%HPLOTARROW Plots an Arrow on the sheet

% CONSTANTS

lineWidth = 5;
tipSize = 0.0025; % tipSize is given in meters, so 0.005
rotationAngle = 30; % Degrees

arrowVector = (endPosition - startPosition);
arrowVector = arrowVector / norm(arrowVector) * tipSize;

if any(isnan(arrowVector))
    % Horizontal
    arrowVector = [1 0] * tipSize;
end

rotationAngle = deg2rad(rotationAngle);
% -1 since its backwards, also its transposed as its a back multiplication
rotationMatrix = -1 * [cos(rotationAngle), sin(rotationAngle); -sin(rotationAngle), cos(rotationAngle) ]; 

% Tip Ends
tip1 = endPosition + arrowVector * rotationMatrix;
tip2 = endPosition + arrowVector / rotationMatrix;

[x0, y0] = iHandler.sheetToImage(startPosition(1), startPosition(2));
[x1, y1] = iHandler.sheetToImage(endPosition(1), endPosition(2));
[x2, y2] = iHandler.sheetToImage(tip1(1), tip1(2));
[x3, y3] = iHandler.sheetToImage(tip2(1), tip2(2));

lineData = [x0 y0 x1 y1;
            x1 y1 x2 y2;
            x1 y1 x3 y3];

iHandler.pixelData = insertShape(iHandler.pixelData, 'Line', lineData, 'Color', colour, 'LineWidth', lineWidth); 
end

