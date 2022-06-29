function mCreateFeature(iHandler, colour, inputFeature, stuParent,criterionColours)
%HPLOTARROW Plots abitrary features onto the sheet!
% stuParent might be empty, this is true for views and boms and balloon

% At 0 
keyParent = [0 0 1];
if isempty(stuParent)
    stuParent = [0 0 1];
end

switch class(inputFeature)
    case "comparableView"
        % For views make a rectangle
        [stPosition, enPosition] = hrectangleLocation(inputFeature);
        [cenPosition] = (enPosition + stPosition)/2;
        
        mPlotRectangle(iHandler, colour, stPosition, enPosition);
        mPlotText(iHandler, colour, cenPosition, "Missing View", 90, 'Center',criterionColours.fontName);
        
    case "comparableDimension"
        % For dimensions doublearrow between the arrows (if the second is
        % not zero) and a line from the first arrow to the text, all
        % relative
        
        keyParent = inputFeature.parent;
        
        x0 = inputFeature.arrow1x;
        y0 = inputFeature.arrow1y;
        
        
        % For one arrowed dimensions
        if inputFeature.arrow2x ~= 0 || inputFeature.arrow2y ~= 0
            
            x1 = inputFeature.arrow2x;
            y1 = inputFeature.arrow2y;
            
            mPlotDoubleArrow(iHandler, colour, correctPosition([x0 y0]), correctPosition([x1 y1]));
        end
        
        % Hole callouts are broken
        if x0 ~= 0 || y0 ~= 0
            mPlotArrow(iHandler, colour, correctPosition([inputFeature.annx, inputFeature.anny]), correctPosition([x0, y0]));
        end
        
        mPlotText(iHandler, colour, correctPosition([inputFeature.annx, inputFeature.anny]), string(inputFeature.dimension1value) ,...
            criterionColours.fontSize, 'Center',criterionColours.fontName); 
        
        if strcmp(inputFeature.isholecallout, 'true')
            mPlotText(iHandler, colour, correctPosition([inputFeature.annx, inputFeature.anny]), "Hole Callout",...
               criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
        end
        
    case "comparableCentermark"
        % For Centermarks its a Cross at the centerpoint!
        % These are weird, I also do the extended lines, but only by taking
        % the max of ext.
        
        keyParent = inputFeature.parent;
        
        extMax = max([inputFeature.extendedup, inputFeature.extendedleft, inputFeature.extendedright, inputFeature.extendeddown]);
        
        % 100 / 2.54 inches per meter, times 240 dots per inch
        mPlotCross(iHandler, colour, correctPosition(hprincipleLocation(inputFeature)), '+', ceil((inputFeature.size + extMax) * 100/2.54 * 240));
        
    case "comparableCenterline"
        % For Centerlines its a line
        
        keyParent = inputFeature.parent;
        
        mPlotLine(iHandler, colour, correctPosition([inputFeature.startx, inputFeature.starty]), correctPosition([inputFeature.endx, inputFeature.endy]));
        
    case "comparableDatum"
        % For Datums its a line from end to start plus a rectangle, plus a
        % bar.
        
        keyParent = inputFeature.parent;

        stPos = [inputFeature.startx, inputFeature.starty];
        enPos = [inputFeature.endx, inputFeature.endy];
            
        v1 = stPos - enPos;
        % rotate v1 90 degrees and normalize
        v1 = [v1(2) -v1(1)] / norm(v1);
        
        lpos1 = stPos + v1 * 0.007;
        lpos2 = stPos - v1 * 0.007;
        
        [corner1, corner2] = hrectangleLocation(inputFeature);
        
        % Two lines at once to save time
        mPlotLine(iHandler, colour, [correctPosition(stPos); correctPosition(lpos1)], [correctPosition(enPos); correctPosition(lpos2)]);
        mPlotRectangle(iHandler, colour, correctPosition(corner1), correctPosition(corner2));
        mPlotText(iHandler, colour, correctPosition(hprincipleLocation(inputFeature)), inputFeature.label, criterionColours.fontSize...
            , 'Center',criterionColours.fontName);
        
        
        
    case "comparableBalloon"
        % For all balloons its a circle and the text and a line
        if ~isempty(inputFeature.parent)
            keyParent = inputFeature.parent;
        end
        
        bPos = correctPosition([inputFeature.annx, inputFeature.anny]);
        bAtt = correctPosition([inputFeature.attachx, inputFeature.attachy]);
        
        if strcmp(inputFeature.isbomballoon, 'true')
            mPlotCircle(iHandler, colour, bPos, 48);
            mPlotLine(iHandler, colour, bPos, bAtt);
            mPlotText(iHandler, colour, bPos, inputFeature.text, criterionColours.fontSize, 'Center',...
                criterionColours.fontName);
        else
            mPlotText(iHandler, colour, bPos, inputFeature.text,criterionColours.fontSize, 'LeftTop',criterionColours.fontName);
        end
        
    case "comparableBOM"
        % For BOMS its just a rectangle
        % For views make a rectangle
        [stPosition, enPosition] = hrectangleLocation(inputFeature);
        [cenPosition] = (enPosition + stPosition)/2;
        
        mPlotRectangle(iHandler, colour, stPosition, enPosition);
        mPlotText(iHandler, colour, cenPosition, "Missing BOM", 90, 'Center',criterionColours.fontName);
        
    otherwise
        % Drawings, Sheets -> Do nothing
end

    function corrected = correctPosition(inputLocation)
        corrected = moveRelativeToView(inputLocation, keyParent, stuParent);
    end
end

