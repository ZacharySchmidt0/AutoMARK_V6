classdef criterionBOMFontType < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMFontType(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Font matches";
            obj.tolerancetip = "No tolerance";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
             if ~strcmp(keyFeature.fonttype,studentFeature.fonttype)
                multiplier = 1;
            end
            x = studentFeature.xmin;
            y0 = studentFeature.ymin;
            y1 = studentFeature.ymax;
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Font type of Table ""%s"" was found to match", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                              mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, (y1)-0.005],...
                        'Correct Font', criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, (y1)-0.005],...
                        'Correct Font', criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Font type of Table ""%s"" did not match key", studentFeature.name));
                    
                    mPlotText(relevantSheetHandler, criterionColours.misc, [studentFeature.xmin, ((y1))-0.005],...
                        'Incorrect Font', criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                end
            end
        end
    end
end

