function [corner1, corner2] = htemplateLocation(inputFeature)
%HIGHLIGHTFEATURE Returns a box around a feature, big enough that you can
% actually see stuff.

% 5% of sheet width padding
padding = 0.4318 * 0.1;

switch class(inputFeature)
    case "comparableSheet"
        % Box around the sheet!
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputFeature.ymin;
        y2 = inputFeature.ymax;
        
    case "comparableView"
        % For views the principle location is box around them, plus and
        % minus a bit
        x1 = inputFeature.xmin - padding;
        x2 = inputFeature.xmax + padding;
        y1 = inputFeature.ymin - padding;
        y2 = inputFeature.ymax + padding;
        
    case "comparableDimension"
        % For dimensions its just annx anny + - a bit
        x1 = inputFeature.annx - padding;
        x2 = inputFeature.annx + padding;
        
        y1 = inputFeature.anny - padding;
        y2 = inputFeature.anny + padding;
        
    case "comparableCentermark"
        % For Centermarks its the cmx + viewx / cmy + viewy +- padding
        x1 = inputFeature.cmx + inputFeature.parent.x - padding;
        x2 = inputFeature.cmx + inputFeature.parent.x + padding;
        
        y1 = inputFeature.cmy + inputFeature.parent.y - padding;
        y2 = inputFeature.cmy + inputFeature.parent.y + padding;
        
    case "comparableCenterline"
        % For Centerlines its a box around the entire thing
        x1 = min(inputFeature.startx, inputFeature.endx) - padding;
        x2 = max(inputFeature.startx, inputFeature.endx) + padding;
        
        y1 = min(inputFeature.starty, inputFeature.endy) - padding;
        y2 = max(inputFeature.starty, inputFeature.endy) + padding;
        
    case "comparableDatum"
        % For Datums its the principle Location, plus and minus a bit.
        

        
        tempPos = hprincipleLocation(inputFeature);
        
        x1 = tempPos(1) - padding;
        x2 = tempPos(1) + padding;
        y1 = tempPos(2) - padding;
        y2 = tempPos(2) + padding;

        
    case "comparableBalloon"
        % For all balloons its around the text location
        x1 = inputFeature.annx - padding;
        x2 = inputFeature.annx + padding;
        
        y1 = inputFeature.anny - padding;
        y2 = inputFeature.anny + padding;
        
    case "comparableBOM"
        % For BOMS its just the box itself
        x1 = inputFeature.xmin - padding;
        x2 = inputFeature.xmax + padding;
        y1 = inputFeature.ymin - padding;
        y2 = inputFeature.ymax + padding;
        
    otherwise % Bad
        x1 = 0;
        x2 = 2*padding;
        y1 = 0;
        y2 = 2*padding;
end

corner1 = [x1 y1];
corner2 = [x2 y2];

end

