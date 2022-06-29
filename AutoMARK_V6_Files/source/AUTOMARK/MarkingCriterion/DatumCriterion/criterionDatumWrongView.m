classdef criterionDatumWrongView < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDatumWrongView(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if on the same view as the key, wrong if not, Note position will also be wrong usually!";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            % Parent View of Datum
            studentDatumViewPair = linker.returnPair(studentFeature.parent);
            
            if studentDatumViewPair ~= keyFeature.parent
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Datum ""%s"" was on the correct view", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Datum ""%s"" wasn't on the correct view", studentFeature.name));

                    % Draw an arrow from the datum to the place it was
                    % supposed to be.
                    
                    keyViewPair = linker.returnPair(keyFeature.parent);
                    
                    keyViewPair = linker.returnPair(keyFeature.parent);
                    
                    if isempty(keyViewPair)
                        % This actually cannot happen, the reasoning is non
                        % trivial, but if the key view pair doesn't
                        % actually exist, then this Dimension never got marked!                   
                        % assert(false)
                        
                        % We just set the 'student View' to us.
                        
                        mCreateFeature(relevantSheetHandler, criterionColours.position, keyFeature, keyFeature.parent, criterionColours);
                        endPos = hprincipleLocation(keyFeature);
                    else
                        mCreateFeature(relevantSheetHandler, criterionColours.position, keyFeature, keyViewPair, criterionColours);
                        endPos = moveRelativeToView(hprincipleLocation(keyFeature), keyFeature.parent, keyViewPair);
                    end
                    mPlotArrow(relevantSheetHandler, criterionColours.position, hprincipleLocation(studentFeature), endPos);
                end
            end
        end
    end
end

