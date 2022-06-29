function comparescore = compareDatum(keyDatum, studentDatum, linker)
%COMPARE Compares two datums and assigns a score for similarity
% Datums can cross link, this means that some very fancy mathematics
% happens in order to link them together which involves 3D rotations
comparescore = 100;


% Marks Lost Per / Marks Lost total
% Always lost

% Label Unequal     10 points lost

% If on the right view

% Angle         110 at 10 degrees
% Perpendicular Position 80 at 20%

% If on the wrong view

% 20 for being on the wrong view
% If there is no corresponding link, then you loose 100 marks
% Compute how the angle changes, 110 at 10 degrees
% Compute if the Position is mirrored, Postion with ,60 @ 50%



if keyDatum.label == studentDatum.label
    labelLoss = 0;
else
    labelLoss = 10;
end

keyView = keyDatum.parent;
studentView = studentDatum.parent;
studentViewPair = linker.returnPair(studentView);

keyViewDiagonal = norm([keyView.xmax - keyView.xmin, keyView.ymax - keyView.ymin]);
studentViewDiagonal = norm([studentView.xmax - studentView.xmin, studentView.ymax - studentView.ymin]);

keyDatumVector = [keyDatum.endx - keyDatum.startx, keyDatum.endy - keyDatum.starty];
studentDatumVector = [studentDatum.endx - studentDatum.startx, studentDatum.endy - studentDatum.starty];

% Transpose of the 90 degree rotation -> Does it on row vectors
rotateMatrix = [0 1; -1 0];

keyDatumPerp = perpDistance([keyDatum.startx, keyDatum.starty], [keyDatum.startx, keyDatum.starty] + keyDatumVector*rotateMatrix, [keyView.xmin, keyView.ymin]);
studentDatumPerp = perpDistance([studentDatum.startx, studentDatum.starty], [studentDatum.startx, studentDatum.starty] + studentDatumVector*rotateMatrix, [studentView.xmin, studentView.ymin]);

keyDatumPerp = keyDatumPerp/keyViewDiagonal;
studentDatumPerp = studentDatumPerp/studentViewDiagonal;

viewLoss = 0;
angleLoss = 0;
perpLoss = 0;

% If this is paired correctly
if keyView == studentViewPair
    
    % Check the angle
    angleBetween = acos(abs(dot(keyDatumVector, studentDatumVector)/(norm(keyDatumVector)*norm(studentDatumVector))));
    
    angleLoss = min(110, 100*angleBetween/0.174533);
    
    perpLoss = min(80, 60/0.2 * abs(keyDatumPerp - studentDatumPerp));
   
else
   % Figure out what happened
   
   [studentDatumFixedPosed, wasMirrored, hasPolar, wasRelated] = transformThrough(studentViewPair, keyView, studentDatumVector);
   studentDatumFixed = [studentDatumFixedPosed(1), studentDatumFixedPosed(2)];
   angleBetween = acos(abs(dot(keyDatumVector, studentDatumFixed)/(norm(keyDatumVector)*norm(studentDatumFixed))));
   
   if wasMirrored
       % Flip it around
       % Note the squareroot of two comes from perfect square shape
       % assumption in the normalization
       % This is why the perpLoss is much lower, since mirroring could do
       % some nasty things to it
       studentDatumPerp = (1/sqrt(2)) - studentDatumPerp;
   end
   
   % Pre processing is done, now assign the losses
   
   if ~wasRelated || hasPolar
       viewLoss = 110;
   else
       % You lose some for being on the wrong view
       viewLoss = 30;
   end
   
   angleLoss = min(110, 100*angleBetween/0.174533);
   
   perpLoss = min(60, 60/0.5 * abs(keyDatumPerp - studentDatumPerp));
end

comparescore = comparescore - viewLoss - angleLoss - perpLoss - labelLoss;

% Renormalize
comparescore = normalizeScore(comparescore);
end