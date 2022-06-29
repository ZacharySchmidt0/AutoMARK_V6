classdef criterionSheetTemplateIN < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetTemplateIN(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if keyFeature.templatein ~= studentFeature.templatein
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Template of Sheet ""%s"" was found to match", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Template of Sheet ""%s"" did not match key", studentFeature.name));
                end
            end
        end
    end
end

