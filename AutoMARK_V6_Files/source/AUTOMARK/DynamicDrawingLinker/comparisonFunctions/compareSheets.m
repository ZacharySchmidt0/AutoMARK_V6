function comparescore = compareSheets(keySheet, studentSheet)
%COMPARESHEETS Compares how "similar" two different sheets and returns it
% as a numeric score
% May or may not be a symetric function. f(A,B) = f(B,A)

% Start out with 100 score, loosing marks for various problems.
comparescore = 100;

% Marks Lost Per / Marks Lost total
% num views     30/60
% balloons      5/30
% dimensions    4/20
% centerlines   2/15
% centermarks	2/15
% datums        2/6
% bom           25/25
% view recursive matching 50

lossViews = min(60, 30*abs(keySheet.numviews - studentSheet.numviews));

lossBalloons = min(30, 5*abs(keySheet.numtotalballoons - keySheet.numballoons - (studentSheet.numtotalballoons - studentSheet.numballoons)));

lossDimensions =  min(12, 4*abs(keySheet.numtotaldims - studentSheet.numtotaldims));

lossCenterlines = min(12, 2*abs(keySheet.numtotalcenterlines - studentSheet.numtotalcenterlines));

lossCentermarks = min(12, 2*abs(keySheet.numtotalcentermarks - studentSheet.numtotalcentermarks));

lossDatums = min(6, 2*abs(keySheet.numtotaldatums - studentSheet.numtotaldatums));

lossBOM = min(25, 25*abs(length(keySheet.childboms) - length(studentSheet.childboms)));

comparescore = comparescore - lossViews - lossDimensions - lossCenterlines - lossCentermarks - lossDatums - lossBalloons - lossBOM;

viewComp = compareMatrix(keySheet.childviews, studentSheet.childviews, @compareViews);
% viewScore is the average score, it gets computed during the process.
[~, viewScore] = pairwisePeaks(viewComp);

comparescore = comparescore - 30*(100-viewScore)/100;

% Renormalize
comparescore = normalizeScore(comparescore);
end

