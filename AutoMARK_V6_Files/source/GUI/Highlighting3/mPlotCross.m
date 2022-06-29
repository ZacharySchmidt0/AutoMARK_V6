function mPlotCross(iHandler, colour, startPosition, crossShape, crossSize)
%HPLOTARROW Plots a cross on the sheet

[x0, y0] = iHandler.sheetToImage(startPosition(1), startPosition(2));

% To add thickness, we do a lot of them.
crossLocations = [x0, y0;
                  x0 + 1, y0 + 1;
                  x0 + 1, y0 - 1;
                  x0 - 1, y0 + 1;
                  x0 - 1, y0 - 1];
              
iHandler.pixelData = insertMarker(iHandler.pixelData, crossLocations, crossShape, 'Size', crossSize, 'Color', colour);
end
