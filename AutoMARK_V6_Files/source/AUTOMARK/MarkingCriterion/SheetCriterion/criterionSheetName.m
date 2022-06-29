classdef criterionSheetName < baseCriterion
    %CRITERIONSHEETORDER Criterion which evaluates sheet order.
    
    methods
        function obj = criterionSheetName(recommendedweight)
            %CRITERIONSHEETNAME
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the sheet's name is correct";
            obj.tolerancetip = "Case Sensitivity is tolerancable";
            obj.tolerance.caseSensitive = false;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if names are correct
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if obj.tolerance.caseSensitive
                if string(studentFeature.name) ~= string(keyFeature.name)
                    multiplier = 1;
                end
            else
                if lower(string(studentFeature.name)) ~= lower(string(keyFeature.name))
                    multiplier = 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Name of Sheet ""%s"" was found to match", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Name of Sheet ""%s"" did not match key", studentFeature.name));
                end
            end
        end
    end
end

