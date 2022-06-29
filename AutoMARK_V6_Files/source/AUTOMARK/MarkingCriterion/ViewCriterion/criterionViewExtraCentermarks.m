classdef criterionViewExtraCentermarks < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewExtraCentermarks(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra centermarks on a view";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if all views on student link.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            for i = 1:studentFeature.numcentermarks
                
                studentChild = studentFeature.childcentermarks(i);
                keyChild = linker.returnPair(studentChild);
                
                % We don't have a key pair and we ARENT deleted!
                if isempty(keyChild) && ~(studentChild.isdeleted)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("Centermark %s could not be recognized in the key!", studentChild.name));
                        
                        % Highlight the child, in this case its just a
                        % circle around the center and a ? in it.
                        centerPos = hprincipleLocation(studentChild);
                        
                        % Yellow ish
                        mPlotCircle(relevantSheetHandler, criterionColours.unrecognized, centerPos, 45);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos, "?",...
                            criterionColours.fontSize, 'Center',criterionColours.fontName);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos, "Extra Centermark",...
                            criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("No extra Centermarks were found!");
                else
                    studentReport.addComment("Extra Centermarks were found!");
                end
            end
        end
    end
end

