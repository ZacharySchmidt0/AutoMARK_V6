function [corner1, corner2] = hrectangleLocation(inputFeature)
%HIGHLIGHTFEATURE Returns a box around a feature

% 4/11 of 2 percent of the expected width, strange numbers but they were
% mesaured empirically
boxpadding = 0.4318 * 0.02 * 4/11;


switch class(inputFeature)
    case "comparableSheet"
        % Box around the sheet!
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputFeature.ymin;
        y2 = inputFeature.ymax;
        
    case "comparableView"
        % For views the principle location is box around them
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputFeature.ymin;
        y2 = inputFeature.ymax;
        
    case "comparableDimension"
        % For dimensions its just annx anny + - a bit
        x1 = inputFeature.annx - boxpadding;
        x2 = inputFeature.annx + boxpadding;
        
        y1 = inputFeature.anny - boxpadding;
        y2 = inputFeature.anny + boxpadding;
        
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
        % For Datums its the principle Location, plus and minus a bit.
        

        
        tempPos = hprincipleLocation(inputFeature);
        
        x1 = tempPos(1) - boxpadding;
        x2 = tempPos(1) + boxpadding;
        y1 = tempPos(2) - boxpadding;
        y2 = tempPos(2) + boxpadding;

        
    case "comparableBalloon"
        % For all balloons its around the text location
        x1 = inputFeature.annx - boxpadding;
        x2 = inputFeature.annx + boxpadding;
        
        y1 = inputFeature.anny - boxpadding;
        y2 = inputFeature.anny + boxpadding;
        
    case "comparableBOM"
        % For BOMS its just the box itself
        x1 = inputFeature.xmin;
        x2 = inputFeature.xmax;
        y1 = inputFeature.ymin;
        y2 = inputFeature.ymax;
        
    otherwise
        x1 = 0;
        x2 = 0;
        y1 = 0;
        y2 = 0;
end

corner1 = [x1 y1];
corner2 = [x2 y2];

end

