classdef criterionDimensionWrongView < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDimensionWrongView(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if on the same view as the key, wrong if not";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            % Parent View of Dimension
            studentDimensionPair = linker.returnPair(studentFeature.parent);
            
            if studentDimensionPair ~= keyFeature.parent
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Dimension ""%s"" was on the correct view", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Dimension ""%s"" wasn't on the correct view", studentFeature.name));

                    % Draw an arrow from the Dimension to the place it was
                    % supposed to be.
                    
                    keyViewPair = linker.returnPair(keyFeature.parent);
                    
                    if isempty(keyViewPair)
                        % This actually cannot happen, the reasoning is non
                        % trivial, but if the key view pair doesn't
                        % actually exist, then this Dimension never got marked!                   
                        % assert(false)
                        
                        % We just set the 'student View' to us.
                        
                        mCreateFeature(relevantSheetHandler, criterionColours.position, keyFeature, keyFeature.parent, keyViewPair, criterionColours);
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

