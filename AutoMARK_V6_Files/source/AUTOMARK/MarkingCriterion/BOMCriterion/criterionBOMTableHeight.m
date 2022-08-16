classdef criterionBOMTableHeight < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMTableHeight(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if within tolerance";
            obj.tolerancetip = "Plus or minus the tolerance is acceptable, units are meters";
            obj.tolerance.tolerance = 0.012;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.height - studentFeature.height) > abs(obj.tolerance.tolerance) + 0.0001
                multiplier = 1;
            end
            x = studentFeature.xmin;
            y0 = studentFeature.ymin;
            y1 = studentFeature.ymax;
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Height of Table ""%s"" was acceptable", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                              mPlotText(relevantSheetHandler, criterionColours.correct, [x, y1], 'Correct Height',...
                        criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                 mPlotText(relevantSheetHandler, criterionColours.correct, [x, y1], 'Correct Height',...
                        criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Height of Table ""%s"" was unacceptable", studentFeature.name));
                    
                    
                    
                    
                    % Purple
                    mPlotDoubleArrow(relevantSheetHandler, criterionColours.misc, [x y0], [x y1]);
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y1], 'Incorrect Height',...
                        criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                end
            end
        end
    end
end

