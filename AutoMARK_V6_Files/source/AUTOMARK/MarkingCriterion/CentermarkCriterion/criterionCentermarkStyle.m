classdef criterionCentermarkStyle < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkStyle(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if style matches key! Style is linear group, circular group, or isolated centermark";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if keyFeature.style ~= studentFeature.style
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had the correct style", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" didn't have correct style", studentFeature.name));
                end
            end
        end
    end
end

