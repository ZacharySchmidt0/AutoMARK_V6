function plotCross(x,y, radius)
%PLOTCROSS Plots a cross of radius R onto the sheet

    x0 = x - radius;
    x1 = x + radius;
    
    y0 = y - radius;
    y1 = y + radius;
    
    % One diagonal
    line([x0 x1], [y0 y1], 'Color', 'Red')
    
    % Other diagonal
    line([x1 x0], [y0 y1], 'Color', 'Red')
end

