function createdLines = hPlotText(iHandler, colour, startPosition, givenText, fontsize)
%HPLOTARROW Plots a text on the sheet, The text can have latex format

createdLines = gobjects(1); % Text is a thing

% Grab coordinates
[x0, y0] = iHandler.sheetToAxis(startPosition(1), startPosition(2));

createdLines(1) = text(iHandler.onAxis, x0, y0, sanitizeText(givenText), "FontSize", fontsize, "Color", colour./255, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle'); 
end

