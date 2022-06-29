function comparescore = compareBOM(keyBOM, studentBOM)
%COMPARE Compares two BOMB and assigns a score for similarity
comparescore = 100;

% Marks Lost Per / Marks Lost total
% Center distance 70 @ half the width of the sheet, 60 max
% numcols 5/25
% numrows 5/25

keyCenter = [(keyBOM.xmax + keyBOM.xmin)/2, (keyBOM.ymax + keyBOM.ymin)/2];
studentCenter = [(studentBOM.xmax + keyBOM.xmin)/2, (keyBOM.ymax + keyBOM.ymin)/2];

positionLoss = min(60, 140*norm(keyCenter - studentCenter)/keyBOM.parent.width);

rowLoss = min(25, 5*abs(keyBOM.numrows - studentBOM.numrows));

colLoss = min(25, 5*abs(keyBOM.numcolumns - studentBOM.numcolumns));

comparescore = comparescore - positionLoss - rowLoss - colLoss;

% Renormalize
comparescore = normalizeScore(comparescore);
end