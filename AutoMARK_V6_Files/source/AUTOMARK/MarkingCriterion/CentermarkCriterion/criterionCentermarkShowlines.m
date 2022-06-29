classdef criterionCentermarkShowlines < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkShowlines(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if extended line display matches key";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if showlines == others showlines
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if xor(keyFeature.showlines, studentFeature.showlines)
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had correct extended lines", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" didn't have correct extended lines", studentFeature.name));
                end
            end
        end
    end
end

