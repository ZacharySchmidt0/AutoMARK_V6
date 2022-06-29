classdef criterionCentermarkExtensions < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkExtensions(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if ended lines match key in size";
            obj.tolerancetip = "+/- Allowance in meters";
            obj.tolerance.tolerance = 0.003; % 3 milimeters
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.extendedup - studentFeature.extendedup) > obj.tolerance.tolerance + 0.000001
                multiplier = 1;
            end
            
            if abs(keyFeature.extendedleft - studentFeature.extendedleft) > obj.tolerance.tolerance + 0.000001
                multiplier = 1;
            end
            
            if abs(keyFeature.extendedright - studentFeature.extendedright) > obj.tolerance.tolerance + 0.000001
                multiplier = 1;
            end
            
            if abs(keyFeature.extendeddown - studentFeature.extendeddown) > obj.tolerance.tolerance + 0.000001
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had appropriate length extension lines", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" had inappropriate length extension lines", studentFeature.name));
                end
            end
        end
    end
end

