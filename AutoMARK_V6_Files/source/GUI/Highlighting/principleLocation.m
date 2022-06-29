function [success , x, y] = principleLocation(inputFeature)
% PRINCIPLELOCATION
% Returns the principle location of a dimension, view, position, etc

success = true;

switch class(inputFeature)
    case "comparableView"
        % For views the principle location is the center
        position = [(inputFeature.xmin + inputFeature.xmax)/2,  (inputFeature.ymin + inputFeature.ymax)/2];
    case "comparableDimension"
        % For dimensions its just annx anny, which is where the text is
        position = [inputFeature.annx, inputFeature.anny];
    case "comparableCentermark"
        % For Centermarks its the cmx + viewx, cmy + viewy
        position = [inputFeature.cmx + inputFeature.parent.x, inputFeature.cmy + inputFeature.parent.y];
    case "comparableCenterline"
        % For Centerlines its the midpoint
        position = [(inputFeature.startx + inputFeature.endx)/2, (inputFeature.starty + inputFeature.endy)/2]; 
    case "comparableDatum"
        % For Datums its the end position
        position = [inputFeature.endx, inputFeature.endy];
    case "comparableBalloon"
        % For all balloons its the text location
        position = [inputFeature.annx, inputFeature.anny];
    case "comparableBOM"
        % For BOMS its just the middle
        position = [(inputFeature.xmin + inputFeature.xmax)/2,  (inputFeature.ymin + inputFeature.ymax)/2];
    otherwise
        success = false;
        position = [0, 0];
end

x = position(1);
y = position(2);
end

