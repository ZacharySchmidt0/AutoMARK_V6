classdef criterionDatumBasePosition < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDatumBasePosition(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if inside given rectangle(s)!";
            obj.tolerancetip = "Rectangles are a set of rectangles given as boxes around the original datum base, units are meters and you can add more rectangles by adding additional rows of 4 numbers as xmin, ymin, xmax, ymax.";
            
            obj.tolerance.rectangles = [-0.005, -0.005, 0.005, 0.005];
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            studentLocation = [studentFeature.startx, studentFeature.starty];
            keyLocation = [keyFeature.startx, keyFeature.starty];
            
            keyRectangleC1 = moveRelativeToView(obj.tolerance.rectangles(:, [1,2]) + keyLocation, keyFeature.parent, studentFeature.parent);
            keyRectangleC2 = moveRelativeToView(obj.tolerance.rectangles(:, [3,4]) + keyLocation, keyFeature.parent, studentFeature.parent);
            
            if ~insideRectangles(studentLocation, [keyRectangleC1, keyRectangleC2])
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Datum ""%s"" had a base in a suitable location", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Datum ""%s"" didn't have a base in a suitable location", studentFeature.name));
                    
                    
                    % Arrow from student to key, missing coloured
                    
                    % If the datum isn't cross linked, then do this,
                    % because otherwise this looks very messy.
                    if linker.returnPair(studentFeature.parent) == keyFeature.parent
                        mPlotArrow(relevantSheetHandler, criterionColours.position, studentLocation, moveRelativeToView(keyLocation, keyFeature.parent, studentFeature.parent));
                    end
                end
            end
        end
        
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler, criterionColours)
            % Function which deals with the tolerancing display on the
            % marking GUI
            
            keyLocation = [keyFeature.startx, keyFeature.starty];
            c1 = obj.tolerance.rectangles(:, [1,2]) + keyLocation;
            c2 = obj.tolerance.rectangles(:, [3,4]) + keyLocation;
            
            gfxobjects = gobjects(1,size(c1, 1));
            for i = 1:size(c1, 1) % For each rectangle, draw it.
                gfxobjects(i) = hPlotRectangle(relevantSheetHandler, criterionColours.position, c1(i, :), c2(i, :));
            end
            
            gfxobjects = [gfxobjects,hPlotCross(relevantSheetHandler, criterionColours.position, keyLocation, 0.005)];
        end
        
        function onClickRespond(obj, keyFeature, clickLocation)
            % Respond to clicks on the UI figure, very useful for tolerance
            % boxes and what not.
            
            % This is the "Selecting Rectangles Version"
            
            % If we got exactly 2 points
            
            if size(clickLocation,1) >= 2
                % New points!
                obj.tolerance.rectangles = double.empty(0,4);
            end
            
            for i = 2:2:size(clickLocation,1)
                
                    % Translate this
                    translated = clickLocation(i-1:i, 1:2) - [keyFeature.startx, keyFeature.starty];

                    xmin = min(translated(:, 1));
                    xmax = max(translated(:, 1));

                    ymin = min(translated(:, 2));
                    ymax = max(translated(:, 2));

                    obj.tolerance.rectangles = [obj.tolerance.rectangles; xmin, ymin, xmax, ymax]; 
            end
        end
        
    end
end

