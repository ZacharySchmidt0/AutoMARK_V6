classdef criterionDatumFilledTriangle < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDatumFilledTriangle(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if triangle filling matches key!";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if triangle matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if xor(studentFeature.filledtriangle, keyFeature.filledtriangle)
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Datum ""%s"" had a properly filled in triangle", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Datum ""%s"" didn't have a properly filled in triangle", studentFeature.name));
                end
            end
        end
    end
end

