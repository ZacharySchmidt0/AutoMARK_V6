function position = hprincipleLocation(inputFeature)
% PRINCIPLELOCATION, Similar to priniciple location, but is built for
% highlighting!
% Returns the principle location of a dimension, view, position, etc

switch class(inputFeature)
    case "comparableSheet"
        % For sheets its the center of the sheet!
        position = [(inputFeature.xmin + inputFeature.xmax)/2,  (inputFeature.ymin + inputFeature.ymax)/2];
    case "comparableView"
        % For views the principle location is the center
        
        % Its now the Given x and y
        %position = [(inputFeature.xmin + inputFeature.xmax)/2,  (inputFeature.ymin + inputFeature.ymax)/2];
        
        % Need this so centermarks show up correcltly.
        % position = [inputFeature.x, inputFeature.y];
        
        % Don't Need it anymore, back to middle!
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
        % For Datums its the end position, plus a bit in the direction of
        % the vector!
        extrabit = 0.00246; % Measured constant
        
        st = [inputFeature.startx, inputFeature.starty];
        en = [inputFeature.endx, inputFeature.endy];
        
        vec = en - st;
        
        position = en + vec/norm(vec)*extrabit;
        
    case "comparableBalloon"
        % For all balloons its the text location
        position = [inputFeature.annx, inputFeature.anny];
    case "comparableBOM"
        % For BOMS its just the middle
        position = [(inputFeature.xmin + inputFeature.xmax)/2,  (inputFeature.ymin + inputFeature.ymax)/2];
    otherwise
        position = [0, 0];
end

end

