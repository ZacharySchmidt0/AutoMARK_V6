classdef criterionViewType < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewType(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches or its toleranced";
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
            
            if keyFeature.viewtype ~= studentFeature.viewtype && ~any(studentFeature.viewtype == obj.tolerance.alternative)
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Type of View ""%s"" was found to match", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Type of View ""%s"" did not match key, expected %s got %s", studentFeature.name, typeToString(keyFeature.viewtype), typeToString(studentFeature.viewtype)));
                    
                    [c1,c2] = hrectangleLocation(studentFeature);
                    mPlotText(relevantSheetHandler, criterionColours.misc, (c1+c2)/2,...
                        sprintf("Wrong Type of View\nExpected %s\nGot %s", typeToString(keyFeature.viewtype),...
                        typeToString(studentFeature.viewtype)), criterionColours.fontSize...
                        , 'CenterBottom',criterionColours.fontName);
                end
            end
        end
        
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler)
            % Function which deals with the tolerancing display on the
            % marking GUI
            [c1, c2] = hrectangleLocation(keyFeature);
            
            gfxobjects = hPlotText(relevantSheetHandler, criterionColours.misc ,(c1 + c2)./2, allText(), 30);
            
            function goodText = allText()
                goodText = typeToString(keyFeature.viewtype);
                
                for i = 1:numel(obj.tolerance.alternative)
                    goodText = sprintf('%s\n+%s', goodText, typeToString(obj.tolerance.alternative(i)));
                end
            end
        end
    end
end

