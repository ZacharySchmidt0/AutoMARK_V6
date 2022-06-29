function createdLines = hPlotCross(iHandler, colour, startPosition, radius)
%HPLOTARROW Plots a cross on the sheet

createdLines = gobjects(1,2); % Crosses are 2 lines

crossD = radius/sqrt(2);

createdLines(1) = hPlotLine(iHandler, colour, startPosition + [-crossD -crossD], startPosition + [crossD crossD]); % Back diagonal
createdLines(2) = hPlotLine(iHandler, colour, startPosition + [-crossD crossD], startPosition + [crossD -crossD]); % Forward diagonal
end
