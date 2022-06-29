function wasInside = insideRectangles(position, rectangles)
%INSIDERECTANGLES position given as x y, rectangles given as x0, y0, x1, y1
% in columns.

xmins = min(rectangles(:,1), rectangles(:,3));
xmaxs = max(rectangles(:,1), rectangles(:,3));

ymins = min(rectangles(:,2), rectangles(:,4));
ymaxs = max(rectangles(:,2), rectangles(:,4));

xmingreater = position(1) >= xmins;
xmaxless    = position(1) <= xmaxs;

ymingreater = position(2) >= ymins;
ymaxless    = position(2) <= ymaxs;


% If any row is all true then it is inside at least one of the rectangles!
wasInside = any(all([xmingreater, xmaxless, ymingreater, ymaxless], 2));

end

