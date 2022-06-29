% This script will plot coordinates onto an image, This is useful for
% testing because the API is very poorly documented occasionally.

% Get the image
[imgfile, path] = uigetfile("*");
img = imread([path imgfile]);

% Plot the image
imshow(img)


% Get the image dimensions
yPix = size(img,1);
xPix = size(img,2);

% As use for image dimensions in mm
xLength = double(input("How wide is the image (mm)?: "));
yLength = double(input("How tall is the image (mm)?: "));

% Pixels Per MM
% Min because the image is given by the smallest such box
pixScale = min(xPix/xLength, yPix/yLength);


% Compute Paddings
yPad = (yPix - yLength*pixScale)/2;
xPad = (xPix - xLength*pixScale)/2;


% Small circles
circleradius = xPix / 200;


% Loop forever, plotting points on the image
while true
    vect = input("Enter a 2 Vector for a point or a 4 Vector for a line");
    if length(vect) == 2
        pX = int32(vect(1)*pixScale + xPad);
        pY = yPix - int32(vect(2)*pixScale + yPad);
        plotCross(pX, pY, circleradius);
    elseif length(vect) == 4
        pX1 = int32(vect(1)*pixScale + xPad);
        pY1 = yPix - int32(vect(2)*pixScale + yPad);
        pX2 = int32(vect(3)*pixScale + xPad);
        pY2 = yPix - int32(vect(4)*pixScale + yPad);
        line([pX1 pX2], [pY1 pY2], 'Color', 'Red');
        plotCross(pX1, pY1, circleradius/3);
        plotCross(pX2, pY2, circleradius/3);
    end
end

% Simple helper function
function [x, y] = convert(x, y)
    x = int32(x*pixScale + xPad);
    y = yPix - int32(y*pixScale + yPad);
end
