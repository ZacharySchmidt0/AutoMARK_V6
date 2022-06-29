classdef criterionBOMPosition < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionBOMPosition(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if inside circle, with given radius!";
            obj.tolerancetip = "The circle size is given in units of sheet width so that it scales with the sheet size. Position is given as the top right corner.";
            obj.tolerance.radius = 0.5*0.4318/4080; % About half a pixel
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
            
            keyTopRight = max(keyCorner1, keyCorner2);
            stuTopRight = max(stuCorner1, stuCorner2);
            
            keyTopRight = keyTopRight ./ keyFeature.parent.width;
            stuTopRight = stuTopRight ./ studentFeature.parent.width;
            
            stuToKey = keyTopRight - stuTopRight;
            
            if norm(stuToKey) > obj.tolerance.radius
                multiplier = 1;
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Table ""%s"" was in a suitable location", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                              mPlotText(relevantSheetHandler, criterionColours.correct, stuTopRight * studentFeature.parent.width, 'Snapped to Corner',...
                        criterionColours.fontSize, 'RightBottom', criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, stuTopRight * studentFeature.parent.width, 'Snapped to Corner',...
                        criterionColours.fontSize, 'RightBottom', criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("Table ""%s"" wasn't in a suitable location", studentFeature.name));
                    
                    
                    mPlotText(relevantSheetHandler, criterionColours.position, stuTopRight * studentFeature.parent.width, 'Not Snapped to Corner',...
                        criterionColours.fontSize, 'RightBottom', criterionColours.fontName);
                end
            end
        end
        
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler, criterionColours)
            % Function which deals with the tolerancing display on the
            % marking GUI
            radius = keyFeature.parent.width * obj.tolerance.radius;
            [c1, c2] = hrectangleLocation(keyFeature);
            
            topRight = max([c1;c2]);
            
            gfxobjects = hPlotCircle(relevantSheetHandler, criterionColours.position, topRight, radius);
        end
        
        function onClickRespond(obj, keyFeature, clickLocation)
            % Respond to clicks on the UI figure, very useful for tolerance
            % boxes and what not.
            
            % This is the "Circle Size"
            
            % If we got exactly 2 points
            
            if size(clickLocation,1) >= 1
                
                [c1, c2] = hrectangleLocation(keyFeature);
                topRight = max([c1;c2]);
            
                radius = norm(topRight - clickLocation(1, 1:2))/keyFeature.parent.width;
                obj.tolerance.radius = radius;
            end
        end
    end
end

