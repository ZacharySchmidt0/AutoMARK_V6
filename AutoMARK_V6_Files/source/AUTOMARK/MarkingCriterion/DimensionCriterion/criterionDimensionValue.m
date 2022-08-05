classdef criterionDimensionValue < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDimensionValue(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if dimension is wrong, doubly wrong if two values and both incorrect";
            obj.tolerancetip = "Most dimensions contain a single value, an angle or a scalar. Chamfers contain both. The angle tolerance and linear tolerance are applied to the respective dimension types. Note: for Chamfer the angular tolerance is in degrees, for all others the angular tolerance is in radians!";
            obj.tolerance.angletolerance = 0;   % Default units
            obj.tolerance.lineartolerance = 0;  % Default units
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);

            if ~(keyFeature.chamfertextstyle == -1)
                % dimension is a chamfer, diff = the smaller of angle or
                % 180-angle
                if abs(keyFeature.dimension1value - studentFeature.dimension1value) < abs(keyFeature.dimension1value - (180 - studentFeature.dimension1value))
                    diff = keyFeature.dimension1value - studentFeature.dimension1value;
                else
                    diff = keyFeature.dimension1value - (180 - studentFeature.dimension1value);
                end
            else
                % dimension is not a chamfer
                diff = keyFeature.dimension1value - studentFeature.dimension1value;
            end
            diff2 = keyFeature.dimension2value - studentFeature.dimension2value;
            toldif = keyFeature.dimension1tolerancemax - studentFeature.dimension1tolerancemax;
            tol2dif = keyFeature.dimension2tolerancemax - studentFeature.dimension2tolerancemax;
            % Both the same, students must be the same as well!
            if (abs(keyFeature.dimension1value - keyFeature.dimension2value) < 0.0001) && keyFeature.dimension1type == keyFeature.dimension2type
                if keyFeature.dimension1type == 1
                    if abs(diff) > obj.tolerance.angletolerance || toldif ~= 0 
                        multiplier = 1;
                    end
                else
                    if abs(diff) > obj.tolerance.lineartolerance || toldif ~= 0
                        multiplier = 1;
                    end
                end
                
            else
                % Different
                
                if keyFeature.dimension1type == 1
                    if abs(diff) > abs(obj.tolerance.angletolerance) + 0.0001 || toldif ~= 0
                        multiplier = 1;
                    end
                else
                    if abs(diff) > abs(obj.tolerance.lineartolerance) + 0.0001 || toldif ~= 0
                        multiplier = 1;
                    end
                end
                
                if keyFeature.dimension2type == 1
                    if abs(diff2) > abs(obj.tolerance.angletolerance) + 0.0001 || tol2dif ~= 0
                        multiplier = multiplier + 1;
                    end
                else
                    if abs(diff2) > abs(obj.tolerance.lineartolerance) + 0.0001 || tol2dif ~= 0
                        multiplier = multiplier + 1;
                    end
                end
            end
            
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Dimension ""%s"" had the correct value!", studentFeature.name));
                else
                    
                    % Clean dimension text
                    if keyFeature.dimension1type == 1 % Angular
                         dim1valclean = sprintf('%.0f°', rad2deg(keyFeature.dimension1value));
                    else
                        % Linear
                        dim1valclean = sprintf('%g', keyFeature.dimension1value);
                    end
                    
                    % Clean dimension text
                    if keyFeature.dimension2type == 1 % Angular
                        dim2valclean = sprintf('%.0f°', rad2deg(keyFeature.dimension2value));
                    else
                        % Linear
                        dim2valclean = sprintf('%g', keyFeature.dimension2value);
                    end
                    
                    % Chamfer's are odd
                    % dim1 is the angle, dim2 is the length of the
                    % hypotenuse
                    if keyFeature.type == 10
                        dim1valclean = sprintf('%g', abs(round(cos(deg2rad(keyFeature.dimension1value))*keyFeature.dimension2value)));
                        dim2valclean = sprintf('%g°', keyFeature.dimension1value);
                    end
                    
                    if keyFeature.dimension1value == keyFeature.dimension2value && keyFeature.dimension1type == keyFeature.dimension2type
                        % Both the same
                        studentReport.addComment(sprintf("Dimension ""%s"" didn't have the correct value, had (%g) expected (%g)", studentFeature.name, studentFeature.dimension1value, keyFeature.dimension1value));
                        mPlotText(relevantSheetHandler, criterionColours.value, hprincipleLocation(studentFeature),...
                            sprintf("[%s]", dim1valclean), criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
                        if toldif ~= 0 || tol2dif ~= 0
                            mPlotText(relevantSheetHandler, criterionColours.value,...
                                hprincipleLocation(studentFeature), sprintf("Incorrect tolerance"),...
                                criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                        end
                    else % Different
                        studentReport.addComment(sprintf("Dimension ""%s"" didn't have the correct value, had (%g, %g) expected (%g, %g)", studentFeature.name, studentFeature.dimension1value, studentFeature.dimension2value, keyFeature.dimension1value, keyFeature.dimension2value));
                        mPlotText(relevantSheetHandler, criterionColours.value, hprincipleLocation(studentFeature),...
                            sprintf("[%s %s]", dim1valclean, dim2valclean),...
                            criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
                        if toldif ~= 0 || tol2dif ~= 0
                            mPlotText(relevantSheetHandler, criterionColours.value, hprincipleLocation(studentFeature),...
                                sprintf("Incorrect tolerance"),criterionColours.fontSize, 'CenterTop',...
                                criterionColours.fontName);
                        end
                    end
                end
            end
        end
    end
end

