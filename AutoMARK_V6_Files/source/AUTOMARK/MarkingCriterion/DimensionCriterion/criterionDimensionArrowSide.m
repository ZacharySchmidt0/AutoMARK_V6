classdef criterionDimensionArrowSide < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDimensionArrowSide(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if dimension arrow side matches key!";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            % The VBA does some extra processing to figure this out.
            % So the Arrowside is always one of
            % 0 -> Inside
            % 1 -> Outside
            %
            % If there is only one arrow, by default its 1 (outside)
            
            % WRONG NOW
            % Arrowside
            % 0 -> Inside
            % 1 -> Outside
            % 2 -> Smart
            % 3 -> Document Default (Which is smart)
            
            % Wrong Now!
            % Only wrong if 0, 1 or 1, 0
            % Not sure what to do about "smart"
            
            if (studentFeature.arrowside == 0 && keyFeature.arrowside == 1) || (studentFeature.arrowside == 1 && keyFeature.arrowside == 0)
                % Only true if the key has both arrows and the student has
                % both arrows.
                if (hasArrow(studentFeature, 1) || hasArrow(studentFeature, 2)) && (hasArrow(keyFeature, 1) || hasArrow(keyFeature, 2))
                    multiplier = 1;
                end
            end
        
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Dimension ""%s"" had appropriate arrows", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Dimension ""%s"" arrows were flipped", studentFeature.name));
                    % Position wrong
                    mPlotCircle(relevantSheetHandler, criterionColours.position, [studentFeature.arrow1x, studentFeature.arrow1y; studentFeature.arrow2x, studentFeature.arrow2y], 30) 
                end
            end
            
            function res = hasArrow(dim, which)
                if which == 1
                    % Arrow 1
                    res = dim.arrow1x ~= 0 || dim.arrow1y ~= 0;
                else
                    % Arrow 2
                    res = dim.arrow2x ~= 0 || dim.arrow2y ~= 0;
                end
            end
        end
    end
end

