function comparescore = compareTemplate(keyItem, studentItem)
%COMPARE Compares two ___ and assigns a score for similarity
comparescore = 100;

% Marks Lost Per / Marks Lost total
% Center distance 70 @ half the width of the sheet
% numcols 5/25
% numrows 5/25

%positionLoss = min(70, 140*norm(k


% Renormalize
comparescore = normalizeScore(comparescore);
end