classdef criterionCentermarkGroupedCorrectly < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkGroupedCorrectly(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the centermark group this belongs to is bijective (by the linker) to the keys";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if showlines == others showlines
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            keyGroup = keyFeature.group;
            stuGroup = studentFeature.group;
            
            % Correctly being grouped means the groups are bijections
            if studentFeature.groupcount ~= keyFeature.groupcount
                multiplier = 1;  % If different group counts, its definitely not grouped correctly
            else
                for k = 1:numel(keyGroup)  
                    % If the i'th key groups pair isn't in the stuGroup
                    if ~ismember(linker.returnPair(keyGroup(k)), stuGroup)
                        % Its not grouped properly
                        multiplier = 1;
                        break;
                    end
                end
                
                % Don't need to check the other way, the linker is one to
                % one so being injective implies being a bijection.
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had correct grouping", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" had bad grouping", studentFeature.name));
                    
                    drawCentermarkGroup(studentFeature, keyFeature, relevantSheetHandler, criterionColours.missing);
                end
            end
        end
    end
end

