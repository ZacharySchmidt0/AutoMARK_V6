classdef criterionSheetIntersectingBalloons < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetIntersectingBalloons(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Wrong for each balloon intersection";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if no intersections
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            %             % For now, just highlight all the balloon things
            %             for i = 1:numel(studentFeature.childballoons)
            %                 balloon = studentFeature.childballoons(i);
            %
            %                 if strcmp(balloon.isbomballoon, 'true')
            %
            %                     bData = [balloon.centerx, balloon.centery;
            %                         balloon.attachx, balloon.attachy;
            %                         balloon.annx, balloon.anny;
            %                         balloon.point1x, balloon.point1y;
            %                         balloon.point2x, balloon.point2y;
            %                         balloon.point3x, balloon.point3y];
            %
            %                     % Red
            %                     mPlotCircle(relevantSheetHandler, criterionColours.missing, bData, 4);
            %                 end
            %             end
            
            numballoons = 0;
            
            for i = 1:numel(studentFeature.childballoons)
                if strcmp(studentFeature.childballoons(i).isbomballoon, 'true')
                    numballoons = numballoons + 1;
                end
            end
            
            % 1 + 6 because its how it works
            balloonLineData = zeros(numballoons, 1 + 6);
            
            j = 0;
            for i = 1:numel(studentFeature.childballoons)
                b = studentFeature.childballoons(i);
                if strcmp(b.isbomballoon, 'true')
                    
                    j = j + 1;
                    balloonLineData(j, 1) = b.leaderpoints;
                    
                    if b.leaderpoints > 0
                        balloonLineData(j, 2) = b.point1x;
                        balloonLineData(j, 3) = b.point1y;
                    end
                    
                    if b.leaderpoints > 1
                        balloonLineData(j, 4) = b.point2x;
                        balloonLineData(j, 5) = b.point2y;
                    end
                    
                    if b.leaderpoints > 2
                        balloonLineData(j, 6) = b.point3x;
                        balloonLineData(j, 7) = b.point3y;
                    end
                end
            end
            
            bIntersections = findAllIntersections(balloonLineData);
            
            multiplier = size(bIntersections, 1);
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Balloon lines did not intersect!"));
                else
                    studentReport.addComment(sprintf("%d intersecting balloon lines were found!", multiplier));
                    
                    
                    % Take the average of the positions
                    avPos = sum(bIntersections, 1)/size(bIntersections,1);
                    
                    % Position of intersection highlighted.
                    mPlotCircle(relevantSheetHandler, criterionColours.position, bIntersections, 10);
                    
                    % Write text in the center saying its wrong
                    mPlotText(relevantSheetHandler, criterionColours.position, avPos, 'Interesecting Balloons',...
                        criterionColours.fontSize, 'CenterBottom',criterionColours.fontName);
                end
            end
        end
    end
end

