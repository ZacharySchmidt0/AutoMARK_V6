classdef criterionCentermarkConnectionLines < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkConnectionLines(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if lines matches key! Lines are a bitmask so this works oddly. http://help.solidworks.com/2019/english/api/swconst/SOLIDWORKS.Interop.swconst~SOLIDWORKS.Interop.swconst.swCenterMarkConnectionLine_e.html";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if keyFeature.connectionlines ~= studentFeature.connectionlines
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had correct connection lines", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" didn't have correct connection lines", studentFeature.name));
                end
            end
        end
    end
end

