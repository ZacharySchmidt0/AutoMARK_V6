classdef criterionSheetExtraBOMs < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetExtraBOMs(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra tables on a sheet";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if all views on student link.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            for i = 1:numel(studentFeature.childboms)
                
                studentBOM = studentFeature.childviews(i);
                keyBOM = linker.returnPair(studentBOM);
                
                if isempty(keyBOM)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("BOM %s could not be recognized in the key!", studentBOM.name));
                        
                        % Highlight the view
                        [corner1, corner2] = hrectangleLocation(studentBOM);
                        [centerPos] = hprincipleLocation(studentBOM);
                        
                        
                        % Yellow ish
                        mPlotRectangle(relevantSheetHandler, criterionColours.unrecognized, corner1, corner2);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos,...
                            "Unrecognized BOM", criterionColours.fontSize, 'Center',criterionColours.fontName);
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("No extra BOMs were found!");
                else
                    studentReport.addComment("Extra BOMs were found!");
                end
            end
        end
    end
end

