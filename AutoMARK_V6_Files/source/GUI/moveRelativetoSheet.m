function outputLocation = moveRelativetoSheet(inputLocation, sheet1, sheet2)
%MOVERELATIVETOVIEW Move a coordinate from one sheet to another. Computes
% scale and whatnot to move accurately.
% Instead of passing literal sheets, you can just pass sheet width and
% height as [width, height]

if class(sheet1) == "comparableSheet"
    sheet1 = [sheet1.width, sheet1.height];
end

if class(sheet2) == "comparableSheet"
    sheet2 = [sheet2.width, sheet2.height];
end

% Scale everything around on the view!
outputLocation = [inputLocation(:, 1) * sheet2(1) / sheet1(1), inputLocation(:, 2) * sheet2(2) / sheet1(2)] ;
end

