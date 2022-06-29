classdef criterionCenterlinePostion < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCenterlinePostion(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if both ends are inside given rectangle(s)!";
            obj.tolerancetip = "Rectangles are a set of rectangles given as boxes around the endpoints, units are meters and you can add more rectangles by adding additional rows of 4 numbers as xmin, ymin, xmax, ymax. Each rectangle shows up at both ends! Note if you use the click functionality, test it around one point first, then test it around the other";
            
            obj.tolerance.rectangles = [-0.003, -0.003, 0.003, 0.003];
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            % First generate all the rectangles as where they should be in
            % the student.
            
            k1 = [keyFeature.startx, keyFeature.starty];
            k2 = [keyFeature.endx, keyFeature.endy];
            
            keyRectStartC1 = obj.tolerance.rectangles(:, [1, 2]) + k1;
            keyRectStartC2 = obj.tolerance.rectangles(:, [3, 4]) + k1;
            
            keyRectEndC1 = obj.tolerance.rectangles(:, [1, 2]) + k2;
            keyRectEndC2 = obj.tolerance.rectangles(:, [3, 4]) + k2;
            
            
            stuRectStartC1 = moveRelativeToView(keyRectStartC1, keyFeature.parent, studentFeature.parent);
            stuRectStartC2 = moveRelativeToView(keyRectStartC2, keyFeature.parent, studentFeature.parent);
            
            stuRectEndC1 = moveRelativeToView(keyRectEndC1, keyFeature.parent, studentFeature.parent);
            stuRectEndC2 = moveRelativeToView(keyRectEndC2, keyFeature.parent, studentFeature.parent);
            
            stuRects = [stuRectStartC1, stuRectStartC2;
                stuRectEndC1  , stuRectEndC2];
            
            % Now check if both student points are within any of those rectangles!
            s1 = [studentFeature.startx, studentFeature.starty];
            s2 = [studentFeature.endx, studentFeature.endy];
            
            % If either are not, then its wrong
            if ~insideRectangles(s1 , stuRects) || ~insideRectangles(s2, stuRects)
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centerline ""%s"" was in a suitable location", studentFeature.name));
                   
                else
                    studentReport.addComment(sprintf("Centerline ""%s"" wasn't in a suitable location", studentFeature.name));
                    
                    
                    % Arrow from student to key, position coloured, they
                    % might be drawing wrong but its okay, point will
                    % roughly be made.
                    
                    % See which one is closer
                    if norm(moveRelativeToView(k1, keyFeature.parent, studentFeature.parent) - s1) <= norm(moveRelativeToView(k2, keyFeature.parent, studentFeature.parent) - s1)
                        mPlotArrow(relevantSheetHandler, criterionColours.position, s1, moveRelativeToView(k1, keyFeature.parent, studentFeature.parent));
                        mPlotArrow(relevantSheetHandler, criterionColours.position, s2, moveRelativeToView(k2, keyFeature.parent, studentFeature.parent));
                    else
                        mPlotArrow(relevantSheetHandler, criterionColours.position, s2, moveRelativeToView(k1, keyFeature.parent, studentFeature.parent));
                        mPlotArrow(relevantSheetHandler, criterionColours.position, s1, moveRelativeToView(k2, keyFeature.parent, studentFeature.parent));
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
            gfxobjects = gobjects(1,size(c1, 1) * 2);
            
            % Start rectangles
            for i = 1:size(c1, 1) % For each rectangle, draw it.
                gfxobjects(i) = hPlotRectangle(relevantSheetHandler, criterionColours.position, c1(i, :), c2(i, :));
            end
            
            keyLocation = [keyFeature.endx, keyFeature.endy];
            c1 = obj.tolerance.rectangles(:, [1,2]) + keyLocation;
            c2 = obj.tolerance.rectangles(:, [3,4]) + keyLocation;
            
            % End Rectangles
            for i = 1:size(c1, 1)
                gfxobjects(i + size(c1, 1)) = hPlotRectangle(relevantSheetHandler, criterionColours.position, c1(i, :), c2(i, :));
            end
            
            gfxobjects = [gfxobjects, hPlotCross(relevantSheetHandler, criterionColours.position, [keyFeature.endx, keyFeature.endy], 0.0025), hPlotCross(relevantSheetHandler, criterionColours.position, [keyFeature.startx, keyFeature.starty], 0.0025) ];
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

