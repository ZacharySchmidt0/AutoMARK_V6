classdef criterionViewMaterial < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewMaterial(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches";
            obj.tolerancetip = "Other Acceptable Types, Please go to https://help.solidworks.com/2019/English/api/swconst/SOLIDWORKS.Interop.swconst~SOLIDWORKS.Interop.swconst.swDrawingViewTypes_e.html to understand";
            obj.tolerance.alternative = [];
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            try
                if (~strcmp(studentFeature.childsolidmodel.customproperties('Material'),  keyFeature.childsolidmodel.customproperties('Material')))
                    multiplier = 1;
                end
            catch
            end
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Type of View Material ""%s"" was found to match", studentFeature.childsolidmodel.customproperties('Material')));
                else
                    studentReport.addComment(sprintf("Type of View Material ""%s"" was not found to match", studentFeature.childsolidmodel.customproperties('Material')));
                    
                    [c1,c2] = hrectangleLocation(studentFeature);
                    mPlotText(relevantSheetHandler, criterionColours.misc, (c1+c2)/2, sprintf("Wrong Material"),...
                        criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
                end
            end
        end
        
       
    end
end

