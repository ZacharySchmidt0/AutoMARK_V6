function comparescore = compareSolidModel(keySolidModel, studentSolidModel)
%COMPARESOLIDMODEL Compares two solid models and assigns a score for similarity
comparescore = 100;

% Marks Lost Per / Marks Lost total
% volume            50 @ 10 %
% surface area      50 @ 25 %
% mass              50 @ 10 %

volumeLoss = min(50, 50*abs(keySolidModel.volume - studentSolidModel.volume)/(keySolidModel.volume * 0.1));

surfaceLoss = min(50, 50*abs(keySolidModel.surfacearea - studentSolidModel.surfacearea)/(keySolidModel.surfacearea * 0.25));

massLoss = min(50, 50*abs(keySolidModel.mass - studentSolidModel.mass)/(keySolidModel.mass * 0.1));

% Only 3 things are used!
comparescore = comparescore - volumeLoss - surfaceLoss - massLoss;


% Renormalize
comparescore = normalizeScore(comparescore);
end