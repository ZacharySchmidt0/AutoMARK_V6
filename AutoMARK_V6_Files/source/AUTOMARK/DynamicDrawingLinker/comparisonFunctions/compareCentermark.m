function comparescore = compareCentermark(keyCentermark, studentCentermark)
%COMPARE Compares two centermarks and assigns a score for similarity
comparescore = 100;

% Marks Lost Per / Marks Lost total
% Position (aready a relative measure), 100 for 20% difference to diagonal
% Angle                                 30 for 10 degrees

% Diagonal distance, used for normalization
keyView = keyCentermark.parent;
studentView = studentCentermark.parent;

keyViewDiagonal = norm([keyView.xmax - keyView.xmin, keyView.ymax - keyView.ymin]);
% studentViewDiagonal = norm([studentView.xmax - studentView.xmin, studentView.ymax - studentView.ymin]);

% This is the relative displacement

posDisplacement = moveRelativeToView(hprincipleLocation(studentCentermark), studentView, keyView) - hprincipleLocation(keyCentermark);
posLoss = min(100, 100/0.2*norm(posDisplacement)/keyViewDiagonal);

anglLoss = min(30, 100*abs(keyCentermark.rotationangle - studentCentermark.rotationangle)/0.174533);

comparescore = comparescore - posLoss - anglLoss;

% If they aren't both the same in terms of deletion.
if xor(keyCentermark.isdeleted, studentCentermark.isdeleted)
   % Don't link them
   comparescore = -10; 
end

% Renormalize
comparescore = normalizeScore(comparescore);
end