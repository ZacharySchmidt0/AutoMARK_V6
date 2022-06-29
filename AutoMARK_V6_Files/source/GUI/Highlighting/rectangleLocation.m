function [success, x1, y1, x2, y2] = rectangleLocation(inputFeature)
%HIGHLIGHTFEATURE Returns a box around a feature

% 2 percent of the expected width
boxpadding = 0.4318 * 0.02;

success = true;

switch class(inputFeature)
    case "comparableView"
        % For views the principle location is box around them
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputfeature.ymin;
        y2 = inputfeature.ymax;
        
    case "comparableDimension"
        % For dimensions its just annx anny + - a bit
        x1 = inputFeature.annx - boxpadding;
        x2 = inputFeature.annx + boxpadding;
        
        y1 = inputFeature.annx - boxpadding;
        y2 = inputFeature.annx + boxpadding;
        
    case "comparableCentermark"
        % For Centermarks its the cmx + viewx / cmy + viewy +- padding
        x1 = inputFeature.cmx + inputFeature.parent.x - boxpadding;
        x2 = inputFeature.cmx + inputFeature.parent.x + boxpadding;
        
        y1 = inputFeature.cmy + inputFeature.parent.y - boxpadding;
        y2 = inputFeature.cmy + inputFeature.parent.y + boxpadding;
        
    case "comparableCenterline"
        % For Centerlines its a box around the entire thing
        x1 = min(inputFeature.startx, inputFeature.endx) - boxpadding;
        x2 = max(inputFeature.startx, inputFeature.endx) + boxpadding;
        
        y1 = min(inputFeature.starty, inputFeature.endy) - boxpadding;
        y2 = max(inputFeature.starty, inputFeature.endy) + boxpadding;
        
    case "comparableDatum"
        % For Datums its the end position
        
        x1 = inputFeature.endx - boxpadding;
        x2 = inputFeature.endx + boxpadding;
        y1 = inputFeature.endy - boxpadding;
        y2 = inputFeature.endy + boxpadding;
        
        
    case "comparableBalloon"
        % For all balloons its around the text location
        x1 = inputFeature.annx - boxpadding;
        x2 = inputFeature.annx + boxpadding;
        
        y1 = inputFeature.annx - boxpadding;
        y2 = inputFeature.annx + boxpadding;
        
    case "comparableBOM"
        % For BOMS its just the box itself
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputfeature.ymin;
        y2 = inputfeature.ymax;
        
    otherwise
        success = false;
        x1 = 0;
        x2 = 0;
        y1 = 0;
        y2 = 0;
end
end

