function [corner1, corner2] = bomBox(bomtable, startrow, endrow, startcolumn, endcolumn)
%BOMBOX Tells you the location of a box around a particular range of rows
%and columns.

% Minimum X
x0 = bomtable.xmin;
for i = 1:(startcolumn - 1)
    x0 = x0 + bomtable.colwidths(i);
end

% Maximum X
x1 = bomtable.xmin;
for i = 1:endcolumn
    x1 = x1 + bomtable.colwidths(i);
end

% Maximum Y
y1 = bomtable.ymax;
for i = 1:(startrow - 1)
    y1 = y1 - bomtable.rowheights(i);
end

% Minimum Y
y0 = bomtable.ymax;
for i = 1:(endrow)
    y0 = y0 - bomtable.rowheights(i);
end

corner1 = [x0 y0];
corner2 = [x1 y1];
end