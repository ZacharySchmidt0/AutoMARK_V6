classdef criterionSheetExtraViews < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetExtraViews(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra views on a sheet";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if all views on student link.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            for i = 1:studentFeature.numviews
                
                studentView = studentFeature.childviews(i);
                keyView = linker.returnPair(studentView);
                
                if isempty(keyView)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("View %s could not be recognized in the key!", studentView.name));
                        
                        % Highlight the view
                        [corner1, corner2] = hrectangleLocation(studentView);
                        centerPos = hprincipleLocation(studentView);
                        
                        % Yellow ish
                        mPlotRectangle(relevantSheetHandler, criterionColours.unrecognized, corner1, corner2);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos,...
                            "Unrecognized View", criterionColours.fontSize, 'Center',criterionColours.fontName);
                        
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, studentFeature.ymax - 0.02],...
                            'Correct Number of views', criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, studentFeature.ymax - 0.02],...
                            'Correct Number of views', criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                            end
                    end
                    studentReport.addComment("No extra views were found!");
                else
                    mPlotText(relevantSheetHandler, criterionColours.value, [studentFeature.xmin, studentFeature.ymax - 0.02],...
                            'Extra Views were found', criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                    studentReport.addComment("Extra views were found!");
                end
            end
        end
    end
end

