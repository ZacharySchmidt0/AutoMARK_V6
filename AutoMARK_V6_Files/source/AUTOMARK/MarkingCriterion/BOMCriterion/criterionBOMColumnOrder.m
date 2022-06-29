classdef criterionBOMColumnOrder < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMColumnOrder(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches or its toleranced";
            obj.tolerancetip = "No tolerance";
            
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            for i = 1:keyFeature.numcolumns
                try
                    if  ~contains(lower(keyFeature.colNames{i}), lower(studentFeature.colNames{i}))
                        multiplier = 1;
                        break;
                    end
                catch
                    multiplier = 1;
                    break;
                end
            end
            x = studentFeature.xmin;
            y0 = studentFeature.ymin;
            y1 = studentFeature.ymax;
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Number of columns of Table ""%s"" was found to match", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, (y1)-0.015],...
                        'Correct Column Order',criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, (y1)-0.015],...
                        'Correct Column Order',criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Column Name order of Table ""%s"" did not match key", studentFeature.name));
                    mPlotText(relevantSheetHandler, criterionColours.misc, [studentFeature.xmin, (y1)-0.015],...
                        'Incorrect Column Order',criterionColours.fontSize, 'RightCenter',criterionColours.fontName);
                end
            end
        end
    end
end

