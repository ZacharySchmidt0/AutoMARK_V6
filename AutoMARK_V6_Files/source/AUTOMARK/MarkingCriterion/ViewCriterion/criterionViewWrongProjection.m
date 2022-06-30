classdef criterionViewWrongProjection < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewWrongProjection(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Incorrect only if the view is a section AND it was flipped";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);

            if ischar(keyFeature.wasmirrored)
                if strcmp(keyFeature.wasmirrored, 'false')
                    keyFeature.wasmirrored = true;
                else
                    keyFeature.wasmirrored = false;
                end
            end

            if ischar(studentFeature.wasmirrored)
                if strcmp(studentFeature.wasmirrored, 'false')
                    studentFeature.wasmirrored = true;
                else
                    studentFeature.wasmirrored = false;
                end
            end
            
            if xor(keyFeature.wasmirrored,studentFeature.wasmirrored) && keyFeature.viewtype == 2 % Section view
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("View ""%s"" was properly projected", studentFeature.name));
                else
                    studentReport.addComment(sprintf("View ""%s"" was the wrong projection to the key", studentFeature.name));
                    
                    
                    % Draws it on the top
                    x0 = studentFeature.xmin;
                    x1 = studentFeature.xmax;
                    y = studentFeature.ymax;
                    
                    % Purple
                    mPlotDoubleArrow(relevantSheetHandler, criterionColours.misc, [x0 y], [x1 y]);
                    mPlotText(relevantSheetHandler, criterionColours.misc, [(x0 + x1)/2, y], "Wrong Projection",...
                        criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                end
            end
        end
    end
end

