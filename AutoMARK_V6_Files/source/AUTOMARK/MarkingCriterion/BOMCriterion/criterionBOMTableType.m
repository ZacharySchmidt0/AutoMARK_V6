classdef criterionBOMTableType < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMTableType(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches or its toleranced";
            obj.tolerancetip = "Other Acceptable Types, Please go to http://help.solidworks.com/2019/english/api/swconst/SOLIDWORKS.Interop.swconst~SOLIDWORKS.Interop.swconst.swTableAnnotationType_e.html";
            obj.tolerance.alternative = [-2];
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if keyFeature.tabletype ~= studentFeature.tabletype && ~any(studentFeature.tabletype == obj.tolerance.alternative)
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Table type of Table ""%s"" was found to match", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Table type of Table ""%s"" did not match key", studentFeature.name));
                end
            end
        end
    end
end

