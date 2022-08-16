classdef criterionBOMTableWidth < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMTableWidth(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if within tolerance";
            obj.tolerancetip = "Plus or minus the tolerance is acceptable, units are meters";
            obj.tolerance.tolerance = 0.015;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.width - studentFeature.width) > abs(obj.tolerance.tolerance) + 0.0001
                multiplier = 1;
            end
            x0 = studentFeature.xmin;
            x1 = studentFeature.xmax;
            y = studentFeature.ymax;
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Width of Table ""%s"" was acceptable", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                              mPlotText(relevantSheetHandler, criterionColours.correct, [(x0+x1)./2, y], 'Correct Width', criterionColours.fontSize...
                        , 'CenterBottom', criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, [(x0+x1)./2, y], 'Correct Width', criterionColours.fontSize...
                        , 'CenterBottom', criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Width of Table ""%s"" was unacceptable", studentFeature.name));
                    % Purple
                    mPlotDoubleArrow(relevantSheetHandler, criterionColours.misc, [x0 y], [x1 y]);
                    mPlotText(relevantSheetHandler, criterionColours.misc, [(x0+x1)./2, y], 'Incorrect Width', criterionColours.fontSize...
                        , 'CenterBottom', criterionColours.fontName);
                end
            end
        end
    end
end

