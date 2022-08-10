classdef criterionFeatureDangling < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionFeatureDangling(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if not dangling";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if not dangling
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if studentFeature.isdangling
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("%s %s was properly attached!", studentFeature.commonTypeName, studentFeature.name));
                else
                    studentReport.addComment(sprintf("%s %s was found to be dangling!", studentFeature.commonTypeName, studentFeature.name));
                    
                    textLoc = hprincipleLocation(studentFeature);
                    
                    % Small Purple Text, Says dangling.
                    mPlotText(relevantSheetHandler, criterionColours.misc, textLoc, 'Dangling', criterionColours.fontSize, 'CenterBottom'...
                        ,criterionColours.fontName);
                end
            end
        end
    end
end

