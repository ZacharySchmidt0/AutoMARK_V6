classdef criterionDatumDisplayStyle < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDatumDisplayStyle(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if datum display style matches key";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if triangle matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if studentFeature.displaystyle ~= keyFeature.displaystyle
                multipler = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Datum ""%s"" had an appropriate display style", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Datum ""%s"" didn't have an appropriate display style", studentFeature.name));
                end
            end
        end
    end
end

