classdef criterionSheetMass < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetMass(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches or its toleranced";
            obj.tolerancetip = "Other Acceptable Types, Please go to https://help.solidworks.com/2019/English/api/swconst/SOLIDWORKS.Interop.swconst~SOLIDWORKS.Interop.swconst.swDrawingViewTypes_e.html to understand";
            obj.tolerance.tolerance = 0;
        end
        
       function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct-
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            try
                if (abs(studentFeature.childviews(1).childsolidmodel.mass - keyFeature.childviews(1).childsolidmodel.mass) < obj.tolerance.tolerance)
                    multiplier = 1;
                end
            catch
            end
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Type of View Mass was found to match"));
                else
                    studentReport.addComment(sprintf("Type of View Mass was not found to match"));
                end
            end
        end
    end
end

