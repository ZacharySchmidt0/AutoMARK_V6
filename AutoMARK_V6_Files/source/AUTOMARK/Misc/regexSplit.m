function outStrings = regexSplit(baseString, patternString)
%REGEXSPLIT Splits a given base string into a bunch of smaller segments
% iven by regex matches!

% Get the indexes
[beginIndexes, endIndexes] = regexp(baseString, patternString);


% Create a bunch of substrings!
outStrings = extractBetween(repmat(baseString, 1, length(beginIndexes)), beginIndexes, endIndexes);
end

