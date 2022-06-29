function outputLocation = moveRelativeToView(inputLocation, view1, view2)
%MOVERELATIVETOVIEW Move a coordinate from view1 to view2. Computes
% scale and whatnot to move accurately.
% Instead of passing a literal view, you can instead pass the ratio and
% position of the view instead. As a vector of three numbers as [x, y, scale]

if class(view1) == "comparableView"
    view1 = [(view1.xmin + view1.xmax)/2, (view1.ymin + view1.ymax)/2, view1.scale1 / view1.scale2];
end

if class(view2) == "comparableView"
    view2 = [(view2.xmin + view2.xmax)/2, (view2.ymin + view2.ymax)/2, view2.scale1 / view2.scale2];
end

outputLocation = view2(1:2) + (inputLocation - view1(1:2)) * view2(3)/view1(3);
end

