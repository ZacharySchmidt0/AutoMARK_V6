classdef criterionViewTangentLines < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewTangentLines(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches";
            obj.tolerancetip = "Not applicable currently";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if keyFeature.tangentlines ~= studentFeature.tangentlines
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Tangent Edges on View ""%s"" was found to match", studentFeature.name));
                     switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin + 0.005],...
                        "Correct Tangent Line style", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin + 0.005],...
                        "Correct Tangent Line style", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                            end
                    end
                   
                else
                    studentReport.addComment(sprintf("Tangent Edges on View ""%s"" did not match key", studentFeature.name));
                    mPlotText(relevantSheetHandler, criterionColours.misc,...
                        [(studentFeature.xmin + studentFeature.xmax)/2, studentFeature.ymin + 0.005],...
                        "Incorrect Tangent Line style", criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                end
            end
        end
    end
end

