function intersectionPoints = findAllIntersections(lineData)
%FINDALLINTERSECTIONS Find where lines intersect other lines

% lineData is formatted as follows:
% [number of points, point1x, point1y, point2x, point2y, etc....]
% This continues downwards for each point

intersectionPoints = double.empty(0,2);

for lnumber = 1:size(lineData, 1)
    l1points = lineData(lnumber, 1);
    l1 = lineData(lnumber, 2:1+l1points*2);
    
    % For all ahead of this one
    for l2number = lnumber+1:size(lineData, 1)
        
        l2points = lineData(l2number, 1);
        l2 = lineData(l2number, 2:1+l2points*2);
        
        intersectionPoints = [intersectionPoints; intersectingPairs(l1, l2)];
    end
end

    % Internal Function, find all intersections between just two lines
    function intPoints = intersectingPairs(lines1, lines2)
        % Lines are formated, [point1x, point1y, point2x, point2y, etc]
        
        intPoints = double.empty(0,2);
        % Go by twos, except the end
        for i = 1:2:numel(lines1)-2
            for j = 1:2:numel(lines2)-2
                newPoints = intersect(lines1(i+0), lines1(i+1), lines1(i+2), lines1(i+3), lines2(j+0), lines2(j+1), lines2(j+2), lines2(j+3));
                intPoints = [intPoints; newPoints];
            end
        end
        
        % Internal^2 Function, find all intersections between just two
        % lines (segments)
        % given by 4 points only.
        % No Solution -> intpoint is empty 0 by 2
        % 1 Solution -> intpoint is the solution, x y
        % infinite solutions -> intpoint is the midpoint of the infinite
        % solutions
        function intPoint = intersect(x0, y0, x1, y1, x2, y2, x3, y3)
            
            % First find the equations which define the two lines
            % ax + by = c

            a1 = y0 - y1;
            b1 = x1 - x0;
            c1 = x1*y0 - x0*y1;
            
            a2 = y2 - y3;
            b2 = x3 - x2;
            c2 = x3*y2 - x2*y3;
            
            % Now try to solve the system [a1 b1; a2 b2]*[x;y] = [c1;c2]
            
            % Determinant
            d = a1*b2 - a2*b1;
            
            if abs(d) < 0.000001
                % No solutions or infinite solutions
                if abs(c1 - c2) < 0.000001
                    % Infinite solutions, lines might be spaced or are
                    % overlapping
                    
                    if iswithin(x2, x0, x1) || iswithin(x3, x0, x1) || iswithin(x0, x2, x3) || iswithin(x1, x2, x3)
                        if iswithin(y2, y0, y1) || iswithin(y3, y0, y1) || iswithin(y0, y2, y3) || iswithin(y1, y2, y3)
                            intPoint = [(x0 + x1 + x2 + x3)/4, (y0 + y1 + y2 + y3)/4];
                        end
                    else
                        % No overlap
                        intPoint = double.empty(0,2);
                    end
                    
                else
                    % No solutions, Empty
                    intPoint = double.empty(0,2);
                end
            else
                xsol = (c1*b2 - c2*b1)/d;
                ysol = (c2*a1 - c1*a2)/d;
                
                % If its inside of the four lines
                if iswithin(xsol, x0, x1) && iswithin(xsol, x2, x3) && iswithin(ysol, y0, y1) && iswithin(ysol, y2, y3)
                    intPoint = [xsol, ysol];
                else
                    intPoint = double.empty(0,2);
                end
            end
            
            
            % Innermost function, is within.
            function wasBetween = iswithin(x, x1, x2)
                % True if
                % x1 <= x <= x2 OR
                % x2 <= x <= x1
                
                wasBetween = ((x1 <= x) && (x <= x2)) || ((x2 <= x) && (x <= x1));
            end
        end
    end
end

