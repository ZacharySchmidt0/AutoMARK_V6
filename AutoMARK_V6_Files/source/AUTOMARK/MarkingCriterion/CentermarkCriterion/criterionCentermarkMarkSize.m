classdef criterionCentermarkMarkSize < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkMarkSize(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if size matches key";
            obj.tolerancetip = "+/- Allowance in meters";
            obj.tolerance.tolerance = 0.0005; % 1/2 milimeter
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.size - studentFeature.size) > obj.tolerance.tolerance + 0.000001
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had appropriate size", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" had inappropriate size", studentFeature.name));
                end
            end
        end
    end
end

