function comparescore = compareCenterline(keycenterline, studentcenterline)
%COMPARE Compares two centerlines and assigns a score for similarity
comparescore = 100;

% Marks Lost Per / Marks Lost total
% Angle Between    100 marks lost at 25 degree difference.
% Length                 60 @ 60%
% Position Metric (perpendicular distance to the corner)  100 marks at 20%
% Parallel Metric (parallel distance to the corner)  20 marks at 30%

% Compute the vector from start to end -> needed for angles
keyVector = [keycenterline.endx - keycenterline.startx, keycenterline.endy - keycenterline.starty];
try
studentVector = [studentcenterline.endx - studentcenterline.startx, studentcenterline.endy - studentcenterline.starty];
catch
end
% Use dotproducts for angle
angleBetween = acos(abs(dot(keyVector, studentVector)/(norm(keyVector)*norm(studentVector))));

% 25 degrees is 0.436332 radians
angleLoss = min(100, 100*angleBetween/0.436332);


% The length difference is measured proportional to the diagonal of the
% view.
keyView = keycenterline.parent;
studentView = studentcenterline.parent;

keyViewDiagonal = norm([keyView.xmax - keyView.xmin, keyView.ymax - keyView.ymin]);
studentViewDiagonal = norm([studentView.xmax - studentView.xmin, studentView.ymax - studentView.ymin]);

normalizedkeyVector = keyVector/keyViewDiagonal;
normalizedstudentVector = studentVector/studentViewDiagonal;

lengthLoss = min(60, 60/0.6*abs(norm(normalizedkeyVector) - norm(normalizedstudentVector)));


% Now compute perpendicular distance from the corner, normalized to the
% diagonal
[keyPerpDistance, keyParDist] = perpDistance([keycenterline.startx, keycenterline.starty], [keycenterline.endx, keycenterline.endy], [keyView.xmin, keyView.ymin]);
[studentPerpDistance, studentParDist] = perpDistance([studentcenterline.startx, studentcenterline.starty], [studentcenterline.endx, studentcenterline.endy], [studentView.xmin, studentView.ymin]);

keyPerpDistance = keyPerpDistance / keyViewDiagonal;
keyParDist = keyParDist / keyViewDiagonal;

studentPerpDistance = studentPerpDistance / studentViewDiagonal;
studentParDist = studentParDist / studentViewDiagonal;

posLossPerp = min(100, 100/0.2 * abs(keyPerpDistance - studentPerpDistance));

posLossPar = min(20, 100/0.3 * abs(keyParDist - studentParDist));

comparescore = comparescore - angleLoss - lengthLoss - posLossPerp - posLossPar;

% Renormalize
comparescore = normalizeScore(comparescore);
end