function normalizedscore = normalizeScore(rawscore)
%NORMALIZESCORE Normalized the score so its non negative.

% Plot this on desmos on the domain and range of 0 to 100 to see what it
% does. The basic idea is you don't really want 0's or perfect 100's
% Note: this is a logistic function
normalizedscore = 100 / ( 1 + exp(-(rawscore - 50)/12));
end

