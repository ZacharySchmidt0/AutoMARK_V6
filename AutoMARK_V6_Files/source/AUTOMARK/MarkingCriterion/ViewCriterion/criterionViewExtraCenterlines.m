classdef criterionViewExtraCenterlines < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewExtraCenterlines(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra centerlines on a view";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if all views on student link.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            for i = 1:studentFeature.numcenterlines
                % there are bugged empty centerlines and they get counted
                % in studentFeature.numcenterlines but dont 
                % exist in studentFeature.childcenterlines so no marks will
                % be deducted for these cuz I dont know what they are
                try
                    studentChild = studentFeature.childcenterlines(i);
                catch
                    continue;
                end
                keyChild = linker.returnPair(studentChild);
                
                if isempty(keyChild)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("Centerline %s could not be recognized in the key!", studentChild.name));
                        
                        % Highlight the child, in this case its a line with
                        % a ?
                        % ontop (its actually shifted 1.5 mm, 0.0015 to the side and down so you can see it!)
                        
                        centerPos = hprincipleLocation(studentChild);
                        
                        % Yellow ish
                        mPlotLine(relevantSheetHandler, criterionColours.unrecognized, [studentChild.startx, studentChild.starty], [studentChild.endx, studentChild.endy]);
                        mPlotText(relevantSheetHandler, criterionColours.unrecognized, centerPos + [0.0015, -0.0015],...
                            "?", criterionColours.fontSize, 'LeftTop',criterionColours.fontName);
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("No extra centerlines were found!");
                else
                    studentReport.addComment("Extra centerlines were found!");
                end
            end
        end
    end
end

