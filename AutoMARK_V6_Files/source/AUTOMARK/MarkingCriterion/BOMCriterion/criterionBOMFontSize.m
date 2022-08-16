classdef criterionBOMFontSize < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMFontSize(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Font size matches within tolerance";
            obj.tolerancetip = "Plus or minus the tolerance is acceptable, units are font size";
            obj.tolerance.tolerance = 0;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.fontSize - studentFeature.fontSize) > abs(obj.tolerance.tolerance) + 0.0001
                multiplier = 1;
            end
             x = studentFeature.xmin;
            y0 = studentFeature.ymin;
            y1 = studentFeature.ymax;
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Font size of Table ""%s"" was found to match", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin,...
                        (y1)-0.01], 'Correct Font Size', criterionColours.fontSize, 'RightCenter',...
                        criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                               mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin,...
                        (y1)-0.01], 'Correct Font Size', criterionColours.fontSize, 'RightCenter',...
                        criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Font size of Table ""%s"" did not match key", studentFeature.name));
                   
                    mPlotText(relevantSheetHandler, criterionColours.misc, [studentFeature.xmin,...
                        (y1)-0.01], 'Incorrect Font Size', criterionColours.fontSize, 'RightCenter',...
                        criterionColours.fontName);
                end
            end
        end
    end
end

