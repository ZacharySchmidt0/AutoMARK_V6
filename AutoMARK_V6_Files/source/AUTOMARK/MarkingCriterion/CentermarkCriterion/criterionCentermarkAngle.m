classdef criterionCentermarkAngle < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionCentermarkAngle(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the angle of the centermark matches";
            obj.tolerancetip = "Angle in degrees, +/-, but we allow +/- epsilon = 0.00001 regardless";
            obj.tolerance.tolerance = 2;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if showlines == others showlines
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if abs(keyFeature.rotationangle - studentFeature.rotationangle) > abs(deg2rad(obj.tolerance.tolerance)) + 0.000001
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Centermark ""%s"" had correct angle", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Centermark ""%s"" didn't have correct angle", studentFeature.name));
                end
            end
        end
    end
end

