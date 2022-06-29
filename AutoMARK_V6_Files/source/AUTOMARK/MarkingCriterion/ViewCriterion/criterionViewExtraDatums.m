classdef criterionViewExtraDatums < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewExtraDatums(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra datums on a view";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if all views on student link.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            for i = 1:studentFeature.numdatums
                
                studentChild = studentFeature.childdatums(i);
                keyChild = linker.returnPair(studentChild);
            
                if isempty(keyChild)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("Datum %s could not be recognized in the key!", studentChild.name));
                        
                        % Highlight the child
                        [corner1, corner2] = hrectangleLocation(studentChild);
                        centerPos = hprincipleLocation(studentChild);
                        
                        % Yellow ish
                        mPlotRectangle(relevantSheetHandler, criterionColours.unrecognized, corner1, corner2);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos, "?",...
                            criterionColours.fontSize, 'Center',criterionColours.fontName);
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("No extra datums were found!");
                else
                    studentReport.addComment("Extra datums were found!");
                end
            end
        end
    end
end

