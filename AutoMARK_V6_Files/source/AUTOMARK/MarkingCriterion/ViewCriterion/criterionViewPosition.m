classdef criterionViewPosition < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionViewPosition(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if inside circle, with given radius!";
            obj.tolerancetip = "The circle size is given in units of sheet width so that it scales with the sheet size";
            obj.tolerance.radius = 0.025; % 10% of the width!
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            [keyCorner1, keyCorner2] = hrectangleLocation(keyFeature);
            [stuCorner1, stuCorner2] = hrectangleLocation(studentFeature);
            
            keyCenter = (keyCorner1 + keyCorner2)/(2*keyFeature.parent.width);
            stuCenter = (stuCorner1 + stuCorner2)/(2*studentFeature.parent.width);
            
            stuTokey = keyCenter - stuCenter;
            
            if norm(stuTokey) > obj.tolerance.radius
                multiplier = 1;
            end
            
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("View ""%s"" was in a suitable location", studentFeature.name));
                else
                    studentReport.addComment(sprintf("View ""%s"" wasn't in a suitable location", studentFeature.name));

                    shouldHaveBeen = (stuCenter + stuTokey) * studentFeature.parent.width;
                    % Green ish
                    % mPlotCircle(relevantSheetHandler, criterionColours.position, shouldHaveBeen, obj.tolerance.radius * relevantSheetHandler.image_width);
                    mPlotText(relevantSheetHandler, criterionColours.position,...
                        stuCenter * studentFeature.parent.width, sprintf("Bad View\nPlacement"),...
                        criterionColours.fontSize, 'CenterTop',criterionColours.fontName);
                    mPlotArrow(relevantSheetHandler, criterionColours.position, stuCenter * studentFeature.parent.width, shouldHaveBeen);
                end
            end
        end
        
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler, criterionColours)
            % Function which deals with the tolerancing display on the
            % marking GUI
            radius = keyFeature.parent.width * obj.tolerance.radius;
            [c1, c2] = hrectangleLocation(keyFeature);
            
            
            gfxobjects = hPlotCircle(relevantSheetHandler, criterionColours.position, (c1 + c2)./2, radius);
            gfxobjects = [gfxobjects,hPlotCross(relevantSheetHandler, criterionColours.position, (c1 + c2)./2, 0.01)];
            
        end
        
        function onClickRespond(obj, keyFeature, clickLocation)
            % Respond to clicks on the UI figure, very useful for tolerance
            % boxes and what not.
            
            % This is the "Circle Size"
            
            % If we got exactly 2 points
            
            if size(clickLocation,1) >= 1
                radius = norm(hprincipleLocation(keyFeature) - clickLocation(1, 1:2))/keyFeature.parent.width;
                obj.tolerance.radius = radius;
            end
        end
    end
end

