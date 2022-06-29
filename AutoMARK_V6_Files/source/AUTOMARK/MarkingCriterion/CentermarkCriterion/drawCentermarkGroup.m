function drawCentermarkGroup(stuCenter, keyCenter, iHandler, colour)
%DRAWCENTERMARKGROUP Draws up a centermark group!

if keyCenter.style == 3
   % Linear group , complicated nonsense.
   % For each of the cardinal directions, rotate them by the angle of the
   % centermark.
   
   angl = keyCenter.rotationangle;
   
   % This is backwards, but it doesn't matter because Matlabs base
   % direction for these things is very odd.
   
   % If the angle is zero, this is straight up and down, and it rotates
   % ccw which is actually how solidworks does it
   cardinal = [-sin(angl), cos(angl)];
   
   % Draw every one
   for i = 1:4
       cardinal = [-cardinal(2), cardinal(1)];
        
       friend = findAppropriateInDirection(keyCenter, cardinal);
       
       % Draw a line
       if ~isempty(friend)
           
           % This is how it is in solidworks I divided by 2 since thats the
           % first dot
           gap = keyCenter.size + (keyCenter.gap)/2;
           
           p1 = hprincipleLocation(keyCenter);
           p2 = hprincipleLocation(friend);
           
           % Shrunk
           p1s = p1 + (p2 - p1)/norm(p2 - p1) * gap;
           p2s = p2 + (p1 - p2)/norm(p2 - p1) * gap;
           
           % Plot a line
           mPlotLine(iHandler, colour, moveRelativeToView(p1s, keyCenter.parent, stuCenter.parent), moveRelativeToView(p2s, keyCenter.parent, stuCenter.parent));
       end
   end
   
elseif keyCenter.style == 4
    % Circular group, just draw the circle
    
    pos = zeros(keyCenter.groupcount, 2);
    
    % Construct a vector of points
    for i = 1:numel(keyCenter.group)
        c = keyCenter.group(i);
        pos(i, :) = hprincipleLocation(c);
    end
    
    [origin, radius] = findCircleGivenPoints(pos);
    
    origin = moveRelativeToView(origin, keyCenter.parent, stuCenter.parent);
    
    % Figure out the radius in pixels on the student sheet, does 2
    % transforms.
    pos1 = moveRelativeToView([0, 0], keyCenter.parent, stuCenter.parent);
    pos2 = moveRelativeToView([0, radius], keyCenter.parent, stuCenter.parent);
    
    [x1, y1] = iHandler.sheetToImage(pos1(1), pos1(2));
    [x2, y2] = iHandler.sheetToImage(pos2(1), pos2(2));
    
    radius = norm([x1 - x2, y1 - y2]);
    
    mPlotCircle(iHandler, colour, origin, radius);
end

    function friend = findAppropriateInDirection(centermark, direction)
        % Given a centermark, and a direction. See if there is a centermark
        % in the group in that direction which isn't us.
        
        friend = [];
        
        bestdistance = inf;
        
        % For all the centermarks in the group
        for j = 1:numel(centermark.group)
            cf = centermark.group(j);
            
            % Other than us
            if cf == centermark
                continue
            end
            
            % Compute Vector from us to them.
            v = hprincipleLocation(cf) - hprincipleLocation(centermark);
            cosTheta = dot(v, direction)/(norm(v) * norm(direction));
            
            % If the angle is correct (1 degree)
            if cosTheta > 0.9998
                
                % If this is our closest neighbour
                if norm(v) < bestdistance
                    
                    % This is the new best candidate.
                    bestdistance = norm(v);
                    friend = cf;
                end
            end
        end
    end
end

