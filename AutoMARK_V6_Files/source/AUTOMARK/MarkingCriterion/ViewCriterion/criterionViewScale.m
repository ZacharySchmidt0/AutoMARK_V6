classdef criterionViewScale < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewScale(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches";
            obj.tolerancetip = "You can allow ratios to be not simplified (1:2 and 2:4 would be equal if mustBeSimplifed is false)";
            obj.tolerance.mustBeSimplified = true;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if obj.tolerance.mustBeSimplified
                % If either are incorrect
                if keyFeature.scale1 ~= studentFeature.scale1 || keyFeature.scale2 ~= studentFeature.scale2
                    multiplier = 1;
                end
            else
                % I multiply across the denominators to prevent dividing
                % errors and maintain integer math
                if keyFeature.scale1 * studentFeature.scale2 ~= keyFeature.scale2 * studentFeature.scale1
                    multiplier = 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Scale of View ""%s"" was found to match", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin],...
                        "Correct Scale", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin],...
                        "Correct Scale", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Scale of View ""%s"" did not match key", studentFeature.name));
                    % Purple, Below Sheet
                    mPlotText(relevantSheetHandler, criterionColours.misc,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin],...
                        "Incorrect Scale", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                end
            end
        end
    end
end

