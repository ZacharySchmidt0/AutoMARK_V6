function comparescore = compareViews(keyView, studentView)
%COMPAREVIEWS Compares two views and assigns a score for similarity

% Marks Lost Per / Marks Lost total
% position       40 @ Half the Width of the Sheet
% view type      10
% scale          10
% tangent lines  5
% display style  15
% dimensions     2/10
% centerlines    2/10
% centermarks    2/10
% datums         5/10
% balloons       4/20
% solid model    30
% aspect ratio   15 @ 5 degrees

comparescore = 100;

% Relative postions of the views
keyRelPos = hprincipleLocation(keyView)/keyView.parent.width;
stuRelPos = hprincipleLocation(studentView)/studentView.parent.width;

% Linear loss, upto 40 when its very far away.
positionLoss = min(40, 80*norm(keyRelPos - stuRelPos));

% This is where is is quite unfortunate that matlab does not have a ternary
% operator.

if keyView.viewtype == studentView.viewtype
    typeLoss = 0;
else
    typeLoss = 10;
end

if keyView.scale1 == studentView.scale1 && keyView.scale2 == studentView.scale2
    scaleLoss = 0;
else
    scaleLoss = 10;
end

if keyView.tangentlines == studentView.tangentlines
    tangentLoss = 0;
else
    tangentLoss = 5;
end

if keyView.displaystyle == studentView.displaystyle
    displayLoss = 0;
else
    displayLoss = 15;
end

dimensionLoss = min(10, 2*abs(keyView.numdims - studentView.numdims));

centerlineLoss = min(10, 2*abs(keyView.numcenterlines - studentView.numcenterlines));

centermarkLoss = min(10, 2*abs(keyView.numcentermarks - studentView.numcentermarks));

datumLoss = min(10, 5*abs(keyView.numdatums - studentView.numdatums));

balloonLoss = min(20, 4*abs(keyView.numballoons - studentView.numballoons));

solidmodelLoss = 30 * (100 - compareSolidModel(keyView.childsolidmodel, studentView.childsolidmodel))/100;

% 0.0872665 is 5 degrees
aspectratioLoss = max(15, 15 * abs(atan2(keyView.ymax - keyView.ymin, keyView.xmax - keyView.xmin) - atan2(studentView.ymax - studentView.ymin, studentView.xmax - studentView.xmin))/0.0872665);

comparescore = comparescore - positionLoss - typeLoss - scaleLoss - tangentLoss - displayLoss - dimensionLoss - centerlineLoss - centermarkLoss - datumLoss - balloonLoss - solidmodelLoss - aspectratioLoss;

% New ->
%
% Recursively see how well the centermarks and centerlinks link up as well
centermarkcomp = compareMatrix(keyView.childcentermarks, studentView.childcentermarks, @compareCentermark);
[~, centermarkscore] = pairwisePeaks(centermarkcomp);

centerlinecomp = compareMatrix(keyView.childcenterlines, studentView.childcenterlines, @compareCenterline);
[~, centerlinescore] = pairwisePeaks(centerlinecomp);

% 15 loss for centermarks, 15 for centerlines, but give them a bonus 20 to
% start with
comparescore = comparescore + 20 - 15*(100-normalizeScore(centermarkscore))/100 - 15*(100-normalizeScore(centerlinescore))/100;

% Renormalize
comparescore = normalizeScore(comparescore);
end

